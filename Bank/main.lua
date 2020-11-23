local bank = require("bank")
local component = require("component")
local event = require("event")
local serialization = require("serialization")
local m = component.modem

local bankName = "BankName"
local server = Bank:new(bankName, "root")
m.open(1111)

function TypeChecking(type_table, argument_table)
    if #argument_table ~= #type_table then
        return false
    end
    for i = 1, #argument_table,1 do
        if type_table[i] ~= type(argument_table[i]) then
            return false
        end
    end
    
    return true
end

function Save()
    local file = io.open("/home/"..bankName..".txt", "w")
    file:write(serialization.serialize(server.customers))
    file:close()   
end

function Request(params)
    local response = "invalid parameters"
    if (params[1] == "ListUsers") then
        response = server:ListUsers()
    elseif (params[1] == "BalRanked") then
        response = server:BalRanked()
    elseif (params[1] == "AddUser") and (TypeChecking({"string", "string", "string", "number", "string"}, params)) then
        response = server:AddUser(params[2], params[3], params[4], params[5])
        Save()
    elseif (params[1] == "RemoveUser") and (TypeChecking({"string", "number", "string"}, params)) then
        response = server:RemoveUser(params[2], params[3])
        Save()
    elseif (params[1] == "SendFunds") and (TypeChecking({"string", "number", "number", "number", "string"}, params)) then
        response = server:SendFunds(params[2], params[3], params[4], params[5])
        Save()
    elseif (params[1] == "Lookup") and TypeChecking({"string", "number"}, params)) then
        response = server:Lookup(params[2])
    end

    return response
end

function main()
   
    --load  
    local file = io.open("/home/"..bankName..".txt", "r")
    server.customers = serialization.unserialize(file:read("a")) or {}
    file:close() 

    for k, usr in pairs(server.customers) do
        setmetatable(usr, {__index = Account})
        GlobalMembers.idCounter = usr:GetID()
    end
 
    --loop starts
    while true do 
        --wait for request
        local _, _, remoteAddress, _, distance, payload = event.pull("modem_message")
        payload = serialization.unserialize(payload)  
        if type(payload) == "table" then  

            print("valid input from "..remoteAddress)
            m.send(remoteAddress, 11, Request(payload))
            print("response sent")
        else
            print("invalid input from "..remoteAddress)
        end
    end
end

main()
