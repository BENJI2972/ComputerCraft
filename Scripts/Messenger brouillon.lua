--Intro

Mx,My = term.getSize()
Intro = "Welcome to the Messenger App v1.0"

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(math.floor(Mx/2 - #Intro/2),2)
term.write(Intro)

Intro = "This computer is :"
term.setCursorPos(math.floor(Mx/2 - #Intro/2),4)

Intro = "Receiver  <-      ->  Sender"
term.setCursorPos(math.floor(Mx/2 - #Intro/2),7)


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

--function connect

os.loadAPI("myAPI")


--Receiver

		--Research periphs and configure

modemSide = myAPI.ConnectPeriph("modem")
monitor = peripheral.wrap(myAPI.ConnectPeriph("monitor"))
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
		
term.setCursorPos(24,6)
term.write(message)
term.setCursorPos(12,7)
term.write(id)

monitor.setCursorPos(24,6)
monitor.write(message.."    ")
monitor.setCursorPos(12,7)
monitor.write(id.."    ")

end




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

message = read()
rednet.broadcast(message)
		--Draw
		
term.setCursorPos(22,6)
term.write(message)
term.setCursorPos(17,7)
term.write("                                        ")


end