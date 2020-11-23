Account = {}
function Account.new(username, password, balance)
    local temp = setmetatable({}, { __index = Account })
    temp.usr = username
    temp.pass = password
    temp.bal = balance
    temp.accountID = GlobalMembers.idCounter + 1
    GlobalMembers.idCounter = GlobalMembers.idCounter+1
    return temp
end
function Account:GetID()
    return self.accountID
end
function Account:GetBal()
    return self.bal
end
function Account:GetUsr()
    return self.usr
end
function Account:Info()
    return self.usr .."#" ..self.accountID.. " : $" .. self.bal
end
function Account:IsPassword(password)
    return self.pass == password
end
function Account:SubtractMoney(amount)
    if amount > self.bal then
        return false
    end
    self.bal = self.bal - amount
    return true
end
function Account:AddMoney(amount)
    self.bal = self.bal + amount
end

function compare(a, b)
    return a:GetBal() < b:GetBal()
end

GlobalMembers = {}
GlobalMembers.idCounter = 1
