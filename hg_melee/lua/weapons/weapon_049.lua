SWEP.PrintName = "Руки 049"
SWEP.Category = "SCP"
SWEP.Spawnable = true
SWEP.Base = 'hg_melee'

SWEP.WorldModel = " "
SWEP.ViewModel =  " "

SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = "none"

SWEP.HardAttack = false
SWEP.Damage = 1e8
SWEP.DamageType = DMG_CLUB
SWEP.Delay = 0.5
SWEP.StaminaCost = 0
SWEP.CustomAnim = true
SWEP.HoldType = "normal"
SWEP.TimeUntilHit = 0.2
SWEP.TwoHanded = true
SWEP.KeyCardClass = 3
SWEP.ShouldDecal = false
SWEP.DeploySound = {"weapons/melee/melee_draw_temp1.wav","weapons/melee/melee_draw_temp2.wav"}
SWEP.HolsterSound = {"weapons/melee/melee_holster_temp1.wav","weapons/melee/melee_holster_temp2.wav"}
SWEP.SwingSound = {"weapons/melee/swing_light_blunt_01.wav","weapons/melee/swing_light_blunt_02.wav","weapons/melee/swing_light_blunt_03.wav"}
SWEP.HitFleshSound = {" "," "," "}
SWEP.HitSound = {" "," "}
SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.AnimLerpLC = Angle(0,0,0)
SWEP.AnimLerpLF = Angle(0,0,0)
SWEP.AnimLerpLH = Angle(0,0,0)

SWEP.AnimLerpRC = Angle(0,0,0)
SWEP.AnimLerpRF = Angle(0,0,0)
SWEP.AnimLerpRH = Angle(0,0,0)

SWEP.CorrectPosX =     3.5
SWEP.CorrectPosY =     1
SWEP.CorrectPosZ =     0

SWEP.CorrectAngPitch = 0
SWEP.CorrectAngYaw =   0
SWEP.CorrectAngRoll =  90

function SWEP:DrawWorldModel()
end

function SWEP:Holster()
    return false
end

function SWEP:PrimaryAttack()

    if SERVER then
		self:SetNextPrimaryFire(CurTime() + self.Delay / ((self:GetOwner().stamina or 100)/100)-(self:GetOwner():GetNWInt("Adrenaline")/5) - 0.1 )	
	end

    local ply = self:GetOwner()

    if not IsValid(ply) or ply.fake then return end

    local tr = ply:GetEyeTrace()

    if tr.Entity.isSCP then return end

    if tr.Hit and tr.HitPos:Distance(ply:GetPos()) < 100 then
        if SERVER then
            if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:GetClass() == "prop_ragdoll" then
                local dmgInfo = DamageInfo()
                dmgInfo:SetDamage(self.Damage)
                dmgInfo:SetDamageType(self.DamageType)
                dmgInfo:SetAttacker(ply)
                dmgInfo:SetInflictor(self)
                tr.Entity:TakeDamageInfo(dmgInfo)

                local pos1 = tr.HitPos + tr.HitNormal
                local pos2 = tr.HitPos - tr.HitNormal
 
                if tr.Entity:IsPlayer() then
                    sound.Play("scp/049/killsound.wav", self:GetPos(), 100, 100, 1)

                    local pos = tr.Entity:GetPos()

                    tr.Entity:GetNWEntity("Ragdoll"):Remove()

                    tr.Entity:Spawn()

                    tr.Entity:SetTeam(1)

                    tr.Entity.isSCP = true 

                    tr.Entity.Role = "SCP-049-2"
                    tr.Entity.RoleColor = Color(255,0,0)

                    tr.Entity:SetPos(pos)

                    tr.Entity:SetPlayerClass("0492")
                end
            else
                local pos1 = tr.HitPos + tr.HitNormal
                local pos2 = tr.HitPos - tr.HitNormal
				if self.ShouldDecal then
					util.Decal("ManhackCut", pos1, pos2)	
				end

				tr.Entity:TakeDamage(self.Damage)

                sound.Play(self.HitSound[1], self:GetPos(), 75, math.random(95, 105), 1)
            end
        end
    end

end

function SWEP:Think()
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(0,0,0), true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Upperarm"), Angle(0,0,0), true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0,0,0), true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,0,0), true)

    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,0,0), true)
    
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(0, 0, 0), true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0), true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0), true)
end

function SWEP:DrawHUD()

end