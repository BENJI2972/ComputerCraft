peripheral.isPresent("left") : return true if a peripheral is on the left side

peripheral.getType("right") : return "monitor" if there is a monitor on the right side
				But print nothing if there is anything in the right side

methods = peripheral.getMethods("left")



local sides = { "top", "bottom", "left", "right",
"front", "back" }


local sides = { "top", "bottom", "left", "right", "front", "back" }

print("Finding monitors...")
for i = 1, #sides do
  if peripheral.isPresent(sides[i]) then
        if peripheral.getType(sides[i]) == "monitor" then
          print("Found: "..sides[i])
        end
  end
end









--fonction de detection
function ConnectPeriph(type1,type2,type3,type4,type5,type6)	--Connection des périphériques rentrés


Types = {type1,type2,type3,type4,type5,type6}
TypesNumber = 6
	--Préface
	
term.setCursorPos(2,2)
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.write("Connecting peripherals...")

for i = 1,6 do

if Types(i) == nill then
TypesNumber = TypesNumber - 1
end

next








function connect(type1,type2,type3,type4) --type in

local sides = { "top", "bottom", "left", "right", "front", "back" }
for i = 1, #sides do
  if peripheral.isPresent(sides[i]) then
        if peripheral.getType(sides[i]) == sid then
          return sides(i)
	else
	return 1
        end
  end
end

end


end