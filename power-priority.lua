baseEnergyStorage = peripheral.wrap("down")
spsEnergyStorageDirection = "left"

while (true) do
	if (baseEnergyStorage.getEnergyFilledPercentage() >= 0.9) then
		redstone.setOutput(spsEnergyStorageDirection, true)
	else
		redstone.setOutput(spsEnergyStorageDirection, false)
	end
end