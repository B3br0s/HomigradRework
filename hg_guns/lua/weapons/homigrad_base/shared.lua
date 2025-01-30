-- shared.lua"
SWEP.Base = "weapon_base"
SWEP.PrintName = "base_hg"
SWEP.Category = "Other"
SWEP.Spawnable = false
SWEP.AdminOnly = true
SWEP.ReloadTime = 1
SWEP.ReloadSound = "weapons/smg1/smg1_reload.wav"
SWEP.Primary.SoundEmpty = {"weapons/ClipEmpty_Rifle.wav", 75, 100, 105, CHAN_WEAPON, 2}
SWEP.Primary.Wait = 0.1
SWEP.Primary.Next = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.RecoilAnim = 0.1
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.shouldDrawHolstered = true
hg.weapons = hg.weapons or {}

if SERVER then
	util.AddNetworkString("SoundBCST")
end

--function SWEP:PVS_Connect() end
function SWEP:Initialize()
	self:SetLastShootTime(0)
	self.LastPrimaryDryFire = 0
	self.EyeSpray = Angle(0, 0, 0)
	self.SprayI = 0
	self:Initialize_Anim()
	self:Initialize_Reload()
	self:SetClip1(self:GetMaxClip1())
	self:Draw()

	self:ClearAttachments()

	--game.AddParticles("particles/tfa_ins2_muzzlesmoke.pcf")
	--PrecacheParticleSystem("tfa_ins2_weapon_muzzle_smoke")

	hg.weapons[self] = true

	--SetNetVar("weapons",hg.weapons)

	if CLIENT then
		self:CallOnRemove("asdasd", function()
			if self.flashlight and self.flashlight:IsValid() then
				self.flashlight:Remove()
				self.flashlight = nil
			end
		end)
	end

	self.init = false
	
	if SERVER then hg.SyncWeapons() end
	self:InitializePost()
end

SWEP.WepSelectIcon2 = Material("null")
SWEP.IconOverride = ""
SWEP.IconPos = Vector(0,0,0)
SWEP.IconAng = Angle(0,0,0)

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	local WM = self.WorldModel

	if not IsValid(DrawingModel) then
		DrawingModel = ClientsideModel(self.WorldModel,RENDERGROUP_OPAQUE)
		DrawingModel:SetNoDraw(true)
	else
		DrawingModel:SetModel(self.WorldModel)
		local vec = Vector(18.7,150,-3)
		local ang = Vector(0,-90,0):Angle()

		cam.Start3D( vec, ang, 20, x, y+35, wide, tall, 5, 4096 )
			cam.IgnoreZ( true )
			render.SuppressEngineLighting( true )

			render.SetLightingOrigin( self:GetPos() )
			render.ResetModelLighting( 50/255, 50/255, 50/255 )
			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 255 )

			render.SetModelLighting( 4, 1, 1, 1 )

			DrawingModel:SetRenderAngles( self.IconAng )
			DrawingModel:SetRenderOrigin( self.IconPos)
			DrawingModel:DrawModel()
			DrawingModel:SetRenderAngles()

			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 1 )
			render.SuppressEngineLighting( false )
			cam.IgnoreZ( false )
		cam.End3D()
	end

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( self.WepSelectIcon2 )

	surface.DrawTexturedRect( x, y + 10,  256 * ScrW()/1920 , 128 * ScrH()/1080 )

	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )

end

if CLIENT then
	hook.Add("OnGlobalVarSet","hg-weapons",function(key,var)
		if key == "weapons" then
			hg.weapons = var
		end
	end)
else
	function hg.SyncWeapons()
		SetNetVar("weapons",hg.weapons)
	end
end

function SWEP:ShouldDropOnDie()
	return true
end

function SWEP:OwnerChanged()
	self.init = true
	self.reload = nil
	self.drawBullet = self:Clip1() > 0
end

function SWEP:InitializePost()
end

hg.weaponsDead = hg.weaponsDead or {}
function SWEP:OnRemove()
	if SERVER then
		hg.weapons[self] = nil

		SetNetVar("weapons",hg.weapons)
	end
end

local owner
local CurTime = CurTime
function SWEP:IsZoom()
	local owner = self:GetOwner()
	return self:GetOwner():KeyDown(IN_ATTACK2)
end

function SWEP:CanUse()
	return true
end

function SWEP:IsSprinting()
	local ply = self:GetOwner()
	return ply:IsSprinting() or ply.posture == 4 or ((self.holster or self.deploy) and true)
end

function SWEP:IsLocal()
	return CLIENT and self:GetOwner() == LocalPlayer()
end

local math_random = math.random
function SWEP:PlaySnd(snd, server, chan)
	if SERVER and not server then return end
	local owner = IsValid(self:GetOwner().FakeRagdoll) and self:GetOwner().FakeRagdoll or IsValid(self:GetOwner()) and self:GetOwner() or self
	if CLIENT then
		local view = render.GetViewSetup(true)
		local time = owner:GetPos():Distance(view.origin) / 17836
		timer.Simple(time, function()
			local owner = IsValid(self:GetOwner().FakeRagdoll) and self:GetOwner().FakeRagdoll or self:GetOwner() or self
			owner = IsValid(owner) and owner or self
			if type(snd) == "table" then
				EmitSound(snd[1], owner:GetPos(), owner:EntIndex(), chan or CHAN_WEAPON, snd[5] or 1, snd[2] or (self.Supressor and 75 or 75), 0, math_random(snd[3] or 100, snd[4] or 100), 0, nil)
			else
				EmitSound(snd, owner:GetPos(), owner:EntIndex(), chan or CHAN_WEAPON, 1, self.Supressor and 75 or 75, 0, 100, 0, nil)
			end
		end)
	else
		if type(snd) == "table" then
			EmitSound(snd[1], owner:GetPos(), owner:EntIndex(), chan or CHAN_WEAPON, snd[5] or 1, snd[2] or (self.Supressor and 75 or 75), 0, math_random(snd[3] or 100, snd[4] or 100), 0, nil)
		else
			EmitSound(snd, owner:GetPos(), owner:EntIndex(), chan or CHAN_WEAPON, 1, self.Supressor and 75 or 75, 0, 100, 0, nil)
		end
	end
end

function SWEP:PlaySndDist(snd)
	if SERVER then return end
	local owner = IsValid(self:GetOwner().FakeRagdoll) and self:GetOwner().FakeRagdoll or self:GetOwner()
	owner = IsValid(owner) and owner or self
	local view = render.GetViewSetup(true)
	local time = owner:GetPos():Distance(view.origin) / 17836
	timer.Simple(time, function()
		local owner = IsValid(self:GetOwner().FakeRagdoll) and self:GetOwner().FakeRagdoll or self:GetOwner() or self
		owner = IsValid(owner) and owner or self
		EmitSound(snd, owner:GetPos(), owner:EntIndex(), CHAN_AUTO, 1, self.Supressor and 1 or 120, 0, 100, 0, nil)
	end)
end

local math_Rand = math.Rand
local matrix, matrixSet
local math_random = math.random
local primary
local weapons_Get = weapons.Get
if SERVER then util.AddNetworkString("hgwep shoot") end
function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:Shoot(override)
	local primary = self.Primary
	if not self.drawBullet and not override then
		self.LastPrimaryDryFire = CurTime()
		self:PrimaryShootEmpty()
		primary.Automatic = false
		return false
	end

	if primary.Next > CurTime() then return false end
	if (primary.NextFire or 0) > CurTime() then return false end
	primary.Next = CurTime() + primary.Wait
	self:SetLastShootTime(CurTime())
	primary.Automatic = weapons_Get(self:GetClass()).Primary.Automatic
	self:PrimaryShoot()
	self:PrimaryShootPost()
end

function SWEP:PrimaryAttack()
	if self.CustomShoot then return end
	if not IsFirstTimePredicted() then return end
	if self:GetOwner():IsSprinting() then return end
	self:Shoot()
end

function SWEP:PrimaryShootPost()
end

function SWEP:Draw()
	if self.drawBullet == false then
		if CLIENT then self:RejectShell(self.ShellEject) end
		self.drawBullet = nil
	end

	if self:Clip1() > 0 then self.drawBullet = true end
end

SWEP.AutomaticDraw = true
function SWEP:PrimaryShoot()
	self:EmitShoot()
	self:FireBullet()
	self.dwr_reverbDisable = nil
	self:TakePrimaryAmmo(1)
	self.drawBullet = false
	if self.AutomaticDraw then self:Draw() end
	self:PrimarySpread()
end

function SWEP:PrimaryShootEmpty()
	if CLIENT then return end
	self:PlaySnd(self.Primary.SoundEmpty, true, CHAN_AUTO)
end

SWEP.DistSound = "m4a1/m4a1_dist.wav"
function SWEP:EmitShoot()
	if CLIENT then return end
	sound.Play((not self.Primary.RandomSounds and self.Primary.Sound[1] or table.Random(self.Primary.RandomSounds)),self:GetPos(),75,self.Primary.Sound[3],1)
	net.Start("SoundBCST")
	net.WriteEntity(self)
	net.Broadcast()
end

function SWEP:CanSecondaryAttack()
end

function SWEP:SecondaryAttack()
end

if CLIENT then
	local hook_Run = hook.Run
	hook.Add("Think", "homigrad-weapons", function()
		for wep in pairs(hg.weapons) do
			--local wep = ply:GetActiveWeapon()
			if not IsValid(wep) or not wep.Step or (not IsValid(wep:GetOwner()) and wep:GetVelocity():Length() < 1) then continue end
			hook_Run("SWEPStep", wep)
			wep:Step()
		end
	end)
end

local colBlack = Color(0, 0, 0, 125)
local colWhite = Color(255, 255, 255, 255)
local yellow = Color(255, 255, 0)
local vecZero = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)
local show = 0
local function LerpColor(lerp, source, set)
	return Lerp(lerp, source.r, set.r), Lerp(lerp, source.g, set.g), Lerp(lerp, source.b, set.b)
end

local col = Color(0, 0, 0)
function SWEP:DrawHUDAdd()
end

function SWEP:DrawHUD()
	local owner = self:GetOwner()
	show = Lerp(owner:KeyDown(IN_RELOAD) and 1 or 0.01, show, owner:KeyDown(IN_RELOAD) and 1 or 0.05)
	color_gray = Color(225, 215, 125, 190 * show)
	color_gray1 = Color(225, 215, 125, 255 * show)
	if show > 0 then
		local ply = LocalPlayer()
		local ammo, ammobag = self:GetMaxClip1(), self:Clip1()
		if ammobag > ammo - 1 then
			text = "Полон"
		elseif ammobag > ammo - ammo / 3 then
			text = "~Почти полон"
		elseif ammobag > ammo / 3 then
			text = "~Половина"
		elseif ammobag >= 1 then
			text = "~Почти пуст"
		elseif ammobag < 1 then
			text = "Пуст"
		end

		local ammomags = ply:GetAmmoCount(self:GetPrimaryAmmoType())
		if oldclip ~= ammobag then
			randomx = math.random(0, 5)
			randomy = math.random(0, 5)
			timer.Simple(0.15, function() oldclip = ammobag end)
		else
			randomx = 0
			randomy = 0
		end

		if oldmag ~= ammomags then
			randomxmag = math.random(0, 5)
			randomymag = math.random(0, 5)
			timer.Simple(0.35, function() oldmag = ammomags end)
		else
			randomxmag = 0
			randomymag = 0
		end

		local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
		local textpos = (hand.Pos + hand.Ang:Forward() * 7 + hand.Ang:Up() * 5 + hand.Ang:Right() * -1):ToScreen()
		if self.revolver then
			draw.DrawText("Барабан | " .. ammobag, "HomigradFontBig", textpos.x + randomx, textpos.y + randomy, color_gray1, TEXT_ALIGN_RIGHT)
			draw.DrawText("Пуль | " .. ammomags, "HomigradFontBig", textpos.x + randomxmag, textpos.y + 25 + randomymag, color_gray, TEXT_ALIGN_RIGHT)
		elseif self.shotgun then
			draw.DrawText("Магазин | " .. text, "HomigradFontBig", textpos.x + randomx, textpos.y + randomy, color_gray1, TEXT_ALIGN_RIGHT)
			draw.DrawText("Патрон | " .. ammomags, "HomigradFontBig", textpos.x + randomxmag, textpos.y + 25 + randomymag, color_gray, TEXT_ALIGN_RIGHT)
		else
			draw.DrawText("Магазин | " .. text, "HomigradFontBig", textpos.x + randomx, textpos.y + randomy, color_gray1, TEXT_ALIGN_RIGHT)
			draw.DrawText("Магазинов | " .. math.Round(ammomags / ammo), "HomigradFontBig", textpos.x + 5 + randomxmag, textpos.y + 25 + randomymag, color_gray, TEXT_ALIGN_RIGHT)
		end
end

	self:DrawHUDAdd()
end

if SERVER then
	function SWEP:Think()
		self:Step()
		if self.AddThinkNigga then
			self:AddThinkNigga()
		end
	end
else
	function SWEP:Think()
		if self.AddThinkNigga then
			self:AddThinkNigga()
		end
	end
end

function SWEP:Step()
	self:CoreStep()
end

local CurTime = CurTime
if CLIENT then
	local vecSmoke = Vector(255, 255, 255)
	function SWEP:MuzzleEffect(time)
		if time > 2 and self:Clip1() <= self:GetMaxClip1() / 2 or (self.particle and self.particle:IsValid()) then
			local att = self:GetMuzzleAtt(nil, true, true)
			if not self.particle or not self.particle:IsValid() then
				--self.particle = CreateParticleSystemNoEntity("tfa_ins2_weapon_muzzle_smoke", att.Pos, att.Ang)
			else
				--self.particle:SetControlPoint(0, att.Pos)
				--self.particle:SetControlPoint(1, vecSmoke)
			end

			if time > 5 then if self.particle and self.particle:IsValid() then self.particle:StopEmission() end end
		end
	end
else
	function SWEP:MuzzleEffect(time)
	end
end

if SERVER then
	util.AddNetworkString("place_bipod")
	function SWEP:PlaceBipod(bipod, dir)
		net.Start("place_bipod")
		net.WriteEntity(self)
		net.WriteVector(bipod)
		net.WriteVector(dir)
		net.Broadcast()
		self.bipodPlacement = bipod
		self.bipodDir = dir
	end

	function SWEP:RemoveBipod()
		net.Start("place_bipod")
		net.WriteEntity(self)
		net.Broadcast()
		self.bipodPlacement = nil
		self.bipodDir = nil
	end
else
	net.Receive("place_bipod", function()
		local self = net.ReadEntity()
		local pos, dir = net.ReadVector(), net.ReadVector()
		if pos:IsZero() or dir:IsZero() then
			self.bipodPlacement = nil
			self.bipodDir = nil
			return
		end

		self.bipodPlacement = pos
		self.bipodDir = dir
	end)
end

function SWEP:GunOverHead(height)
	local attheight = self:GetMuzzleAtt().Pos[3]
	local owner = self:GetOwner()
	return owner:GetAttachment(owner:LookupAttachment("eyes")).Pos[3] < (height or attheight)
end

function SWEP:CoreStep()
	local owner = self:GetOwner()
	if CLIENT then self:WorldModel_Transform() end
	if SERVER and not owner and IsValid(owner:GetActiveWeapon()) and self == owner:GetActiveWeapon() then
		self:RemoveFake()
		owner:DropWeapon()
		return
	end
	local time = CurTime() - self:LastShootTime()
	self:MuzzleEffect(time)
	local time = CurTime()
	self:Step_HolsterDeploy(time)
	self:Step_Reload(time)
	self:Animation(time)
	if self:IsClient() or SERVER then self:Step_Spray(time) end
	if self:IsClient() or SERVER then self:Step_SprayVel() end
	self:AttachmentsSetup()
	self:ThinkAtt()

	if SERVER then
		local bipod, dir = self:CheckBipod()
		if bipod then self:PlaceBipod(bipod, dir) end
		if self.bipodPlacement then self:RemoveBipod() end
	else
		if self.bipodPlacement and self.bipodPlacement:IsZero() then
			self.bipodPlacement = nil
			self.bipodDir = nil
		end
	end

	if SERVER then self:DrawAttachments() end
end

if SERVER then hook.Add("UpdateAnimation", "fuckgmodok", function(ply) ply:RemoveGesture(ACT_GMOD_NOCLIP_LAYER) end) end
if CLIENT then
	local nilTbl = {}
	function SWEP:CustomAmmoDisplay()
		return nilTbl
	end
end

local firstTrace = {}
local secondTrace = {}
local vecZero = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)
local hullVec = Vector(2, 2, 2)
function SWEP:CheckBipod()
	local owner = self:GetOwner()
	if not IsValid(owner) then return end
	if not self:GetOwner():KeyDown(IN_USE) or not self.bipodAvailable then return end
	table.Empty(firstTrace)
	table.Empty(secondTrace)
	local angles = owner:EyeAngles()
	angles[1] = 0
	angles[3] = 0
	local pos = owner:EyePos()
	pos[3] = owner:GetPos()[3]
	firstTrace.start = pos + vector_up * 10
	firstTrace.endpos = firstTrace.start + angles:Forward() * 20
	firstTrace.mins = -hullVec
	firstTrace.maxs = hullVec
	firstTrace.mask = MASK_SOLID
	firstTrace.filter = owner
	local tr1 = util.TraceHull(firstTrace)
	local foundPos = false
	local worldPos = -(-self.WorldPos)
	worldPos:Rotate(self:GetMuzzleAtt().Ang)
	local count = 0
	if tr1.Hit and util.QuickTrace(tr1.HitPos, -tr1.HitNormal * (hullVec[1] + 1)).Hit then
		local hitPos = tr1.HitPos - tr1.HitNormal * (hullVec[1] + 3)
		for i = 1, 100 do
			count = count + 1
			local tr = util.QuickTrace(hitPos, vector_up)
			if tr.StartSolid then
				hitPos:Add(vector_up * 1)
			else
				foundPos = hitPos + angles:Forward() * -3 + vector_up * 6 + worldPos
				break
			end
		end
	end

	foundPos = (foundPos and not self:GunOverHead(foundPos[3] - 5)) and foundPos or false
	return foundPos, foundPos and angles:Forward() or false
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Vector", 0, "muzzlepos" )
	self:NetworkVar( "Angle", 0, "muzzleang" )
end