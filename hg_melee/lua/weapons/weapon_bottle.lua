SWEP.PrintName = "Бутылка"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Spawnable = true
SWEP.Base = 'hg_melee'

SWEP.WorldModel = "models/props_junk/garbage_glassbottle003a.mdl"
SWEP.ViewModel =  "models/props_junk/garbage_glassbottle003a.mdl"

SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = "none"

SWEP.HardAttack = false
SWEP.Damage = 95
SWEP.DamageType = DMG_CLUB
SWEP.Delay = 1
SWEP.StaminaCost = 1
SWEP.CustomAnim = true
SWEP.HoldType = "knife"
SWEP.TimeUntilHit = 0.2
SWEP.TwoHanded = false
SWEP.ShouldDecal = false
SWEP.DeploySound = {"weapons/melee/melee_draw_temp1.wav","weapons/melee/melee_draw_temp2.wav"}
SWEP.HolsterSound = {"weapons/melee/melee_holster_temp1.wav","weapons/melee/melee_holster_temp2.wav"}
SWEP.SwingSound = {"weapons/melee/swing_light_sharp_01.wav","weapons/melee/swing_light_sharp_02.wav","weapons/melee/swing_light_sharp_03.wav"}
SWEP.HitFleshSound = {"physics/glass/glass_bottle_break1.wav","physics/glass/glass_bottle_break2.wav"}
SWEP.HitSound = {"physics/glass/glass_bottle_break1.wav","physics/glass/glass_bottle_break2.wav"}

SWEP.AnimLerpLC = Angle(0,0,0)
SWEP.AnimLerpLF = Angle(0,0,0)
SWEP.AnimLerpLH = Angle(0,0,0)

SWEP.AnimLerpRC = Angle(0,0,0)
SWEP.AnimLerpRF = Angle(0,0,0)
SWEP.AnimLerpRH = Angle(0,0,0)

SWEP.CorrectPosX =     3
SWEP.CorrectPosY =     1.5
SWEP.CorrectPosZ =     -5.6

SWEP.CorrectAngPitch = 0
SWEP.CorrectAngYaw =   0
SWEP.CorrectAngRoll =  0

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
	
	if SERVER then
		self:SetNextPrimaryFire(CurTime() + self.Delay / ((self:GetOwner().stamina or 100)/100)-(self:GetOwner():GetNWInt("Adrenaline")/5) - 0.1 )	
	end

    self:EmitSound(self.SwingSound[math.random(#self.SwingSound)])

    if SERVER then
        ply.stamina = ply.stamina - self.StaminaCost
    end

    if not self.CustomAnim then
        ply:SetAnimation(PLAYER_ATTACK1)    
	else
		self.Anim1 = true
		self.Anim2 = false
		self.Anim3 = false
		timer.Simple(self.TimeUntilHit,function() 
		self.Anim1 = false
		self.Anim2 = true
		self.Anim3 = false
		timer.Simple(0.1,function()
		self.Anim1 = false
		self.Anim2 = false
		self.Anim3 = true
		end)
		end)
    end

    local ply = self:GetOwner()

timer.Simple(self.TimeUntilHit, function()
    if not IsValid(ply) or ply.fake then return end

    local eyeAttachment = ply:LookupAttachment("eyes")
    if eyeAttachment == 0 then return end

    local eyePos = ply:GetAttachment(eyeAttachment).Pos
    local eyeAngles = ply:EyeAngles() + Angle(4, 0, 0)
    local traceData = {}
    traceData.start = eyePos
    traceData.endpos = traceData.start + eyeAngles:Forward() * 250
    traceData.filter = ply

    local tr = util.TraceLine(traceData)
    if not tr.Hit then
        local hullTraceData = {
            start = eyePos,
            endpos = eyePos + eyeAngles:Forward() * 250,
            filter = function(ent)
                return ent ~= ply and (ent:IsPlayer() or ent:IsRagdoll())
            end,
            mins = -Vector(6, 6, 6),
            maxs = Vector(6, 6, 6)
        }
        tr = util.TraceHull(hullTraceData)
    end

    if tr.Hit and tr.HitPos:Distance(ply:GetPos()) < 100 then
        if SERVER then
            if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:GetClass() == "prop_ragdoll" then
                local dmgInfo = DamageInfo()
                dmgInfo:SetDamage(self.Damage)
                dmgInfo:SetDamageType(self.DamageType)
                dmgInfo:SetAttacker(ply)
                dmgInfo:SetInflictor(self)
                tr.Entity:TakeDamageInfo(dmgInfo)

                sound.Play(self.HitFleshSound[math.random(#self.HitFleshSound)], self:GetPos(), 75, math.random(95, 105), 1)

                local pos1 = tr.HitPos + tr.HitNormal
                local pos2 = tr.HitPos - tr.HitNormal
				
				util.Decal("Impact.Flesh", pos1, pos2)
                
                if tr.Entity:IsPlayer() then
                tr.Entity:SetDSP(35)
                end

                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(0,0, 0), true)
                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0,0,0), true)
                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,0,0), true)
            
                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(0, 0, 0), true)
                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0), true)
                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0), true)

                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_Spine4"), Angle(0,0, 0), true)

                self:GetOwner().AllowSpawn = true 

                local ply = self:GetOwner()

                self:GetOwner():Give("weapon_bottlerozochka")

                self:GetOwner():SelectWeapon("weapon_bottlerozochka")

                local prop = ents.Create("prop_physics")
                prop:SetModel("models/props_junk/garbage_glassbottle003a_chunk02.mdl")
                prop:SetPos(tr.HitPos)
                prop:Spawn()
                local prop2 = ents.Create("prop_physics")
                prop2:SetModel("models/props_junk/garbage_glassbottle003a_chunk03.mdl")
                prop2:SetPos(tr.HitPos)
                prop2:Spawn()

                ply.AllowSpawn = false

                self:Remove()
            else
                local pos1 = tr.HitPos + tr.HitNormal
                local pos2 = tr.HitPos - tr.HitNormal
				if self.ShouldDecal then
					util.Decal("ManhackCut", pos1, pos2)	
				end

				tr.Entity:TakeDamage(self.Damage)

				self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(0,0, 0), true)
                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0,0,0), true)
                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,0,0), true)
            
                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(0, 0, 0), true)
                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0), true)
                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0), true)

                self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_Spine4"), Angle(0,0, 0), true)

                sound.Play(self.HitSound[1], self:GetPos(), 75, math.random(95, 105), 1)

                self:GetOwner().AllowSpawn = true 

                local ply = self:GetOwner()

                self:GetOwner():Give("weapon_bottlerozochka")

                self:GetOwner():SelectWeapon("weapon_bottlerozochka")

                local prop = ents.Create("prop_physics")
                prop:SetModel("models/props_junk/garbage_glassbottle003a_chunk02.mdl")
                prop:SetPos(tr.HitPos)
                prop:Spawn()
                local prop2 = ents.Create("prop_physics")
                prop2:SetModel("models/props_junk/garbage_glassbottle003a_chunk03.mdl")
                prop2:SetPos(tr.HitPos)
                prop2:Spawn()

                ply.AllowSpawn = false

                self:Remove()
            end
        end
    end
end)
end

function SWEP:Think()
    self:SetHoldType(self.HoldType)

    

    if self.Anim1 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(-80,60,0))
        self.AnimLerpRF = LerpAngleFT(0.1,self.AnimLerpRF,Angle(70,30,50))
        self.AnimLerpRH = LerpAngleFT(0.1,self.AnimLerpRH,Angle(-30,0,-50))
    elseif self.Anim2 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(1,self.AnimLerpRC,Angle(0,0,-70))
        self.AnimLerpRF = LerpAngleFT(1,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(1,self.AnimLerpRH,Angle(-90,0,0))
    elseif self.Anim3 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(0,0,0))
        self.AnimLerpRF = LerpAngleFT(0.6,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(0.3,self.AnimLerpRH,Angle(0,0,0))
    end

    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(20,20, 30) + self.AnimLerpRC, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0,-30,0) + self.AnimLerpRF, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,20,30) + self.AnimLerpRH, true)

    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(30, -30, 0) + self.AnimLerpLC, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(10, 90, 0) + self.AnimLerpLF, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(30, -20, 0) + self.AnimLerpLH, true)

    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_Spine4"), Angle(0,-20, 0), true)
end