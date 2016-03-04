--Intro
if fs.exists("myAPI") == false then
print("Missing myAPI. closing ..")
sleep(2)
term.setCursorPos(1,1)
term.clear()
error()
end


Mx,My = term.getSize()
Intro = "Welcome to the Messenger App v1.0"

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(math.floor(Mx/2 - #Intro/2),2)
term.write(Intro)

term.setCursorPos(math.floor(Mx/2 - #Intro/2),4)
term.write("This computer is :")

term.setCursorPos(math.floor(Mx/2 - #Intro/2),7)
term.write("Receiver  <-      ->  Sender")


--KeyCapture, Determine type of computer

function rawread()
while true do
local sEvent, param = os.pullEvent("key")
if sEvent == "key" then
if param == 203 then
computer = "receiver"
break
elseif param == 205 then
computer = "sender"
break
end
end
end
end

rawread()

--function connect

os.loadAPI("myAPI")

if computer == "receiver" then

--Receiver

		--Research periphs and configure

modemSide = myAPI.ConnectPeriph("modem")
monitor = peripheral.wrap(myAPI.ConnectPeriph("monitor"))
rednet.open(modemSide)

		--Preface
Mx,My = term.getSize()
Intro = "Welcome to the Messenger App v1.0"

monitor.setTextScale(0.5)
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)
monitor.clear()

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(math.floor(Mx/2 - #Intro/2),2)
term.write(Intro)

term.setCursorPos(2,4)
Intro = "Computer Type : Receiver"
term.write(Intro)

term.setCursorPos(2,6)
Intro = "Last Message received : nill"
term.write(Intro)
term.setCursorPos(2,7)
Intro = "Sender ID : nill"
term.write(Intro)


monitor.setCursorPos(2,2)
monitor.write("Last Message received : nill")
monitor.setCursorPos(2,4)
monitor.write("Sender ID : nill")

while true do

		--Research

id,message = rednet.receive()

		--Draw
		
term.setCursorPos(26,6)
term.write(message.."                  ")
term.setCursorPos(14,7)
term.write(id.."       ")

monitor.setCursorPos(26,2)
monitor.write(message.."                     ")
monitor.setCursorPos(14,4)
monitor.write(id.."     ")

end


elseif computer == "sender" then

--Sender

		--Research periphs and configure

modemSide = myAPI.ConnectPeriph("modem")
rednet.open(modemSide)

		--Preface
Mx,My = term.getSize()
Intro = "Welcome to the Messenger App v1.0"

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(math.floor(Mx/2 - #Intro/2),2)
term.write(Intro)

term.setCursorPos(2,4)
Intro = "Computer Type : Sender"
term.write(Intro)

term.setCursorPos(2,6)
Intro = "Last Message sended : nill"
term.write(Intro)
term.setCursorPos(2,7)
Intro = "Type your text : "
term.write(Intro)


while true do

		--Research and send
term.setCursorPos(19,7)
message = read()
rednet.broadcast(message)
		--Draw
		
term.setCursorPos(24,6)
term.write(message)
term.setCursorPos(19,7)
term.write("                                        ")


end

end