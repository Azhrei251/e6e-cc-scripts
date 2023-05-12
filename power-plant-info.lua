TRILLION = 1000000000000
BILLION = 1000000000
MILLION = 1000000
THOUSAND = 1000

ENERGY_UNIT = "RF/t"

REACTOR_PROTOCOL = "reactor"
ENERGY_PROTOCOL = "energy"

rednet.open("left")

reactor_monitor = peripheral.wrap("top")
speaker = peripheral.wrap("right")

reactor_monitor.setTextScale(0.5)
reactor_monitor.clear()

should_sound_alarm = false

local function format_power(raw_power) 
	if (raw_power > TRILLION) then
		return string.format("%.2f", raw_power / TRILLION).."T"..ENERGY_UNIT
	elseif (raw_power > BILLION) then 
		return string.format("%.2f", raw_power / BILLION).."G"..ENERGY_UNIT
	elseif (raw_power > MILLION) then 
		return string.format("%.2f", raw_power / MILLION).."M"..ENERGY_UNIT
	elseif (raw_power > THOUSAND) then 
		return string.format("%.2f", raw_power / THOUSAND).."K"..ENERGY_UNIT
	else
		return string.format("%.2f", raw_power)..ENERGY_UNIT
	end
end

local function sound_alarm()	
	speaker.playSound("tile.machine.industrial_alarm:mekanism")
end

function display_energy_info(energy_info)
	for k,v in pairs(energy_info) do
		if (k == "powerConsumption") then
			powerConsumption = v
		elseif (k == "wastePower") then 
			wastePower = v
		end
	end
	
	reactor_monitor.setCursorPos(1,9)
	reactor_monitor.write("Power consumption: "..format_power(powerConsumption))

	reactor_monitor.setCursorPos(1,10)
	reactor_monitor.write("Power wastage: "..format_power(wastePower))
end

function display_reactor_info(reactor_info)
	for k,v in pairs(reactor_info) do
		if (k == "coolantPercent") then
			coolantPercent = v * 100
		elseif (k == "wastePercent") then 
			wastePercent = v  * 100
		elseif (k == "fuelPercent") then 
			fuelPercent = v  * 100
		elseif (k == "burnRate") then 
			burnRate = v
		elseif (k == "reactorEnabled") then 
			reactorEnabled = v
		end
	end
	
	redstone.setOutput("right", not reactorEnabled)
	
	reactor_monitor.setCursorPos(1,1)
	reactor_monitor.write("Fission reactor info")

	reactor_monitor.setCursorPos(1,3)
	reactor_monitor.write("Reactor running: "..tostring(reactorEnabled))

	reactor_monitor.setCursorPos(1,4)
	reactor_monitor.write("Burn rate: "..tostring(burnRate).." mb/t")

	reactor_monitor.setCursorPos(1,5)
	reactor_monitor.write(string.format("Fuel: %.2f%%", fuelPercent))
	
	reactor_monitor.setCursorPos(1,6)
	reactor_monitor.write(string.format("Waste: %.2f%%", wastePercent))

	reactor_monitor.setCursorPos(1,7)
	reactor_monitor.write(string.format("Coolant: %.2f%%", coolantPercent))
end



print("Monitoring nuclear fission plant")
repeat 
	local id, message, protocol = rednet.receive()
	
	if (protocol == REACTOR_PROTOCOL) then
		display_reactor_info(message)
	elseif (protocol == ENERGY_PROTOCOL) then 
		display_energy_info(message)
	end
until false

