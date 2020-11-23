local account = require("account")

Bank = {}
function Bank:new(server_name, password)
    local temp = setmetatable({}, { __index = Bank })
    temp.customers = {}
    temp.pass = password
    temp.name = server_name
    return temp
end
function Bank:ListUsers()
    local res = ""
    for k, v in pairs(self.customers) do
        res = res..v:Info()..'\n'
    end
    return res
end
function Bank:BalRanked()
    local temp = {}
    local res = ""
    
    for _, v in pairs(self.customers) do table.insert(temp, v) end
    table.sort(temp, compare)
    for _,v in pairs(temp) do 
        res = res..v:Info()..'\n'
    end
    return res;
end
function Bank:AddUser(username, password, balance, adminPassword)
    if self.pass ~= adminPassword then
        return "invalid password"
    end
    local temp = Account.new(username, password, balance)
    self.customers[temp:GetID()-1] = temp
    return "User Added"
end
function Bank:RemoveUser(userID, adminPassword)
    if not (self.pass == adminPassword) then
        return "Invalid Password"
    end
    if self.customers[userID] ~= nil then
        self.customers[userID] = nil
        return "User Removed"
    end
    return "That user does not exist"
end
function Bank:SendFunds(amount, from, to, fromPassword)
    if amount < 0 then
        return "amount of money being sent must be positive"
    end
    if not (self.customers[from] ~= nil) then
        return "from number isnt a valid number"
    end
    if not (self.customers[to] ~= nil) then
        return "to number isnt a valid number"
    end
    if not self.customers[from]:IsPassword(fromPassword) then
        return "invalid password for sending account"
    end
    if not self.customers[from]:SubtractMoney(amount) then
        return "amount being sent must be smaller then account balance"
    end
    self.customers[to]:AddMoney(amount)
    return from .." sent " ..to.." $"..amount
end
function Bank:Lookup(userID)
    if self.customers[userID] ~= nil then
        return self.customers[userID]:Info()
    end
    return "We do not have data for that number\n"
end
