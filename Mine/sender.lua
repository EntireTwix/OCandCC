local component = require("component")
local event = require("event")
local sides = require("sides")
local modem = component.modem
local button = component.redstone

while true do
    if button.getInput(sides.front) > 0 then
        modem.broadcast(911, "boom")
    end    

end
