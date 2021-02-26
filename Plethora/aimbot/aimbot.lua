local json = require("json")
local modules = peripheral.find("neuralInterface")

if not modules.hasModule("plethora:sensor") then
	error("Must have an entity sensor", 0)
end
if not modules.hasModule("plethora:laser", 0) then
	error("Must have a laser", 0)
end

--filter out self
print("Enter your Username")
local name = io.read()

local whitelist = {}
local file = fs.open("whitelist.json", "r")
if file then
    whitelist = json.decode(file:readAll())
    file.close() 
end

local function fire(entity)
	local x, y, z = entity.x, entity.y, entity.z
	local pitch = -math.atan2(y, math.sqrt(x * x + z * z))
	local yaw = math.atan2(-x, z)
    print("shooting at "..entity.name)
	modules.fire(math.deg(yaw), math.deg(pitch), 5)
end

local firing = false


parallel.waitForAny(
    function()
        while true do
            while firing do
                local temp_detected = modules.sense()
    
                local targets = {}
                local player
                for _, entity in pairs(temp_detected) do
                    if entity.name ~= name then
                        if whitelist[entity.name] == nil then
                            --print("enemy "..entity.name)
                            table.insert(targets, modules.getMetaByID(entity.id))
                        end
                    else 
                        player = entity
                    end
                end
    
                --find nearest
                table.sort(targets, function (a, b)
                    return (math.abs(player.x-a.x)*(math.abs(player.y-a.y)*1.5)*math.abs(player.z-a.z)) < (math.abs(player.x-b.x)*(math.abs(player.y-b.y)*1.5)*math.abs(player.z-b.z))
                end)
    
                if targets[1] then
                    fire(targets[1])
                end
            end 
            os.sleep(0) --to prevent too long without yield error
        end
    end,
    function()
        while true do
            local event, key = os.pullEvent()
            if event == "key" and key == keys.g then
                firing = not firing 
                print("firing toggled to "..tostring(firing))
            end
        end
    end
)
