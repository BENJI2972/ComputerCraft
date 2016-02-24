--fonction de detection
function ConnectPeriph(type)	--Connection des peripheriques rentres

	--Preface
	
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(2,2)
term.write("Connecting peripheral...")
term.setCursorPos(2,4)
term.write("Status : A "..type.." is missing.")


local sides = { "top", "bottom", "left", "right", "front", "back" }

while true do
for i = 1, #sides do
  if peripheral.isPresent(sides[i]) then
        if peripheral.getType(sides[i]) == type then
          return sides[i]
        end
  end
end
sleep(1)
end


end