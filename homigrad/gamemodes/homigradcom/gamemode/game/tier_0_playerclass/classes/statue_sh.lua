local CLASS = player.RegClass("173")

function CLASS.Off(self)
    if CLIENT then return end

    self.isSCP = nil
end

function CLASS.PlayerDeath(self)

    for i, ply in RandomPairs(getList(self)) do
        break
    end

    self:SetPlayerClass()
    self.NextIdlePlay = nil
    self.RageSCP = false
    self.PlaySound = false
    self.CustomRunSpeed = nil
end

function CLASS.On(self)
    if CLIENT then return end

    self:SetModel("models/scp/173.mdl")
    self:SetWalkSpeed(800)
    self:SetRunSpeed(800)

    self:SetHealth(2500)
    self:SetMaxHealth(2500)

    self:StripWeapon("weapon_hands")
    self:Give("weapon_173")
    self:SelectWeapon("weapon_173")
    self.CustomRunSpeed = 800
    self.PlaySound = false
    self:Freeze(true)
    timer.Simple(0.2,function()
        self.isSCP = true
        self:Freeze(false)
    end)
end

function CLASS.Think(self)
    if CLIENT then return end
    if self.SomeoneLooking == true and self.LastLookedTime > CurTime() then
        self:Freeze(true)
    elseif self.SomeoneLooking == true and self.LastLookedTime < CurTime() then
        self.SomeoneLooking = false
        self:Freeze(false)
    end
end

function CLASS.PlayerStartVoice(self)
    if not self:Alive() then return end

    for i, ply in pairs(player.GetAll()) do
        if ply.isSCP and ply:Alive() then
            ply:ChatPrint("Говорит - "..self:Name())
        end
    end
end

function CLASS.PlayerEndVoice(self)
    for i, ply in pairs(player.GetAll()) do
        if ply.isSCP and ply:Alive() then
            ply:ChatPrint(self:Name().." - Перестал говорить")
        end
    end
end

function CLASS.CanLisenOutput(output, input, isChat)
    if input.isSCP and output:Alive() then return true end
end

function CLASS.CanLisenInput(input, output, isChat)
    if output.isSCP and output:Alive() then return true end
end

function CLASS.HomigradDamage(self, hitGroup, dmgInfo, rag)
end

function CLASS.GuiltLogic(self, ply)
    return false
end