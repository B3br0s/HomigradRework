SWEP.PrintName = "База Ближнего Боя"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Spawnable = false

SWEP.WorldModel = "models/props/CS_militia/axe.mdl"
SWEP.ViewModel =  "models/props/CS_militia/axe.mdl"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = "none"

SWEP.HardAttack = false
SWEP.Damage = 75
SWEP.DamageType = DMG_SLASH
SWEP.Delay = 1
SWEP.StaminaCost = 4
SWEP.CustomAnim = false
SWEP.HoldType = "melee2"
SWEP.TimeUntilHit = 0.2
SWEP.TwoHanded = false
SWEP.ShouldDecal = true
SWEP.DeploySound = {"weapons/melee/melee_draw_temp1.wav"}
SWEP.HolsterSound = {"weapons/melee/melee_holster_temp1.wav"}
SWEP.SwingSound = {"weapons/melee/swing_light_blunt_01.wav"}
SWEP.HitFleshSound = {"weapons/melee/flesh_impact_sharp_02.wav"}
SWEP.HitSound = {"weapons/melee/metal_solid_impact_bullet1.wav"}

SWEP.CorrectPosX =     1
SWEP.CorrectPosY =     0
SWEP.CorrectPosZ =     0

SWEP.CorrectAngPitch = 0
SWEP.CorrectAngYaw =   0
SWEP.CorrectAngRoll =  -90

if CLIENT then
    include("cl_worldmodel.lua")
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

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)

    if self:GetOwner().ISEXPLOITERHAHA then
        self.Damage = 0
    end

    self:EmitSound(self.DeploySound[math.random(#self.DeploySound)])

	if CLIENT then
		self:CreateClientsideModel()
	end
end

function SWEP:GetTypeThing()
	if self.DamageType == DMG_CLUB then
		return "Ударный"
	elseif self.DamageType == DMG_SLASH then
		return "Режущий"
	end
end

function SWEP:Initialize()
	if CLIENT then
		self:CreateClientsideModel()	
	end
	local typea = self:GetTypeThing()
	self.Instructions = ("Урон: "..self.Damage.."\nЗадержка: "..self.Delay.."\nТип: "..typea)
	
	self:SetHoldType(self.HoldType)
end

function SWEP:OnRemove()
	if IsValid(self.ClientModel) then
		self.ClientModel:Remove()
	end
end

function SWEP:Holster()
	self:EmitSound(self.HolsterSound[math.random(#self.HolsterSound)])

	return true
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

function SWEP:DrawHUD()
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
    surface.SetDrawColor(Color(255,255,255,hit * 255))
    draw.NoTexture()
    Circle(traceResult.HitPos:ToScreen().x, traceResult.HitPos:ToScreen().y, 5 / frac, 32)
end

function SWEP:DrawWorldModel()
    local owner = self:GetOwner()
    if IsValid(owner) then
        if not IsValid(self.ClientModel) then
            self:CreateClientsideModel()
            return
        end

        if owner:GetActiveWeapon() ~= self or owner:GetMoveType() == MOVETYPE_NOCLIP then
            self.ClientModel:SetNoDraw(true)
            return
        end

        local attachmentIndex = owner:LookupAttachment("anim_attachment_rh")
        if attachmentIndex == 0 then return end

        local attachment = owner:GetAttachment(attachmentIndex)
        if not attachment then return end

        local Pos = attachment.Pos
        local Ang = attachment.Ang

        Pos:Add(Ang:Forward() * (self.CorrectPosX or 0))
        Pos:Add(Ang:Right() * (self.CorrectPosY or 0))
        Pos:Add(Ang:Up() * (self.CorrectPosZ or 0))

        Ang:RotateAroundAxis(Ang:Right(), self.CorrectAngPitch or 0)
        Ang:RotateAroundAxis(Ang:Up(), self.CorrectAngYaw or 0)
        Ang:RotateAroundAxis(Ang:Forward(), self.CorrectAngRoll or 0)

        Ang:Normalize()

        self.ClientModel:SetPos(Pos)
        self.ClientModel:SetAngles(Ang)
        self.ClientModel:SetModelScale(self.CorrectSize or 1)
        self.ClientModel:SetNoDraw(false)

        self:WorldModel_Transform()

        self.ClientModel:DrawModel()
    else
        if IsValid(self.ClientModel) then
            self.ClientModel:SetNoDraw(true)
        end
        self:DrawModel()
    end
end

function SWEP:GetPosAng()
	local owner = self:GetOwner()
	if not IsValid(owner) then return Vector(0, 0, 0), Angle(0, 0, 0) end

	local owner = self:GetOwner()
    local attachmentIndex = owner:LookupAttachment("anim_attachment_rh")
    if attachmentIndex == 0 then return end
    local attachment = owner:GetAttachment(attachmentIndex)
    if not attachment then return end
    local Pos = attachment.Pos
    local Ang = attachment.Ang

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

function SWEP:Think()
    self:SetHoldType(self.HoldType)

	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(0, 0, 0), true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0), true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0), true)

	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(0, 0, 0), true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0), true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0), true)

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
            else
                local pos1 = tr.HitPos + tr.HitNormal
                local pos2 = tr.HitPos - tr.HitNormal
				if self.ShouldDecal then
					util.Decal("ManhackCut", pos1, pos2)	
				end

				tr.Entity:TakeDamage(self.Damage)

				print(tr.Entity:GetClass())

                sound.Play(self.HitSound[1], self:GetPos(), 75, math.random(95, 105), 1)
            end
        end
    end
end)
end

function SWEP:SecondaryAttack()
    if !self.HardAttack then return end
end