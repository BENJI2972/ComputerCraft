if fs.exists("myAPI") == false then
term.setCursorPos(1,1)
term.clear()
term.write("myAPI is missing.")
sleep(1)
term.setCursorPos(1,1)
term.write("Shutting down.")
sleep(1)
os.shutdown()
end

mon = peripheral.wrap(myAPI.ConnectPeriph("monitor"))

function reset()

mon.setTextScale(2)
mon.setBackgroundColor(colors.black)
mon.clear()

end

function affichepercentage()

reset()
monMaxX,monMaxY = mon.getSize()

for i = 2 ,monMaxX-1 do

mon.setBackgroundColor(colors.red)
mon.setCursorPos(i,2)
mon.write(" ")

end

if percentage > 0 then
for i = 2 ,percentage*((monMaxX-2)/100)+1 do

mon.setBackgroundColor(colors.green)
mon.setCursorPos(i,2)
mon.write(" ")

end
end



end



while true do

term.setCursorPos(2,2)
term.clear()
term.write("Percentage : ")
percentage = read()

affichepercentage()

end