SWEP.PrintName = "ERADICATOR"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Purpose = "Doom..."
SWEP.Instructions = "Doom..."
SWEP.Spawnable = true
SWEP.Base = 'hg_melee'

SWEP.WorldModel = "models/crucible/crucible_2016_bones.mdl"
SWEP.ViewModel =  "models/crucible/crucible_2016_bones.mdl"

SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = "none"

SWEP.HardAttack = false
SWEP.Damage = 125
SWEP.DamageType = DMG_SLASH
SWEP.Delay = 2
SWEP.StaminaCost = 14
SWEP.CustomAnim = true
SWEP.HoldType = "melee2"
SWEP.TimeUntilHit = 0.3
SWEP.TwoHanded = true
SWEP.ShouldDecal = true
SWEP.DeploySound = {"weapons/crucible/crim/equip.wav"}
SWEP.HolsterSound = {"weapons/crucible/crim/dequip.wav","weapons/crucible/crim/dequip.wav"}
SWEP.SwingSound = {"weapons/crucible/crim/slash1.wav","weapons/crucible/crim/slash2.wav"}
SWEP.HitFleshSound = {"physics/body/body_medium_break3.wav","physics/body/body_medium_break4.wav","physics/flesh/flesh_bloody_break.wav"}
SWEP.HitSound = {"weapons/crucible/2016cruc_hit1.wav","weapons/crucible/2016cruc_hit2.wav"}

SWEP.AnimLerpLC = Angle(0,0,0)
SWEP.AnimLerpLF = Angle(0,0,0)
SWEP.AnimLerpLH = Angle(0,0,0)

SWEP.AnimLerpRC = Angle(0,0,0)
SWEP.AnimLerpRF = Angle(0,0,0)
SWEP.AnimLerpRH = Angle(0,0,0)

SWEP.CorrectPosX =     3.5
SWEP.CorrectPosY =     1
SWEP.CorrectPosZ =     0

SWEP.CorrectAngPitch = 90
SWEP.CorrectAngYaw =   0
SWEP.CorrectAngRoll =  90

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)

    if self:GetOwner().ISEXPLOITERHAHA then
        self.Damage = 0
    end

	if CLIENT then
		self:CreateClientsideModel()
	end
    if CLIENT then
        self.ClientModel:SetBodygroup(0,1)
    timer.Simple(0.75,function()
        self.ClientModel:SetBodygroup(0,0)
    end)
end 
end 

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)

    if self:GetOwner().ISEXPLOITERHAHA then
        self.Damage = 0
    end

    self:EmitSound(self.DeploySound[1])

	if CLIENT then
		self:CreateClientsideModel()
	end
    if CLIENT then
        self.ClientModel:SetBodygroup(0,1)
    timer.Simple(0.75,function()
        self.ClientModel:SetBodygroup(0,0)
    end)
end 
end 

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
		timer.Simple(0.5,function()
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

                if tr.Entity:IsPlayer() then
                tr.Entity["Organs"].spine = 0
                    Faking(tr.Entity)
                        timer.Simple(0.2, function()
                            local rag = tr.Entity:GetNWEntity("Ragdoll")
                            RemoveBoneGlobal(rag,rag:TranslatePhysBoneToBone(tr.PhysicsBone),tr.PhysicsBone)
                        end)
                elseif tr.Entity:IsRagdoll() then
                    local rag = tr.Entity
                    RemoveBoneGlobal(rag,rag:TranslatePhysBoneToBone(tr.PhysicsBone),tr.PhysicsBone)
                end
				
				util.Decal("Impact.Flesh", pos1, pos2)
            else
                local pos1 = tr.HitPos + tr.HitNormal
                local pos2 = tr.HitPos - tr.HitNormal
				if self.ShouldDecal then
					util.Decal("ManhackCut", pos1, pos2)	
				end

				tr.Entity:TakeDamage(self.Damage)

				--print(tr.Entity:GetClass())

                sound.Play(self.HitSound[1], self:GetPos(), 75, math.random(95, 105), 1)
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

        self.AnimLerpRC = LerpAngleFT(0.15,self.AnimLerpRC,Angle(-90,0,0))
        self.AnimLerpRF = LerpAngleFT(0.15,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(0.15,self.AnimLerpRH,Angle(0,70,50))
    elseif self.Anim2 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(0.25,self.AnimLerpRC,Angle(20,30,0))
        self.AnimLerpRF = LerpAngleFT(0.25,self.AnimLerpRF,Angle(0,0,20))
        self.AnimLerpRH = LerpAngleFT(0.25,self.AnimLerpRH,Angle(0,-90,50))
    elseif self.Anim3 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(0,0,0))
        self.AnimLerpRF = LerpAngleFT(0.1,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(0.1,self.AnimLerpRH,Angle(0,0,0))
    end

	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(40, 10, 35) + self.AnimLerpRC, true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(-20, 10, -10) + self.AnimLerpRF, true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,  20, 30) + self.AnimLerpRH, true)

	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(20, -20, 0) + self.AnimLerpLC, true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(30, 0, 30) + self.AnimLerpLF, true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0) + self.AnimLerpLH, true)
end