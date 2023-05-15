monitor = peripheral.wrap("right")
methods = peripheral.getMethods("back")

line = 1
for k,v in pairs(methods) do
  monitor.setCursorPos(1, line)
  monitor.write(k..": "..tostring(v))
  line = line + 1
end
