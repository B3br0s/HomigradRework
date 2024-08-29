local ENT = FindMetaTable("Entity")

function ENT:RealisticBlood_Setup()
    self.UsesRealisticBlood = true
    if self:IsPlayer() or self:IsNPC() or self:IsNextBot() then self:SetBloodColor(-1) end
    if self.IsVJBaseSNPC then self.Bleeds = false end
end

function ENT:RealisticBlood_Whitelist()
    if self:IsPlayer() then return true end

    if ( self:IsNPC() or self:IsNextBot() ) && self:GetBloodColor() == BLOOD_COLOR_RED then return true end

    if self.IsVJBaseSNPC && self.CustomBlood_Decal then
        local decals = self.CustomBlood_Decal[1]
        print(decals)
        if decals == "VJ_Blood_Red" or decals == "VJ_L4D_Blood" or decals == "Blood" then return true end
    end
end