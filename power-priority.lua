baseEnergyStorage = peripheral.wrap("bottom")
spsEnergyStorageDirection = "left"

while (true) do
	if (baseEnergyStorage.getEnergyFilledPercentage() >= 0.9) then
		redstone.setOutput(spsEnergyStorageDirection, false)
	else
		redstone.setOutput(spsEnergyStorageDirection, true)
	end
end