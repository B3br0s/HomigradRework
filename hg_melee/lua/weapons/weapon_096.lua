SWEP.PrintName = "Руки 096"
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
SWEP.DamageType = DMG_SLASH
SWEP.Delay = 0.5
SWEP.StaminaCost = 0
SWEP.CustomAnim = true
SWEP.HoldType = "knife"
SWEP.TimeUntilHit = 0.2
SWEP.TwoHanded = true
SWEP.KeyClass = 3
SWEP.ShouldDecal = false
SWEP.DeploySound = {"weapons/melee/melee_draw_temp1.wav","weapons/melee/melee_draw_temp2.wav"}
SWEP.HolsterSound = {"weapons/melee/melee_holster_temp1.wav","weapons/melee/melee_holster_temp2.wav"}
SWEP.SwingSound = {"weapons/melee/swing_light_blunt_01.wav","weapons/melee/swing_light_blunt_02.wav","weapons/melee/swing_light_blunt_03.wav"}
SWEP.HitFleshSound = {"physics/body/body_medium_break3.wav","physics/body/body_medium_break4.wav","physics/flesh/flesh_bloody_break.wav"}
SWEP.HitSound = {"physics/concrete/concrete_break2.wav","physics/concrete/concrete_break3.wav"}
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
    local ply = self:GetOwner()

    if not ply:GetNWBool("RageSCP") then
        return
    end
	
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

    if tr.Entity.isSCP then return end

    if tr.Hit and tr.HitPos:Distance(ply:GetPos()) < 100 then
        if SERVER then
            local target = tr.Entity
            local owner = self:GetOwner()
            if target:GetClass() == "prop_door_rotating" then
                local doorPos = target:GetPos()
                local doorAngles = target:GetAngles()
                local doorModel = target:GetModel()
                local doorSkin = target:GetSkin() or 0

                target:Fire("Unlock", "", 0)
                target:Fire("Open", "", 0)
                target:Remove()


                local physDoor = ents.Create("prop_physics")
                physDoor:SetModel(doorModel)
                physDoor:SetPos(doorPos)
                physDoor:SetAngles(doorAngles)
                physDoor:SetSkin(doorSkin)
                physDoor:Spawn()

                local phys = physDoor:GetPhysicsObject()
                if IsValid(phys) then
                    local forceDirection = owner:GetAimVector() * 10000
                    for i = 1,50 do
                        timer.Simple(0.001 * i,function ()
                    phys:ApplyForceCenter(forceDirection)
                    end)
                end
                end
            elseif target:GetClass() == "func_door" or target:GetClass() == "func_door_rotating" then
                local doorPos = target:GetPos()
                local doorAngles = target:GetAngles()
                local doorModel = target:GetModel()
                local doorSkin = target:GetSkin() or 0

                target:Fire("Unlock", "", 0)
                target:Fire("Open", "", 0)
                target:Fire("Disable", "", 0.1)

                local physDoor = ents.Create("prop_physics")
                physDoor:SetModel(doorModel)
                physDoor:SetPos(doorPos)
                physDoor:SetAngles(doorAngles)
                physDoor:SetSkin(doorSkin)
                physDoor:Spawn()

                target:Remove()

                local phys = physDoor:GetPhysicsObject()
                if IsValid(phys) then
                    local forceDirection = owner:GetAimVector() * 10000
                    for i = 1,50 do
                    timer.Simple(0.001 * i,function ()
                    phys:ApplyForceCenter(forceDirection)
                    end)
                end
                end
            end
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
    if self:GetOwner():GetNWBool("RageSCP") then
        self:SetHoldType(self.HoldType)

        if self.Anim1 then
            self.AnimLerpLC = LerpAngleFT(0.5,self.AnimLerpLC,Angle(0,30,60))
            self.AnimLerpLF = LerpAngleFT(0.5,self.AnimLerpLF,Angle(0,0,0))
            self.AnimLerpLH = LerpAngleFT(0.5,self.AnimLerpLH,Angle(0,0,0))

            self.AnimLerpRC = LerpAngleFT(0.5,self.AnimLerpRC,Angle(0,10,-60))
            self.AnimLerpRF = LerpAngleFT(0.5,self.AnimLerpRF,Angle(0,0,0))
            self.AnimLerpRH = LerpAngleFT(0.5,self.AnimLerpRH,Angle(0,0,0))
        elseif self.Anim2 then
            self.AnimLerpLC = LerpAngleFT(0.7,self.AnimLerpLC,Angle(0,0,-40))
            self.AnimLerpLF = LerpAngleFT(0.7,self.AnimLerpLF,Angle(0,0,0))
            self.AnimLerpLH = LerpAngleFT(0.7,self.AnimLerpLH,Angle(0,0,0))

            self.AnimLerpRC = LerpAngleFT(0.7,self.AnimLerpRC,Angle(0,0,40))
            self.AnimLerpRF = LerpAngleFT(0.7,self.AnimLerpRF,Angle(0,0,0))
            self.AnimLerpRH = LerpAngleFT(0.7,self.AnimLerpRH,Angle(0,0,0))
        elseif self.Anim3 then
            self.AnimLerpLC = LerpAngleFT(0.2,self.AnimLerpLC,Angle(0,0,0))
            self.AnimLerpLF = LerpAngleFT(0.2,self.AnimLerpLF,Angle(0,0,0))
            self.AnimLerpLH = LerpAngleFT(0.2,self.AnimLerpLH,Angle(0,0,0))

            self.AnimLerpRC = LerpAngleFT(0.2,self.AnimLerpRC,Angle(0,0,0))
            self.AnimLerpRF = LerpAngleFT(0.2,self.AnimLerpRF,Angle(0,0,0))
            self.AnimLerpRH = LerpAngleFT(0.2,self.AnimLerpRH,Angle(0,0,0))
        end

	    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(20, 0, 20) + self.AnimLerpLC , true)
	    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0) + self.AnimLerpLF , true)
	    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0) + self.AnimLerpLH , true)

	    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(20, -20, -10) + self.AnimLerpRC , true)
	    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0) + self.AnimLerpRF , true)
	    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0) + self.AnimLerpRH , true)

        self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_Spine4"), Angle(0,-20, 0), true)
        self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_Spine2"), Angle(0, 0, 0), true)
        else

        self:SetHoldType("normal")

        self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(0, -10, 50), true)
	    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0), true)
	    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0), true)

	    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(0, -10, -50), true)
	    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0), true)
	    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0), true)

        self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_Spine4"), Angle(0,20, 0), true)
        self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_Spine2"), Angle(0, 20, 0), true)
        self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_Head1"), Angle(0, 30, 0), true)
    end
end