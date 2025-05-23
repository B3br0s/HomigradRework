SWEP.IconPos = Vector(0,0,0)
SWEP.IconAng = Angle(0,0,0)
SWEP.WepSelectIcon2 = Material("null")
SWEP.IconOverride = ""

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
    hg.DrawWeaponSelection(self,x,y,wide,tall,alpha)
end