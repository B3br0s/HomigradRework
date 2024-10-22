local CLASS = player.RegClass("cloaker")

function CLASS.Off(self)
    if CLIENT then return end

    self.isCloaker = false
end

function CLASS.On(self)
    if CLIENT then return end

    self:SetModel("models/payday2/units/splinter_cell_cloaker_nvg_player.mdl")
    self:SetWalkSpeed(250)
    self:SetRunSpeed(350)

    self:SetHealth(100)

	self.IsCloaker = true

    self:SetMaxHealth(130)

    self:Give("weapon_hands")
    self:Give("weapon_cloaker_hg")
end

function CLASS.Think(self)
end

function CLASS.HomigradDamage(self, hitGroup, dmgInfo, rag)
    if dmgInfo:GetDamage() > 15 and self:Alive() then
    if self:GetNWEntity("Ragdoll") != NULL then
        self:EmitSound("cloaker/pain" .. math.random(1,3) .. ".wav")
    else
        self:EmitSound("cloaker/pain" .. math.random(1,3) .. ".wav")
    end
end
end

function CLASS.GuiltLogic(self, ply)
    return false
end