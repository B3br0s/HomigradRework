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

SWEP.ViewModel = "models/weapons/w_arc_vm_medshot_used.mdl"
SWEP.WorldModel = "models/weapons/w_arc_vm_medshot_used.mdl"

SWEP.dwsPos = Vector(7,7,7)
SWEP.dwsItemPos = Vector(2,0,2)

SWEP.vbwPos = Vector(0,-1,-12)
SWEP.vbwAng = Angle(0,0,0)
SWEP.vbwModelScale = 1

SWEP.dwmModeScale = 1
SWEP.dwmForward = 3
SWEP.dwmRight = 2
SWEP.dwmUp = 0


SWEP.dwmAUp = 90
SWEP.dwmARight = 90
SWEP.dwmAForward = 90
end