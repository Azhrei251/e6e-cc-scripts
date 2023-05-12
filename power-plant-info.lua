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

local function print_line_to_monitor(monitor, lineNum, text)
	monitor.setCursorPos(1, lineNum)
	monitor.clearLine()
	monitor.write(text)
end

local function format_power(raw_power) 
	if (raw_power > TRILLION) then
		return string.format("%.2f", raw_power / TRILLION).." T"..ENERGY_UNIT
	elseif (raw_power > BILLION) then 
		return string.format("%.2f", raw_power / BILLION).." G"..ENERGY_UNIT
	elseif (raw_power > MILLION) then 
		return string.format("%.2f", raw_power / MILLION).." M"..ENERGY_UNIT
	elseif (raw_power > THOUSAND) then 
		return string.format("%.2f", raw_power / THOUSAND).." K"..ENERGY_UNIT
	else
		return string.format("%.2f", raw_power).." "..ENERGY_UNIT
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
		elseif (k == "spsPower") then 
			spsPower = v
		end
	end
	
	print_line_to_monitor(reactor_monitor, 8, "Base consumption: "..format_power(powerConsumption))

	print_line_to_monitor(reactor_monitor, 9, "SPS Consumption: "..format_power(spsPower))
		
	print_line_to_monitor(reactor_monitor, 10, "Power waste: "..format_power(wastePower))
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
	
	if (reactorEnabled) then
		title = "Fission reactor: Active"
	else
		title = "Fission reactor: Inactive"
	end
	
	print_line_to_monitor(reactor_monitor, 1, title)

	print_line_to_monitor(reactor_monitor, 3, "Burn rate: "..tostring(burnRate).." mb/t")

	print_line_to_monitor(reactor_monitor, 4, string.format("Fuel: %.2f%%", fuelPercent))
	
	print_line_to_monitor(reactor_monitor, 5, string.format("Waste: %.2f%%", wastePercent))

	print_line_to_monitor(reactor_monitor, 6, string.format("Coolant: %.2f%%", coolantPercent))
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

