PROTOCOL="energy"

rednet.open("top")

spsMeter = peripheral.wrap("right")
wasteMeter = peripheral.wrap("front")
usageMeter = peripheral.wrap("left")

print("Monitoring turbine power output") 
while (true) do
	powerConsumption = usageMeter.getTransferRate()
	wastePower = wasteMeter.getTransferRate()
	spsPower = spsMeter.getTransferRate()

	messageContent = {
		["powerConsumption"] = powerConsumption,
		["wastePower"] = wastePower,
		["spsPower"] = spsPower,
	}
	rednet.broadcast(messageContent, PROTOCOL)
	
	sleep(0.05)
end