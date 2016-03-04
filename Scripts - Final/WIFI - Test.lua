	if fs.exists("BenAPI") == false then
		print("Missing BenAPI. closing ..")
		sleep(2)
		term.setCursorPos(1,1)
		term.clear()
		error()
	else
		os.loadAPI("BenAPI")
	end

	monitor = peripheral.wrap(BenAPI.PeriphName("monitor","1/1"))
	
	
	function un()
	
	blabla = read()
	
	end
	
	
	function deux()
	
	if blabla ~= nil then
	monitor.setCursorPos(1,1)
	monitor.clear()
	monitor.write(blabla)
	end
	
	end
	
	parallel.waitForAll(un,deux)