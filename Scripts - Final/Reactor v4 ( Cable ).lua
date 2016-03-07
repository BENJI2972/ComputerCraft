	-- Reactor v4.0 Cable Edition


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
	
	-- Variables
	
	checker = 70
	allowed = false
	alarm = false
	
	file = fs.open("save","r")
	
	if file == nil then
	
		file = fs.open("save","w")
		
		signalside = BenAPI.RedstoneSide("signalside","1/6")
		monitorname = BenAPI.PeriphName("monitor","2/6")
		batteryname = BenAPI.PeriphName("battery","3/6")
		alarmside = BenAPI.RedstoneSide("alarmside","4/6")
		reactorname = BenAPI.PeriphName("reactor","5/6")
		buttonside = BenAPI.RedstoneSide("buttonside","6/6")
		
		monitor = peripheral.wrap(monitorname)
		battery = peripheral.wrap(batteryname)
		reactor = peripheral.wrap(reactorname)
		
		
		file.writeLine(signalside)
		file.writeLine(monitorname)
		file.writeLine(batteryname)
		file.writeLine(alarmside)
		file.writeLine(reactorname)
		file.writeLine(buttonside)
		
		file.close()
		
	else
	
		signalside = file.readLine()
		monitor = peripheral.wrap(file.readLine())
		battery = peripheral.wrap(file.readLine())
		alarmside = file.readLine()
		reactor = peripheral.wrap(file.readLine())
		buttonside = file.readLine()
		
		file.close()
		
	end

	
	function manage()
		
		while true do
			
			reactorOutput = reactor.getEUOutput() * 5
			reactorStatut = reactor.isActive()
			
			maxEnergy = battery.getMaxEnergyStored()
			storedEnergy = battery.getEnergyStored()
			
			if storedEnergy ~= nil and maxEnergy ~= nil then
			
				percentStored = math.floor(storedEnergy/(maxEnergy/100))
				maxEnergy = math.floor(maxEnergy)
				storedEnergy = math.floor(storedEnergy)
			
			end
			
			if percentStored > 98 then
				allowed = false
			elseif percentStored < checker then
				allowed = true
			end
			
			if allowed == true then
				rs.setOutput(signalside,true)
			else
				rs.setOutput(signalside,false)
			end
			
			sleep(0.5)
			
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
		monitor.setCursorPos(2,13)
		monitor.write("Statut : ")
		monitor.setCursorPos(2,14)
		monitor.write("Alarm : ")
		
		-- Data writing
		
		while true do
			
			if (storedEnergy ~= nil and reactorOutput ~= nil) then
			
								
				monitor.setBackgroundColor(colors.black)
				
				monitor.setCursorPos(20,4)
				monitor.write(maxEnergy.." RF				")
				monitor.setCursorPos(20,5)
				monitor.write(storedEnergy.." RF				")
				monitor.setCursorPos(20,6)
				monitor.write(percentStored.." %				")
				monitor.setCursorPos(20,8)
				monitor.write(checker.." %				")
				monitor.setCursorPos(20,11)
				monitor.write(reactorOutput.." EU/T				")
				
				if percentStored < 25 then
					monitor.setCursorPos(20,2)
					monitor.setBackgroundColor(colors.red)
					monitor.write(" BAD  ")
				elseif percentStored > 25 then
					monitor.setCursorPos(20,2)
					monitor.setBackgroundColor(colors.green)
					monitor.write(" GOOD ")
				end
				
				
				if reactorStatut == false then
					monitor.setCursorPos(20,10)
					monitor.setBackgroundColor(colors.red)
					monitor.write(" disable ")
				elseif reactorStatut == true then
					monitor.setCursorPos(20,10)
					monitor.setBackgroundColor(colors.green)
					monitor.write(" active  ")
				end
				
				
				if alarm == true then
					 monitor.setCursorPos(9,14)
					 monitor.setBackgroundColor(colors.green)
					 monitor.write("Yes")
				else
					 monitor.setCursorPos(9,14)
					 monitor.setBackgroundColor(colors.red)
					 monitor.write("No ")
				 end
			
			end
		
		sleep(0.3)
		
		end
				
	
	end
	
	
	function statut()
	
		
		while true do
		
			monitor.setCursorPos(10,13)
			monitor.setBackgroundColor(colors.black)
			monitor.write("|")
			sleep(0.4)
			monitor.setCursorPos(10,13)
			monitor.setBackgroundColor(colors.black)
			monitor.write("/")
			sleep(0.4)
			monitor.setCursorPos(10,13)
			monitor.setBackgroundColor(colors.black)
			monitor.write("-")
			sleep(0.4)
			monitor.setCursorPos(10,13)
			monitor.setBackgroundColor(colors.black)
			monitor.write("\\")
			sleep(0.4)
		
		end
	
	end
	
	
	function alarm()
	
	while true do
	
		if rs.getInput(buttonside) then
			alarm = not(alarm)
			sleep(2)
		end
		
		if (alarm == true and   (reactorStatut == true and reactorOutput == 0)   )  then
			rs.setOutput(alarmside,true)
		else
			rs.setOutput(alarmside,false)
		end
		
		sleep(0.5)
	end
		
	
	end
	
	
	parallel.waitForAll(manage,monitoring,statut,alarm)