ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Зиплайн"
ENT.Author = "Homigrad"
ENT.Category = "Homigrad"
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "ConnectedZipline")
end
