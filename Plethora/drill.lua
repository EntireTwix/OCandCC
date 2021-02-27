--yoinked directly from https://plethora.madefor.cc/examples/laser-drill.html
local modules = peripheral.find("neuralInterface")
if not modules then
	error("Must have a neural interface", 0)
end

if not modules.hasModule("plethora:sensor") then
	error("Must have an entity sensor", 0)
end
if not modules.hasModule("plethora:introspection") then
	error("Must have an introspection module", 0)
end
if not modules.hasModule("plethora:laser", 0) then
	error("Must have a laser", 0)
end

while true do
	local meta = modules.getMetaOwner()
	if meta.isSneaking then
		modules.fire(meta.yaw, meta.pitch, 5)
		sleep(0.2)
	else
		sleep(0.1)
	end
end
