PROTOCOL = "reactor"

reactor = peripheral.wrap("back")
monitor = peripheral.wrap("right")
rednet.open("top")

monitor.setTextScale(0.5)

print("Monitoring reactor") 
while (true) do
	coolantPercent = reactor.getCoolantFilledPercentage()
	wastePercent = reactor.getWasteFilledPercentage()
	fuelPercent = reactor.getFuelFilledPercentage()
	burnRate = reactor.getBurnRate()
	reactorEnabled = reactor.getStatus()

	if (reactorEnabled and coolantPercent <= 0.1 or wastePercent >= 0.95) then
		reactor.scram()
	end
	 
	messageContent = {
		["coolantPercent"] = coolantPercent,
		["wastePercent"] = wastePercent,
		["fuelPercent"] = fuelPercent,
		["burnRate"] = burnRate,
		["reactorEnabled"] = reactorEnabled,
	}
	rednet.broadcast(messageContent, PROTOCOL)
	
	line = 1
	for k,v in pairs(messageContent) do
		monitor.setCursorPos(1, line)
		monitor.write(k..": "..tostring(v))
		line = line + 1
	end
	
	sleep(0.05)
end