SWEP.Base = "hg_medbase"
SWEP.PrintName = "Электрошокер"
SWEP.Author = "HG:R"
SWEP.Instructions = "Электрическое возбуждение передается нервным клеткам, вызывая в основном болевой шок, а также кратковременные судороги и состояние «ошарашенности», дезориентации."
SWEP.Slot = 2
SWEP.SlotPos = 4
SWEP.Spawnable = true
SWEP.Category = "Предметы: Разное"

SWEP.ViewModel = "models/weapons/arccw_go/v_eq_taser.mdl"
SWEP.WorldModel = "models/weapons/arccw_go/v_eq_taser.mdl"

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Taser Cartridge"
SWEP.Uses = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.HoldType = "revolver"

SWEP.CorrectPosX =     -18.5
SWEP.CorrectPosY =     6.4
SWEP.CorrectPosZ =     -7

SWEP.CorrectAngPitch = 180
SWEP.CorrectAngYaw =   180
SWEP.CorrectAngRoll =  0
SWEP.sightyes = false

SWEP.CameraPos = Vector(4.54,6,0.17)

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

local timer_Exists = timer.Exists

function SWEP:IsLocal()
	return CLIENT and self:GetOwner() == LocalPlayer()
end

function SWEP:IsReloaded()
	return timer_Exists("reload"..self:EntIndex())
end

function SWEP:IsScope()
    local ply = self:GetOwner()
    
    if not IsValid(ply) or ply:IsNPC() then return end

    if not ply:Alive() then return end

    if self:IsLocal() or SERVER then
        return not ply:IsSprinting() and ply:KeyDown(IN_ATTACK2) and not self:IsReloaded()
    else
        return self:GetNWBool("IsScope")
    end
end

function SWEP:Initialize()
	self:SetHoldType("revolver")
end

local hull = Vector(10,10,10)

function SWEP:PrimaryAttack()
	if CLIENT then
		if self:Clip1() <= 0 then return end
		local ply = self:GetOwner()

		local att = ply:GetAttachment(ply:LookupAttachment("anim_attachment_RH"))

		local dir = ply:EyeAngles():Forward()

		local trs = {
			start = att.Pos + att.Ang:Forward() * 5 + att.Ang:Up() * 2,
			endpos = att.Pos + dir * 250,
			filter = ply,
			mins = -hull,
			maxs = hull,
			mask = MASK_SHOT_HULL
		}

		local effectdata = EffectData()
		effectdata:SetOrigin(trs.start)
		effectdata:SetMagnitude(0.2)
		effectdata:SetScale(0.01)
		effectdata:SetNormal(dir * 5)
		util.Effect("Sparks",effectdata)
	end
	if CLIENT then return end

	local ply = self:GetOwner()

	if self:Clip1() <= 0 then return end
	self:TakePrimaryAmmo(1)

	local att = ply:GetAttachment(ply:LookupAttachment("anim_attachment_RH"))

	local dir = ply:EyeAngles():Forward()

	ply:EmitSound("arccw_go/taser/taser_shoot.wav")

	local trs = {
		start = att.Pos + att.Ang:Forward() * 5 + att.Ang:Up() * 2,
		endpos = att.Pos + dir * 250,
		filter = ply,
		mins = -hull,
		maxs = hull,
		mask = MASK_SHOT_HULL
	}

	local tr = ply:EyeTrace(325)
    if not tr then return end

	local effectdata = EffectData()
	effectdata:SetOrigin(trs.start)
	effectdata:SetMagnitude(0.2)
	effectdata:SetScale(0.01)
	effectdata:SetNormal(dir * 5)
	util.Effect("Sparks",effectdata)

	local hit = tr.Hit and 1 or 0

	if hit == 1 then
		local hitted = tr.Entity

		if hitted:GetClass() != "prop_ragdoll" and hitted:GetClass() != "player" then return end

		hitted:EmitSound("hostage/hpain/hpain" .. math.random(1,6) .. ".wav")

		hitted:EmitSound("arccw_go/taser/taser_hit.wav")

		Stun(hitted)
	end
end

function SWEP:SecondaryAttack()

end

function SWEP:DrawHUD()

end

function SWEP:Reload()
if timer.Exists("reload"..self:EntIndex()) or self:Clip1()>=self:GetMaxClip1() or self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() )<=0 then return nil end
	if self:GetOwner():IsSprinting() then return nil end
	self:GetOwner():SetAnimation(PLAYER_RELOAD)
	timer.Create( "reload"..self:EntIndex(), 1.5, 1, function()
		if IsValid(self) and IsValid(self:GetOwner()) and self:GetOwner():GetActiveWeapon()==self then
			local oldclip = self:Clip1()
			self:SetClip1(math.Clamp(self:Clip1()+self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() ),0,self:GetMaxClip1()))
			local needed = self:Clip1()-oldclip
			self:GetOwner():SetAmmo(self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() )-needed, self:GetPrimaryAmmoType())
		end
	end)
end