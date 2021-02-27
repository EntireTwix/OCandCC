local modules = peripheral.find("neuralInterface")

if not modules.hasModule("plethora:sensor") then
	error("Must have an entity sensor", 0)
end
if not modules.hasModule("plethora:laser", 0) then
	error("Must have a laser", 0)
end
if not modules.hasModule("plethora:introspection") then
	error("Must have an introspection module", 0)
end

local player = modules.getMetaOwner()

local whitelist = {}
local file = fs.open("whitelist.txt", "r")
if file then
    local temp = file.readLine()
    while temp do
        whitelist[temp] = true
        temp = file.readLine()
    end
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
local drilling = false
print("Press G to toggle auto-firing")
print("Press T to toggle drilling")


parallel.waitForAny(
    function()
        while true do
            while firing do
                local temp_detected = modules.sense()
    
                local targets = {}
                for _, entity in pairs(temp_detected) do
                    if whitelist[entity.name..' '] == nil and player.id ~= entity.id then
                        table.insert(targets, modules.getMetaByID(entity.id))
                    end
                end
    
                --find nearest
                table.sort(targets, function (a, b)
                    return (math.abs(player.x-a.x)*math.abs(player.y-a.y)*math.abs(player.z-a.z)) < (math.abs(player.x-b.x)*math.abs(player.y-b.y)*math.abs(player.z-b.z))
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
                print("\n[firing toggled to "..tostring(firing).."]\n")
            elseif event == "key" and key == keys.t then
                drilling = not drilling
                print("\n[drilling toggled to "..tostring(drilling).."]\n")
            end
        end
    end,
    function()
        while true do
            player = modules.getMetaOwner()
            if player.isSneaking and drilling == true then
                modules.fire(player.yaw, player.pitch, 5)
            else
                sleep(0)
            end
        end
    end
)
