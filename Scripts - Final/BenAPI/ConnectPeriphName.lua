	-- PeriphGetName	
	
	function ConnectPeriphName(name,state)

		repeat
		
		term.setBackgroundColor(colors.black)
		term.setTextColor(colors.white)
		term.clear()
		term.setCursorPos(2,2)
		term.write("Connecting peripheral "..state)
		term.setCursorPos(2,4)
		term.write(name.."  = ")
		
		Periph = read()
		
		until peripheral.isPresent(Periph) == true
		
		return peripheral.wrap("Periph")

	end