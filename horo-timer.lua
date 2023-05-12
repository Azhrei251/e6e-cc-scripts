local monitor = peripheral.find("monitor")
monitor.setTextScale(0.5)
 
local cycleDay = 2
 
while(true)
do  
    local time = textutils.formatTime(os.time())
    local day = os.day()
    local daysTillHoro = 36 - ((day - cycleDay) % 36)
 
    monitor.setCursorPos(1,1)
    monitor.write("Time: "..time)
 
    monitor.setCursorPos(1,2)
    monitor.write("Day: "..day)
 
    if (daysTillHoro == 0)
    then
        monitor.setTextColor(colors.red)
    else
        monitor.setTextColor(colors.white)
    end
            
    monitor.setCursorPos(1,3)
    monitor.write("Horo in "..daysTillHoro.." days")
    
    monitor.setTextColor(colors.white)
                    
    sleep(1)
end
