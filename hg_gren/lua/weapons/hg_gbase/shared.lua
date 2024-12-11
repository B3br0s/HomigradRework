SWEP.Base = "weapon_base"

SWEP.PrintName = "База Гаранаты"
SWEP.Author = "HG:R"

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.Spawnable = false

SWEP.ViewModel = "models/pwb/weapons/w_f1.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_f1.mdl"

if CLIENT then
    include("cl_worldmodel.lua")
end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.CorrectPosX =     0
SWEP.CorrectPosY =     0
SWEP.CorrectPosZ =     0 

SWEP.CorrectAngPitch = 0
SWEP.CorrectAngYaw =   0
SWEP.CorrectAngRoll =  0

SWEP.AnimLerpLC = Angle(0,0,0)
SWEP.AnimLerpLF = Angle(0,0,0)
SWEP.AnimLerpLH = Angle(0,0,0)

SWEP.AnimLerpRC = Angle(0,0,0)
SWEP.AnimLerpRF = Angle(0,0,0)
SWEP.AnimLerpRH = Angle(0,0,0)

SWEP.SkobaLerpp = Angle(0,0,0)
SWEP.SkobaPos = Vector(0,0,0)
SWEP.Mode = false

SWEP.Anim1 = false
SWEP.Anim2 = false
SWEP.Anim3 = false

function SWEP:Initialize()
    self:SetHoldType("knife")
end

function SWEP:GetPosAng()
	local owner = self:GetOwner()
	if not IsValid(owner) then return Vector(0, 0, 0), Angle(0, 0, 0) end

	local boneIndex = owner:LookupBone("ValveBiped.Bip01_R_Hand")
	if not boneIndex then return Vector(0, 0, 0), Angle(0, 0, 0) end

	local Pos, Ang = owner:GetBonePosition(boneIndex)
	if not Pos or not Ang then return Vector(0, 0, 0), Angle(0, 0, 0) end

	if self.Correctpos then
	Pos:Add(Ang:Forward() * self.CorrectPosX or 0)
	Pos:Add(Ang:Right() * self.CorrectPosY or 0)
	Pos:Add(Ang:Up() * self.CorrectPosZ or 0)

	Ang:RotateAroundAxis(Ang:Up(), self.CorrectAngPitch or 0)
	Ang:RotateAroundAxis(Ang:Right(), self.CorrectAngYaw or 0)
	Ang:RotateAroundAxis(Ang:Forward(), self.CorrectAngRoll or 0)
	end

	return Pos, Ang
end

function SWEP:DrawWorldModel()
	if IsValid(self:GetOwner()) then
		if IsValid(self.ClientModel) then
			self.ClientModel:SetNoDraw(false)
			local pos, ang = self:GetPosAng()
			self.ClientModel:SetPos(pos)
			self.ClientModel:SetAngles(ang)
			self.ClientModel:DrawModel()
		end
	else
		if IsValid(self.ClientModel) then
			self.ClientModel:SetNoDraw(true)
		end
		self:DrawModel()
        self:SetModel(self.ThrownModel)
	end
end

local function getPos(ply,ent)
    local tr = {}
    tr.start = ply:EyePos()
    local dir = Vector(75,0,0)
    dir:Rotate(ply:EyeAngles())
    tr.endpos = tr.start + dir
    tr.filter = ply

    tr = util.TraceLine(tr)

    return tr.HitPos + Vector(0,0,0),tr.Hit
end

function SWEP:Step()
    local green = Color(0,255,0)
    local red = Color(255,0,0)

        local owner = self:GetOwner()

        local model = self.model
        if not IsValid(model) then
            model = ClientsideModel(self.ThrownModel)
            self.model = model
        end

        local pos,hit = getPos(owner)
        model:SetPos(pos)
        model:SetAngles(Angle(0,owner:EyeAngles()[2] + 180,0))

        model:SetColor(hit and green or red)
end

function SWEP:OnRemove()
    if CLIENT then
        if self.ClientModel then
        self.ClientModel:Remove()
        end
    if self.Mode then
        self.model:Remove()
    end
    end
end

function SWEP:Holster()
    if CLIENT then
        if self.Mode then
            self.model:Remove()
        end
        if self.ClientModel then
        self.ClientModel:Remove()
        end
        end
    if self.PinOut then
        return false
    else
        return true
    end
end

function SWEP:ThrowGrenade(ply,force)
    if CLIENT then
    self.ClientModel:Remove()
    end
    if SERVER then
        if not self.LeverOut then
        if not self.LeverOut and self.TypeGren != "Smoke" then
        sound.Play("weapons/darsu_eft/grenades/gren_fuze1.ogg",self:GetPos())
        end
        end
        local granade = ents.Create("ent_grenade_hg")
        granade:SetPos(ply:GetShootPos() +ply:GetAimVector()*10)
	    granade:SetAngles(ply:EyeAngles()+Angle(45,45,0))
	    granade:SetOwner(ply)
	    granade:SetPhysicsAttacker(ply)
	    granade:Spawn()   
        granade:SetModel(self.ThrownModel)
        granade.TypeGren = self.TypeGren
        if self.LeverOut then
        granade.Delay = math.Round(self:GetNWFloat("Until"),3)
        else
        granade.Delay = self.TimeUntilExplode
        end
        granade.HasLever = not self.LeverOut
	    granade:Arm()
	    local phys = granade:GetPhysicsObject()              
	    if not IsValid(phys) then granade:Remove() return end                         
	    for i = 1,9 do
            timer.Simple(0.01 * i,function()
                phys:SetVelocity(ply:GetVelocity() + ply:GetAimVector() * force)
            end)
        end
	    phys:AddAngleVelocity(VectorRand() * force/2 * 5)

        self:GetOwner():SelectWeapon("weapon_hands")
    end
end

function SWEP:OwnerChanged()
    self:Holster()
end

function SWEP:Reload()
    if self.Delay and self.Delay > CurTime() or self.LeverOut or !self.RequiresPin then return end
    if self:GetOwner():KeyDown(IN_ATTACK2) and not self.PinOut and self.RequiresPin and self.TypeGren != "Flash" then self.Mode = not self.Mode self.ModeText = (self.Mode and "Door Trap" or "Grenade") self.Delay = CurTime() + 1 if CLIENT then self:GetOwner():ChatPrint(self.ModeText) end end
    if self:GetOwner():KeyDown(IN_ATTACK2) or self.Mode == true then return end
    self.Delay = CurTime() + 0.9
    if !self.PinOut then
        self.PinOut = true
        self:EmitSound(self.PinSound)
        self.Anim1 = true
        self.Anim2 = false
        self.Anim3 = false
        timer.Simple(0.2,function()
            self.Anim1 = false
            self.Anim2 = true
            self.Anim3 = false
            self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Finger1"),Angle(0,-50,0))
            self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Finger11"),Angle(0,-40,0))
            self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Finger12"),Angle(0,-40,0))
            self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Finger2"),Angle(0,-90,0))
            self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Finger21"),Angle(0,-40,0))
            if CLIENT then
                self:PinOutFunc()
            end
                timer.Simple(0.2,function()
                    self.Anim1 = false
                    self.Anim2 = false
                    self.Anim3 = true
                    end)
        end)
    else
        if self.TypeGren == "Impact" or self.TypeGren == "Inc" or self.TypeGren == "Smoke" then return end
        self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Finger1"),Angle(0,70,0))
        self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Finger11"),Angle(0,30,0))
        self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Finger12"),Angle(0,20,0))
        self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Finger2"),Angle(0,70,0))
        self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Finger21"),Angle(0,30,0))
        self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Finger22"),Angle(0,20,0))
        self:EmitSound("weapons/darsu_eft/grenades/rgd_lever.ogg")
        sound.Play("weapons/darsu_eft/grenades/gren_fuze1.ogg",self:GetPos())
        self.LeverOut = true
        if SERVER then
        local Spoon = ents.Create("ent_jack_spoon")
        Spoon:SetPos(self:GetPos())
        Spoon:Spawn()
        end
    end
end

function SWEP:PrimaryAttack()
    if CLIENT then return end
    if self.PinOut and self.RequiresPin then
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
        self:ThrowGrenade(self:GetOwner(),750)
        sound.Play(self.ThrowSound,self:GetPos())
        self:GetOwner():SelectWeapon("weapon_hands")
        self:Holster()
        self:Remove()
    elseif !self.RequiresPin then
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
        self:ThrowGrenade(self:GetOwner(),250)
        self:Remove()
        sound.Play(self.ThrowSound,self:GetPos())
        self:GetOwner():SelectWeapon("weapon_hands")
        self:Holster()
        self:Remove()
    end
end

local function TwoTrace(ply)
    local owner = ply
    local tr = {}
    tr.start = owner:GetAttachment(owner:LookupAttachment("eyes")).Pos
    local dir = Vector(1,0,0)
    dir:Rotate(owner:EyeAngles())
    tr.endpos = tr.start + dir * 75
    tr.filter = {owner}

    local tRes1 = util.TraceLine(tr)
    if not IsValid(tRes1.Entity) then return end

    tr.start = tRes1.HitPos + tRes1.Normal
    tr.endpos = tRes1.HitPos + dir * 25

    tr.filter[2] = tRes1.Entity
    if SERVER then
        for i,info in pairs(constraint.GetTable(tRes1.Entity)) do
            if info.Ent1 ~= game.GetWorld() then table.insert(tr.filter,info.Ent1) end
            if info.Ent2 ~= game.GetWorld() then table.insert(tr.filter,info.Ent2) end
        end
    end
    local tRes2 = util.TraceLine(tr)
    if not tRes2.Hit then return end

    return tRes1,tRes2
end

function SWEP:SecondaryAttack()
    if CLIENT then return end
    if self.PinOut and self.RequiresPin and not self.Mode then
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
        self:ThrowGrenade(self:GetOwner(),250)
        self:Remove()
        sound.Play(self.ThrowSound,self:GetPos())
        self:GetOwner():SelectWeapon("weapon_hands")
        self:Remove()
    elseif !self.RequiresPin and not self.Mode then
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
        self:ThrowGrenade(self:GetOwner(),250)
        self:Remove()
        sound.Play(self.ThrowSound,self:GetPos())
        self:GetOwner():SelectWeapon("weapon_hands")
        self:Remove()
    elseif self.Mode then
        local owner = self:GetOwner()
        local tr = {}
        tr.start = owner:GetAttachment(owner:LookupAttachment("eyes")).Pos
        local dir = Vector(1,0,0)
        dir:Rotate(owner:EyeAngles())
        tr.endpos = tr.start + dir * 75
        tr.filter = owner
    
        local tRes1,tRes2 = TwoTrace(owner)
    
        local traceResult = util.TraceLine(tr)
        local hit = traceResult.Hit and 1 or 0
        local hitEnt = traceResult.Entity~=Entity(0) and 1 or 0
        local isRag = traceResult.Entity:IsRagdoll()
        local frac = traceResult.Fraction
    end
end

local mul = 1
local FrameTime,TickInterval = FrameTime,engine.TickInterval

hook.Add("Think","Mul lerp",function()
	mul = FrameTime() / TickInterval()
end)

local Lerp,LerpVector,LerpAngle = Lerp,LerpVector,LerpAngle
local math_min = math.min

function LerpFT(lerp,source,set)
	return Lerp(math_min(lerp * mul,1),source,set)
end

function LerpVectorFT(lerp,source,set)
	return LerpVector(math_min(lerp * mul,1),source,set)
end

function LerpAngleFT(lerp,source,set)
	return LerpAngle(math_min(lerp * mul,1),source,set)
end


function SWEP:Think()
    if self.Mode and CLIENT then
        self:Step()
    elseif CLIENT and not self.Mode then
        if self.model then
            self.model:Remove()
        end
    end
    if CLIENT then
        if self.LeverOut then
            self.SkobaLerpp = LerpAngleFT(0.3,self.SkobaLerpp,Angle(0,0,-140))

            self.SkobaPos = LerpVectorFT(0.005,self.SkobaPos,Vector(0,50,0))
                
                self:SkobaOutFunc()
        end
        if CLIENT and IsValid(self:GetOwner()) then
            self:CreateClientsideModel()
        
            local weaponRef = self
        
            hook.Add("PostDrawOpaqueRenderables", "DrawSWEPWorldModel_" .. self:EntIndex(), function()
                if IsValid(weaponRef) and weaponRef.DrawClientModel then
                    weaponRef:DrawClientModel()
                else
                    hook.Remove("PostDrawOpaqueRenderables", "DrawSWEPWorldModel_" .. weaponRef:EntIndex())
                end
            end)
        
        elseif CLIENT and not IsValid(self:GetOwner()) then
            hook.Remove("PostDrawOpaqueRenderables", "DrawSWEPWorldModel_" .. self:EntIndex())
        end
    end
    if CLIENT then return end
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_Spine4"), Angle(0,-20, 0), true)

    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(20,20, 30) + self.AnimLerpRC, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(-5,-30,0) + self.AnimLerpRF, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,0,30) + self.AnimLerpRH, true)

    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(0,0,-30) + self.AnimLerpLC, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0,0,0) + self.AnimLerpLF, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0,0,0) + self.AnimLerpLH, true)
    if self.Anim1 then
        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(0,30,0))
        self.AnimLerpRF = LerpAngleFT(0.1,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(0.1,self.AnimLerpRH,Angle(-20,20,40))
        self.AnimLerpLC = LerpAngleFT(0.1,self.AnimLerpLC,Angle(0,10,-30))
        self.AnimLerpLF = LerpAngleFT(0.1,self.AnimLerpLF,Angle(30,-5,0))
        self.AnimLerpLH = LerpAngleFT(0.1,self.AnimLerpLH,Angle(10,-30,20))
    elseif self.Anim2 then
        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(0,0,0))
        self.AnimLerpRF = LerpAngleFT(0.1,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(0.1,self.AnimLerpRH,Angle(0,20,40))
        self.AnimLerpLC = LerpAngleFT(0.1,self.AnimLerpLC,Angle(0,-40,-30))
        self.AnimLerpLF = LerpAngleFT(0.1,self.AnimLerpLF,Angle(30,-5,0))
        self.AnimLerpLH = LerpAngleFT(0.1,self.AnimLerpLH,Angle(10,-30,-20))
    elseif self.Anim3 then
        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(0,0,0))
        self.AnimLerpRF = LerpAngleFT(0.1,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(0.1,self.AnimLerpRH,Angle(0,0,0))
        self.AnimLerpLC = LerpAngleFT(0.1,self.AnimLerpLC,Angle(0,0,0))
        self.AnimLerpLF = LerpAngleFT(0.1,self.AnimLerpLF,Angle(0,0,0))
        self.AnimLerpLH = LerpAngleFT(0.1,self.AnimLerpLH,Angle(0,0,0))
    end
    if self.LeverOut then
        
        if self.StartTime == nil then
            self.StartTime = CurTime()
            self:SetNWFloat("Until", self.TimeUntilExplode)
        end

        local timeLeft = self.TimeUntilExplode - (CurTime() - self.StartTime)

        self:SetNWFloat("Until", math.max(timeLeft, 0))

        if timeLeft <= 0 then
            self:SecondaryAttack()
            self.StartTime = nil
            self:ThrowGrenade(self:GetOwner(),0)
            if self.TypeGren != "Flash" and self.TypeGren != "Inc" then
            local dmginfo = DamageInfo()
            dmgInfo:SetDamageType(DMG_CRUSH)
            dmginfo:SetDamage(1e8)
            dmginfo:SetAttacker(self:GetOwner())
            dmginfo:SetInflictor(self)
            self:GetOwner():TakeDamageInfo(dmginfo)
            end
		    self:Remove()
        end
    end
end
