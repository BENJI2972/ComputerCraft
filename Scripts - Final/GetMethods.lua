monitor = peripheral.wrap("monitor_3")
 
local side = "left"
local methods = peripheral.getMethods(side)
monitor.setTextScale(0.5)
monitor.setCursorPos(1,1)
monitor.clear()
for i = 1, #methods do
 monitor.write( i.." = "..methods[i] )
 oldx, oldy = monitor.getCursorPos()
  monitor.setCursorPos(1,oldy+1)
 
end