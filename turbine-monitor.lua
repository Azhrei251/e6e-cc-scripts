PROTOCOL="energy"

rednet.open("top")

wasteMeter = peripheral.wrap("right")
usageMeter = peripheral.wrap("left")

print("Monitoring turbine power output") 
while (true) do
	powerConsumption = wasteMeter.getTransferRate()
	wastePower = usageMeter.getTransferRate()

	messageContent = {
		["powerConsumption"] = powerConsumption,
		["wastePower"] = wastePower,
	}
	rednet.broadcast(messageContent, PROTOCOL)
	
	sleep(0.05)
end