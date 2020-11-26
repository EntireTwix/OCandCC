local m = peripheral.wrap("back")

local commands = {
    {"ListUsers",{}},
    {"BalRanked",{}},
    {"SendFunds",{"amount", "from ID", "to ID", "from's password"}},
    {"Lookup",{"ID"}},
    {"AddUser",{"username", "password", "balance", "admin pass"}},
    {"RemoveUser",{"ID", "admin pass"}},
}
    
for k,v in pairs(commands) do
    print(k..") "..v[1])
end

print("\nselect command by #")
local indx = tonumber(io.read())
local msg = {commands[indx][1]}

local temp
for n=1,#commands[indx][2] do
    print("input "..commands[indx][2][n])
    temp = io.read()
    if tonumber(temp) ~= nil then
        temp = tonumber(temp)
    end
    table.insert(msg, temp)
end

local p = math.random(65535)
m.open(p)
m.transmit(1111, p, "ping")
local _,_,_,rc,_,_ = os.pullEvent("modem_message")
m.close(p)

local p = math.random(65535)
m.open(p)
m.transmit(rc, p, msg)
local _,_,_,_,message,_ = os.pullEvent("modem_message")
m.close(p)

print(message)
