if engine.ActiveGamemode() == "homigrad" then
AddCSLuaFile()

SWEP.Base = "medkit"

SWEP.PrintName = "Антидот"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Убирает нейротоксин из организма."

SWEP.Spawnable = true
SWEP.OpenCapSound = "arc9_eft_shared/shells/12cal_shell_concrete1.ogg"
SWEP.Category = "Медицина"

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.ViewModel = "models/bloocobalt/l4d/items/w_eq_adrenaline.mdl"
SWEP.WorldModel = "models/bloocobalt/l4d/items/w_eq_adrenaline.mdl"

SWEP.dwsPos = Vector(15,15,5)
SWEP.dwsItemPos = Vector(0,0,2)

SWEP.vbwPos = Vector(-2,-1.5,-7)
SWEP.vbwAng = Angle(-90,90,180)
SWEP.vbwModelScale = 0.8

SWEP.vbwPos2 = Vector(-3,0.2,-7)
SWEP.vbwAng2 = Angle(-90,90,180)

function SWEP:vbwFunc(ply)
    local ent = ply:GetWeapon("medkit")
    if ent and ent.vbwActive then return self.vbwPos,self.vbwAng end
    return self.vbwPos2,self.vbwAng2
end
end