	-- Battery v3 Cable Edition
	
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
	
	
	-- Save Checker
	
	file = fs.open("save","r")
	
	if file == nil then
	
		file = fs.open("save","w")
		
		monside = BenAPI.RedstoneSide("Monitor","1/4")
		cellside = BenAPI.RedstoneSide("LoadBattery","2/4")
		diskside = BenAPI.RedstoneSide("Disk","3/4")
		maincellname = BenAPI.PeriphName("MainCell","4/4")
		
		mon = peripheral.wrap(monside)
		cell = peripheral.wrap(cellside)
		disk = peripheral.wrap(diskside)
		maincell = peripheral.wrap(maincellname)
		
		file.writeLine(monside)
		file.writeLine(cellside)
		file.writeLine(diskside)
		file.writeLine(maincellname)
		
		file.close()
	
	else
	
		monside = file.readLine()
		cellside = file.readLine()
		diskside = file.readLine()
		maincell = peripheral.wrap(file.readLine())
		
		mon = peripheral.wrap(monside)
		cell = peripheral.wrap(cellside)
		disk = peripheral.wrap(diskside)
		
		file.close()
	
	end
		

	
	 
	while true do
	 
		 if ( cell == nil or cell.getEnergyStored() == nil ) then
		 
			 term.setCursorPos(1,1)
			 term.clear()
			 write("Searching Energy cell..")
			 mon.setCursorPos(1,1)
			 mon.setTextScale(2)
			 mon.write("Standby")
			disk.stopAudio()
			play = false

			 while (cell == nil or cell.getEnergyStored() == nil) do
			 
				 cell = peripheral.wrap("right")
				 sleep(1)
			 
			 end
			 
			 disk.stopAudio()
			 play = false
			 max = cell.getMaxEnergyStored
		 
		 end
		 
		 
		 -- GET
		energy = cell.getEnergyStored()
		energyper = energy/(max/100)



		maincellMax = maincell.getMaxEnergyStored()
		maincellStored = maincell.getEnergyStored()
		maincellPercent = maincellStored/(maincellMax/100)

		 
		 --Term write
		term.setCursorPos(1,1)
		write("Energy percent : "..energyper)
		sleep(1)
		term.clear()
		 
		--Manage
		if (energyper > 99  and play == false) then
			disk.playAudio()
			play = true
		elseif energy<99 then
			disk.stopAudio()
			play = false
		end

		
		if maincellPercent<50 then
			rs.setOutput("back",true)
		elseif maincellPercent > 75 then
			rs.setOutput("back",false)
		end
		 
		 
		 --Monitor write
		energyper = math.floor(energyper)
		mon.clear()
		mon.setTextScale(4)
		mon.setCursorPos(1,1)
		mon.write(energyper.."%")
	 
	end