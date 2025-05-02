SWEP.Base = "weapon_base"
SWEP.PrintName = "Homigrad Base"
//SWEP.Instructions = "ало"
SWEP.Spawnable = true
SWEP.DrawAmmo = false
SWEP.HoldType = "revolver"
SWEP.HolsterBone = "ValveBiped.Bip01_Pelvis"
SWEP.HolsterPos = Vector(-7,10,-5)
SWEP.HolsterAng = Angle(0,0,-90)
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.Author = "Homigrad"

hg.Weapons = hg.Weapons or {}

SWEP.CorrectPos = Vector(9.5,1.2,-3)
SWEP.CorrectAng = Angle(0,0,0)
SWEP.Primary.Wait = 0.1
SWEP.Primary.Damage = 15
SWEP.Primary.Force = 35
SWEP.Primary.Automatic = false
SWEP.TwoHands = false
SWEP.ViewModel = "models/weapons/arccw_go/v_pist_deagle.mdl"

SWEP.DrawTime = 0.1
SWEP.Deployed = true

SWEP.Primary.DefaultClip = 13
SWEP.Primary.ClipSize = 13
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/hndg_colt1911/colt_1911_fire1.wav"
SWEP.Primary.ReloadTimeEnd = 1.2
SWEP.Primary.ReloadTime = 2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    self.Reloading = false
    self.Inspecting = false
    self.SmoothedBolt = 0
	self.ishgwep = true
    hg.Weapons[self] = true
    self.Instructions = ""

	self:Initialize_Spray()
	self.Deployed = true

	self:SetHoldType(weapons.Get(self:GetClass()).HoldType)
end

function SWEP:Deploy()
	local ply = self:GetOwner()
	self:SetHoldType("normal")
	self.Deployed = false
	if self:IsPistolHoldType() then
		self:EmitSound("homigrad/weapons/draw_pistol.mp3")
	else
		self:EmitSound("homigrad/weapons/draw_rifle.mp3")
	end
	timer.Simple(self.DrawTime,function()
		self:SetHoldType(weapons.Get(self:GetClass()).HoldType)
		self.Deployed = true
	end)
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Think()
	if self:IsPistolHoldType() then
		self:StopSound("weapons/357/357_reload1.wav")
		self:StopSound("weapons/357/357_reload2.wav")
		self:StopSound("weapons/357/357_reload3.wav")
		self:StopSound("weapons/357/357_reload4.wav")
	end
end

function SWEP:OnRemove()
    if IsValid(self.worldModel) then
        self.worldModel:Remove()
    end
end

function SWEP:OwnerChanged()
    if IsValid(self.worldModel) then
        self.worldModel:Remove()
    end
end

function SWEP:CanShoot()
    return (!self.Reloading and !self.Inspecting and self:Clip1() > 0 and !self:IsSprinting())
end

if CLIENT then

	local hg_show_hitposmuzzle = CreateClientConVar("hg_show_hitposmuzzle","0",false,false,"huy",0,1)

	hook.Add("HUDPaint","admin_hitpos",function()
		if hg_show_hitposmuzzle:GetBool() and LocalPlayer():IsAdmin() then
			local wep = LocalPlayer():GetActiveWeapon()

			if !hg.Weapons[wep] then
				return
			end

			if !wep.SetupMuzzle then
				return
			end

			wep:SetupMuzzle()

			local tr = wep:GetTrace()

			local hit = tr.HitPos:ToScreen()
			local start = tr.StartPos:ToScreen()

			surface.SetDrawColor( 255, 255, 255, 100)
			surface.DrawRect(hit.x - 2,hit.y - 2,4,4)

			surface.SetDrawColor( 255, 51, 0)
			surface.DrawRect(start.x - 2,start.y - 2,4,4)

			surface.SetDrawColor( 0, 0, 0)
			surface.DrawRect(ScrW() / 2 - 2,ScrH() / 2 - 2,4,4)
		end
	end)

	net.Receive("hgwep shoot",function()
		local wep = net.ReadEntity()

		if wep.Shoot then
			wep:Shoot(true)
		end
	end)
else
	util.AddNetworkString("hgwep shoot")
end

function SWEP:PrimaryAttack()
    if !self:CanShoot() then return end
    if self:GetNextPrimaryFire() > CurTime() then return end
    if self.NextShoot and self.NextShoot > CurTime() then return end
    self:Shoot()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Wait)

	if SERVER then
		net.Start("hgwep shoot")
		net.WriteEntity(self)
		net.SendOmit(self:GetOwner())
	end
end

hook.Add("Think", "Homigrad-Weapons", function()
	for wep in pairs(hg.Weapons) do
		if not IsValid(wep) or not wep.Step or not IsValid(wep:GetOwner()) then continue end
		wep:Step()
	end
end)

local lastcall = 0

function SWEP:Step()
    if not IsValid(self:GetOwner()) then return end
    local owner = self:GetOwner()

    if owner:GetActiveWeapon() != self and CLIENT then
        local Pos,Ang = self:DrawHolsterModel() 

		if IsValid(self.worldModel) and Pos then
			local mdl = self.worldModel

			mdl:SetPos(Pos)
			mdl:SetAngles(Ang)

			self:SetPos(Pos)
			self:SetAngles(Ang)

			mdl:SetRenderAngles(Ang)
			mdl:SetRenderOrigin(Pos)
		end
    elseif owner:GetActiveWeapon() == self then
		local dtime = SysTime() - lastcall
		lastcall = SysTime()

		self:Step_Anim()
		self:Reload_Step()
		
		self:Step_Spray(CurTime(),dtime)
    end
end

function SWEP:GetSAttachment(obj)
	local pos, ang = self:GetTransform()
	local owner = self:GetOwner()
	
	local wep = IsValid(owner) and owner:GetNWEntity("ragdollWeapon",self) or self

	local model = IsValid(wep) and wep or self
	
	local att = model:GetAttachment(obj)
	
	if not att then return end

	if IsValid(wep) then return att end
	
	local bon = att.Bone or 0
	local mat = model:GetBoneMatrix(bon)
	local bonepos, boneang = mat:GetTranslation(), mat:GetAngles()
	local lpos, lang = WorldToLocal(att.Pos or bonepos, att.Ang or boneang, bonepos, boneang)
	
	if CLIENT then self:SetupBones() end

	local mat = model:GetBoneMatrix(bon)
	local bonepos, boneang = mat:GetTranslation(), mat:GetAngles()

	local pos, ang = LocalToWorld(lpos, lang, bonepos, boneang)
	
	return {Pos = pos, Ang = ang, Bone = bon}
end

function SWEP:GetHitTrace()
	local pos, ang = self:GetTraceModel()

	local tr = {}
	tr.start = pos
	tr.endpos = pos + ang:Forward() * 50000
	tr.filter = {self, self:GetOwner()}

	return util.TraceLine(tr), pos, ang
end

function SWEP:IsLocal()
	return CLIENT and self:GetOwner() == LocalPlayer()
end

function SWEP:GetTraceModel(nomodify)
	local owner = self:GetOwner()
	local obj = self:LookupAttachment("muzzle") or 0
	
	local att = self:GetSAttachment(self.att or obj)
	
	if not att then
		local Pos, Ang
		
		local wep = IsValid(owner) and owner:GetNWEntity("ragdollWeapon")
		if wep and IsValid(wep) then
			Pos, Ang = wep:GetPos(), wep:GetAngles()
		else
			Pos, Ang = self:GetTransform()
		end

		att = {Pos = Pos, Ang = Ang}
	end
	
	local pos, ang = att.Pos, att.Ang

	if not nomodify then
		pos, ang = LocalToWorld(self.addPos or vector_origin,self.addAng or angle_zero,att.Pos,att.Ang)
	end

	return pos, ang
end

function SWEP:DrawHUDAdd()
end

function SWEP:DrawHUD()
	local ply = self:GetOwner()
	self:DrawHUDAdd()
	show = math.Clamp(self.AmmoChek or 0,0,1)
	self.AmmoChek = Lerp(2*FrameTime(),self.AmmoChek or 0,0)
	color_gray = Color(225,215,125,190*show)
	color_gray1 = Color(225,215,125,255*show)
	if show > 0 then
	local ply = LocalPlayer()
	local ammo,ammobag = self:GetMaxClip1(), self:Clip1()
	if ammobag > ammo - 1 then
		text = hg.GetPhrase("gun_full")
	elseif ammobag > ammo - ammo/3 then
		text = hg.GetPhrase("gun_nearfull")
	elseif ammobag > ammo/3 then
		text = hg.GetPhrase("gun_halfempty")
	elseif ammobag >= 1 then
		text = hg.GetPhrase("gun_nearempty")
	elseif ammobag < 1 then
		text = hg.GetPhrase("gun_empty")
	end

	local ammomags = ply:GetAmmoCount( self:GetPrimaryAmmoType() )

	if oldclip != ammobag then
		randomx = math.random(0, 5)
		randomy = math.random(0, 5)
		timer.Simple(0.15, function()
			oldclip = ammobag
		end)
	else
		randomx = 0
		randomy = 0
	end

	if oldmag != ammomags then
		randomxmag = math.random(0, 5)
		randomymag = math.random(0, 5)
		timer.Simple(0.35, function()
			oldmag = ammomags
		end)
	else
		randomxmag = 0
		randomymag = 0
	end

	local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
	local textpos = (hand.Pos+hand.Ang:Forward()*7+hand.Ang:Up()*5+hand.Ang:Right()*-1):ToScreen()
	if self.IsRevolver then
		draw.DrawText( string.format(hg.GetPhrase("gun_revolver"),ammobag), "HomigradFontBig", textpos.x+randomx, textpos.y+randomy, color_gray1, TEXT_ALIGN_RIGHT )
		draw.DrawText( string.format(hg.GetPhrase("gun_revolvermags"),ammomags), "HomigradFontBig", textpos.x+randomxmag, textpos.y+25+randomymag, color_gray, TEXT_ALIGN_RIGHT )
	elseif self.IsShotgun then
		draw.DrawText( string.format(hg.GetPhrase("gun_shotgun"),text), "HomigradFontBig", textpos.x+randomx, textpos.y+randomy, color_gray1, TEXT_ALIGN_RIGHT )
		draw.DrawText( string.format(hg.GetPhrase("gun_shotgunmags"),ammomags), "HomigradFontBig", textpos.x+randomxmag, textpos.y+25+randomymag, color_gray, TEXT_ALIGN_RIGHT )
	else
		draw.DrawText( string.format(hg.GetPhrase("gun_default"),text), "HomigradFontBig", textpos.x+randomx, textpos.y+randomy, color_gray1, TEXT_ALIGN_RIGHT )
		draw.DrawText( string.format(hg.GetPhrase("gun_defaultmags"),math.Round(ammomags/ammo)), "HomigradFontBig", textpos.x+5+randomxmag, textpos.y+25+randomymag, color_gray, TEXT_ALIGN_RIGHT )
	end
	end
end

function SWEP:DrawWorldModel()
	if self.Bodygroups then
        for _, bodygroup in ipairs(self.Bodygroups) do
            self:SetBodygroup(_,bodygroup)
        end
    end
    if not IsValid(self:GetOwner()) then self:DrawModel() return end
    local owner = self:GetOwner()

	local Pos,Ang = self:DrawWM()

	if IsValid(self.worldModel) and Pos then
		self.worldModel:SetPos(Pos)
		self.worldModel:SetAngles(Ang)
		if self.Bodygroups then
			for _, bodygroup in ipairs(self.Bodygroups) do
				self.worldModel:SetBodygroup(_,bodygroup)
			end
		end
	end
end