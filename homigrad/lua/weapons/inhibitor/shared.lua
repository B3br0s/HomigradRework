if engine.ActiveGamemode() == "homigrad" then
AddCSLuaFile()

SWEP.Base = "medkit"

SWEP.PrintName = "Ингибитор"
SWEP.Author = "Homigrad"
SWEP.Instructions = "РЯДОМ КОНТЕЙНЕР С ИНГИБИТОРОМ"

SWEP.Spawnable = true
SWEP.Category = "Медицина"

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.ViewModel = "models/Items/combine_rifle_ammo01.mdl"
SWEP.WorldModel = "models/Items/combine_rifle_ammo01.mdl"

SWEP.dwsPos = Vector(7,7,7)
SWEP.dwsItemPos = Vector(2,0,2)

SWEP.vbwPos = Vector(0,-1,-12)
SWEP.vbwAng = Angle(0,0,0)
SWEP.vbwModelScale = 1

SWEP.dwmModeScale = 1
SWEP.dwmForward = 4
SWEP.dwmRight = 4
SWEP.dwmUp = -8


SWEP.dwmAUp = 0
SWEP.dwmARight = 0
SWEP.dwmAForward = 0
end