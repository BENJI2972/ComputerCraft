monitor = peripheral.wrap("monitor_2")
reactor = peripheral.wrap("nuclear_reactor_0")
battery = peripheral.wrap("immersiveengineering_capacitorhv_0")
PercentCritic = 80




function getAff()

MaxEnergy = battery.getMaxEnergyStored()
StoredEnergy = battery.getEnergyStored()
PercentStored = StoredEnergy/(MaxEnergy/100)

monitor.setTextScale(1)
monitor.clear()

--Preface

monitor.setCursorPos(1,1)
monitor.write("Max Energy     :")
monitor.setCursorPos(1,2)
monitor.write("Stored Energy  :")
monitor.setCursorPos(1,3)
monitor.write("Percent Stored :")
monitor.setCursorPos(1,5)
monitor.write("Reactor        :")

--Write (18)

monitor.setCursorPos(18,1)
monitor.write(MaxEnergy)
monitor.setCursorPos(18,2)
monitor.write(StoredEnergy)
monitor.setCursorPos(18,3)
monitor.write(PercentStored)
monitor.setCursorPos(18,5)
monitor.write(reactor.isActive())

end


function ProduceRegulation()

if PercentStored > 98 then
redstone.setOutput("right", false)
elseif PercentStored < PercentCritic then
redstone.setOutput("right",true)
end

end



while true do

getAff()
ProduceRegulation()
sleep(1)

end
