mon = peripheral.wrap("bottom")
cell = peripheral.wrap("right")
disk = peripheral.wrap("left")

maincell = peripheral.wrap("immersiveengineering_capacitorhv_1")


if(cell ~= nil and cell.getEnergyStored() ~= nil) then
max = cell.getMaxEnergyStored()
 end
 play = false
 
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