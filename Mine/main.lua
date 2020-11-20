local component = require("component")
local event = require("event")
local sides = require("sides")
local m = component.motion_sensor
local modem = component.modem
local lamp = component.redstone

modem.open(911)
m.setSensitivity(1)
local running = true

function ArmCheck() 
    lamp.setOutput(sides.bottom, 15)
    lamp.setOutput(sides.bottom, 0)
    event.ignore("modem_message", ArmCheck)
    event.ignore("motion", ArmCheck)
    running = false
end

event.listen("modem_message", ArmCheck)
event.listen("motion", ArmCheck)

os.sleep(2) --time given to run away when setting up

while running do 
    local temp = 0
    for k, v in component.list() do 
        temp = temp + 1
    end
    if temp ~= 20 then 
        ArmCheck()
    end
    os.sleep(0.1)
end
