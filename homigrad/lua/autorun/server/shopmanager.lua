local cashSystem = {}
local cashDataFolder = "cash_data/"

local function getPlayerDataFilePath(ply)
    return cashDataFolder .. ply:SteamID64() .. ".txt"
end

function cashSystem:LoadPlayerCash(ply)
    if not file.Exists(cashDataFolder, "DATA") then
        file.CreateDir(cashDataFolder)
    end

    local filePath = getPlayerDataFilePath(ply)
    
    if file.Exists(filePath, "DATA") then
        local cash = tonumber(file.Read(filePath, "DATA"))
        if cash then
            ply:SetNWInt("PlayerCash", cash)
        else
            ply:SetNWInt("PlayerCash", 0)
        end
    else
        ply:SetNWInt("PlayerCash", 0)
    end
end

function cashSystem:SavePlayerCash(ply)
    local cash = ply:GetNWInt("PlayerCash", 0)
    local filePath = getPlayerDataFilePath(ply)
    file.Write(filePath, tostring(cash))
end

function cashSystem:GetCash(ply)
    return ply:GetNWInt("PlayerCash", 0)
end

function cashSystem:AddCash(ply, amount)
    local currentCash = self:GetCash(ply)
    local newCash = currentCash + amount
    ply:SetNWInt("PlayerCash", newCash)
    self:SavePlayerCash(ply)
end

function cashSystem:SubtractCash(ply, amount)
    local currentCash = self:GetCash(ply)
    local newCash = math.max(currentCash - amount, 0)
    ply:SetNWInt("PlayerCash", newCash)
    self:SavePlayerCash(ply)
end

function cashSystem:SetCash(ply, amount)
    ply:SetNWInt("PlayerCash", amount)
    self:SavePlayerCash(ply)
end

hook.Add("PlayerInitialSpawn", "LoadPlayerCash", function(ply)
    cashSystem:LoadPlayerCash(ply)
end)

hook.Add("PlayerDisconnected", "SavePlayerCash", function(ply)
    cashSystem:SavePlayerCash(ply)
end)

concommand.Add("hg_give_cash", function(ply, cmd, args)
    if ply:IsAdmin() then
    if not args[1] then return end
    local amount = tonumber(args[1])
    if amount then
        cashSystem:AddCash(ply, amount)
        ply:ChatPrint("Добавлено " .. amount .. " Монет. Новый Баланс: " .. cashSystem:GetCash(ply))
    end
end
end)

concommand.Add("hg_remove_cash", function(ply, cmd, args)
    if ply:IsAdmin() then
        if not args[1] then return end
        local amount = tonumber(args[1])
        if amount then
            cashSystem:SubtractCash(ply, amount)
            ply:ChatPrint("Убрано " .. amount .. " Монет. Новый Баланс: " .. cashSystem:GetCash(ply))
        end 
    end
end)
