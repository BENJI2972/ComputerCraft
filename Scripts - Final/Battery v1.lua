mon = peripheral.wrap("bottom")
cell = peripheral.wrap("left")
disk = peripheral.wrap("right")
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
 
 cell = peripheral.wrap("left")
 sleep(1)
 
 end
 disk.stopAudio()
 play = false
 max = cell.getMaxEnergyStored
 
 end
 
 
 -- GET
energy = cell.getEnergyStored()
energyper = energy/(max/100)
 
 --Term write
term.setCursorPos(1,1)
write("Energy percent : "..energyper)
sleep(1)
term.clear()
 
--Manage
if energyper > 99  and play = false then
disk.playAudio()
play = true
elseif energy<99 then
disk.stopAudio()
play = false
end
 
 --Monitor write
energyper = math.floor(energyper)
mon.clear()
mon.setTextScale(4)
mon.setCursorPos(1,1)
mon.write(energyper.."%")
 
end