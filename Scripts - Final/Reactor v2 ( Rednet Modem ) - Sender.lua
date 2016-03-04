	-- API Checker

	if fs.exists("BenAPI") == false then
		print("Missing BenAPI. closing ..")
		sleep(2)
		term.setCursorPos(1,1)
		term.clear()
		error()
	else
		os.loadAPI("BenAPI")
	end
	
	
	allowed = false
	modemSide = BenAPI.PeriphSide("modem","1/2")
	reactor = peripheral.wrap(BenAPI.PeriphSide("reactor","2/2"))
	
	rednet.open(modemSide)
		
	function getReactorStatut()
		
		while true do
		
		reactorOutput = reactor.getEUOutput() * 5
		reactorStatut = reactor.isActive()
		sleep(0.1)
		
		end
		
	end
	
	function sendReactorStatut()
		
		while true do
		
		rednet.broadcast(reactorOutput,reactorStatut)
		sleep(0.1)
		
		end
		
	end
	
	function getMessage()
	
		while true do
		
			id,allowed = rednet.receive()
			sleep(0.1)
		
		end
	
	end
	
	function setPower()
		
		while true do
		
			if allowed == true then
				rs.setOutput("back",true)
			else
				rs.setOutput("back",false)
			end
			
			sleep(0.1)
		
		end
	
	end
	
	
	parallel.waitForAll(getReactorStatut,sendReactorStatut,getMessage,setPower)