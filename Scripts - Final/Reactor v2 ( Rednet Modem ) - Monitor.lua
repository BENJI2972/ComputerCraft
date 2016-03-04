
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
	
	checker = 70
	allowed = false
	
	modemSide = BenAPI.PeriphSide("modem","1/3")
	monitor = peripheral.wrap(BenAPI.PeriphName("monitor","2/3"))
	battery = peripheral.wrap(BenAPI.PeriphName("battery","3/3"))
	
	rednet.open(modemSide)
		
		
	
	function manage()
		
		while true do
		
			maxEnergy = battery.getMaxEnergyStored()
			storedEnergy = battery.getEnergyStored()
			
			if storedEnergy ~= nil and maxEnergy ~= nil then
			
				percentStored = math.floor(storedEnergy/(maxEnergy/100))
				maxEnergy = math.floor(battery.getMaxEnergyStored())
				storedEnergy = math.floor(battery.getEnergyStored())
			
			end
			
			if percentStored > 98 then
				allowed = false
			elseif percentStored < checker then
				allowed = true
			end
			
			sleep(0.1)
			
		end
	
	end
	
		
	function sendAllowed()
		
		while true do
		
		rednet.broadcast(allowed)
		sleep(0.1)
		
		end
		
	end
	
	
	function getMessage()
	
		while true do
		
			id,reactorOutput,reactorStatut = rednet.receive()
			sleep(0.1)
		
		end
	
	end
	
	
	function monitoring()
	
		-- Initializing monitor
		
		monitor.setTextScale(1)
		monitor.setTextColor(colors.white)
		monitor.setBackgroundColor(colors.black)
		monitor.clear()
		
		-- Preface
		
		monitor.setCursorPos(2,2)
		monitor.write("Battery statut  : ")
		monitor.setCursorPos(2,4)
		monitor.write("Max Energy      : ")
		monitor.setCursorPos(2,5)
		monitor.write("Stored Energy   : ")
		monitor.setCursorPos(2,6)
		monitor.write("Percent Stored  : ")
		monitor.setCursorPos(2,8)
		monitor.write("Checker         : ")
		monitor.setCursorPos(2,10)
		monitor.write("Reactor Statut  : ")
		monitor.setCursorPos(2,11)
		monitor.write("Reactor Output  : ")
		
		-- Data writing
		
		while true do
			
			if (storedEnergy ~= nil and reactorOutput ~= nil) then
			
								
				monitor.setBackgroundColor(colors.black)
				
				monitor.setCursorPos(28,4)
				monitor.write(maxEnergy.." RF")
				monitor.setCursorPos(28,5)
				monitor.write(storedEnergy.." RF")
				monitor.setCursorPos(28,6)
				monitor.write(percentStored.." %")
				monitor.setCursorPos(28,8)
				monitor.write(checker)
				monitor.setCursorPos(28,11)
				monitor.write(reactorOutput.." EU/T")
				
				if percentStored < 25 then
					monitor.setCursorPos(28,2)
					monitor.setBackgroundColor(colors.red)
					monitor.write(" BAD  ")
				elseif percentStored > 25 then
					monitor.setCursorPos(28,2)
					monitor.setBackgroundColor(colors.green)
					monitor.write(" GOOD ")
				end
				
				
				if reactorStatut == false then
					monitor.setCursorPos(28,10)
					monitor.setBackgroundColor(colors.red)
					monitor.write(" disable ")
				elseif reactorStatut == true then
					monitor.setCursorPos(28,10)
					monitor.setBackgroundColor(colors.green)
					monitor.write(" active  ")
				end
			
			end
		
		sleep(0.1)
		
		end
				
	
	end
	
	parallel.waitForAll(manage,sendAllowed,getMessage,monitoring)