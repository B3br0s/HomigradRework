local CLASS = player.RegClass("096")

function CLASS.Off(self)
    if CLIENT then return end

    self.isSCP = nil
end

function CLASS.PlayerDeath(self)
    self:GetNWEntity("Ragdoll"):EmitSound("scp/096/unrage.wav")

    for i, ply in RandomPairs(getList(self)) do
        break
    end

    self:StopSound("scp/096/idle.wav")
    self:StopSound("scp/096/rage_loop.wav")

    self:SetPlayerClass()
    self.NextIdlePlay = nil
    self.RageSCP = false
    self.PlaySound = false
    self.CustomRunSpeed = nil
end

function CLASS.On(self)
    if CLIENT then return end

    self:SetModel("models/player/scp096.mdl")
    self:SetWalkSpeed(100)
    self:SetRunSpeed(100)

    self:SetHealth(3500)
    self:SetMaxHealth(3500)

    self:StripWeapon("weapon_hands")
    self:Give("weapon_096")
    self:SelectWeapon("weapon_096")
    self.CustomRunSpeed = 100
    self.NextIdlePlay = 0
    self.PlaySound = false
    self:Freeze(true)
    timer.Simple(0.2,function()
        self.isSCP = true
        self:Freeze(false)
    end)
end

function CLASS.Think(self)
    if CLIENT then return end
    if not self:Alive() then
        self:StopSound("scp/096/rage_loop.wav")
    end
    if not self.RageSCP then
        self:StopSound("scp/096/rage_loop.wav")
    end
    if !self.RageSCP then
        self.PlaySound = false
        self.CustomRunSpeed = 100
    else
        if not self.PlaySound then
            self:StopSound("scp/096/idle.wav")
            self:EmitSound("scp/096/rage_loop.wav")
            self.PlaySound = true
        end
    end
    if self.NextIdlePlay < CurTime() and not self.RageSCP then
    self.NextIdlePlay = CurTime() + 21
    self:EmitSound("scp/096/idle.wav")
    end
    if self.RageSCP then
        self:SetRunSpeed(600)
        self:SetWalkSpeed(600)
        self.CustomRunSpeed = nil
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