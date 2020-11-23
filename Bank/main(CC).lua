local bank = require("bank")
local serialization = textutils
local m = peripheral.wrap( "top" )

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
    local file = io.open(bankName..".txt", "w")
    file:write(serialization.serialise(server.customers))
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
    elseif (params[1] == "Lookup") and (TypeChecking({"string", "number"}, params)) then
        response = server:Lookup(params[2])
    end

    return response
end

function main()
   
    --load 
    --print("loading") 
    local file = fs.open(bankName..".txt", "r")
    server.customers = serialization.unserialise(file.readAll()) or {}
    file:close() 

    for k, usr in pairs(server.customers) do
        setmetatable(usr, {__index = Account})
        GlobalMembers.idCounter = usr:GetID()
    end
 
    --loop starts
    while true do 
        --wait for request
        --print("wainting for request")
        local _, _, _, replyChannel, payload, distance = os.pullEvent("modem_message")  
        --print("got input")
        if replyChannel == 1111 then
            payload = nil
        end
        if type(payload) == "table" then  
            
            --print("valid input from somebody")
            m.transmit(replyChannel, 1111, Request(payload))
        else
            --print("invalid input from somebody")
            m.transmit(replyChannel, 1111, "input type must be a table") 
        end
        --print("response sent")
    end
end

main()
