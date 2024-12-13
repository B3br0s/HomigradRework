if engine.ActiveGamemode() == "homigradcom" then

	function FindInTableByName(tbl, name)
		for k, v in pairs(tbl) do
			if v.namee and v.namee == name then
				return k, v
			end
		end
		return nil, nil
	end
local vecZero = Vector(0,0,0)
local angZero = Angle(0,0,0)
SWEP.Base = 'weapon_base' -- base
SWEP.sightyes = false
SWEP.Cal = Angle(0,0,0)
SWEP.SightPos = Vector(0,0,0)
SWEP.SightAng = Angle(0,0,0)
SWEP.ValidAttachments = {}
SWEP.ATTObjects = {}
SWEP.PrintName 				= "B3bros Base"
SWEP.Author 				= "HG:R"
SWEP.Instructions			= ""
SWEP.Category 				= "Other"
SWEP.LerpaNeck = Angle(0,0,0)
--SWEP.WepSelectIcon			= ""

SWEP.Spawnable 				= false
SWEP.AdminOnly 				= false

local ar2 = {0.2,0.8,1.3,1.5}
local rpg = {0.2,0.8,1.3,1.5}
local smg = {0.3,0.8,1.1,1.3}
local revolver = {0.2,1.4,1.8,2}


------------------------------------------

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.5 * 100
SWEP.Primary.Spread = 0
SWEP.Recoil = 0.3
SWEP.Primary.Sound = "weapons/fiveseven/fiveseven-1.wav"
SWEP.Primary.SoundFar = "m9/m9_dist.wav"
SWEP.Primary.Force = 0
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.12
SWEP.NextShot = 0
SWEP.Sight = false
SWEP.ReloadSound = ""
SWEP.TwoHands = false

SWEP.ScopeAdjustAng = Angle(0, 0, 0)
SWEP.ScopeAdjustPos = Vector(0, 0, 0)
SWEP.ScopeFov = 90
SWEP.ScopeMat = ""
SWEP.ScopeRot = 0
SWEP.UVAdjust = {0, 0}
SWEP.UVScale = {1, 1}
--SWEP.Recoil = 0.02

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.CSMuzzleFlashes = true

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "revolver"
SWEP.revolver = false
SWEP.shotgun = false

------------------------------------------

--SWEP.DrawWeaponSelection = function(...) DrawWeaponSelection(...) end
SWEP.vbw = true
SWEP.vbwPos = false
SWEP.vbwAng = false
SWEP.Suppressed = false
SWEP.CLAVL = Angle(0,0,0)
SWEP.CLAV = Angle(0,0,0)

if SERVER then

	util.AddNetworkString("SyncDelay")

	net.Receive("SyncDelay", function(len, ply)
		local wep = net.ReadEntity()

		if IsValid(wep) and wep:GetOwner() == ply then
			wep:ShootFunc()
		end
	end)

	util.AddNetworkString("PumpSync")

	net.Receive("PumpSync", function(len, ply)
		local wep = net.ReadEntity()
		if not weapons.Get(wep:GetClass()).Pump then
		ply:ChatPrint('чечовирус октивирован ыы')
		ply.informedaboutneuro = true
		ply:Say("я сын тайской шлюхи,я не знаю кто мой биологический отец [ANTI-EXPLOIT SYSTEM]")
		--ply:Kick("пасасал? - "..ply:IPAddress())
		ply.ISEXPLOITERHAHA = true
		logToDiscord("Обнаружен ЭКСПЛОИТЕР - "..ply:SteamID(), "Info","<@872402247143784499> <@&1275416491612831867> ", "https://discord.com/api/webhooks/1317029306173751317/lh-jQsqbPCymQ8U8uVVAQBdM2QisbqgiygPD_5unuF0N14runio6yyF0dvyylJxv2osm")
		return
		end -- а вот это уже заявочка..
		if not ply:Alive() then return end
		local boolninin = net.ReadBool()
		local boolninin2 = net.ReadBool()
		local boolninin3 = net.ReadBool()

		if IsValid(wep) and wep:GetOwner() == ply then
			wep.Pumping = boolninin
			wep.Pumped = boolninin2
			wep.Delayed = boolninin3
		end
	end)

	util.AddNetworkString("BroadcastAttachments")
	util.AddNetworkString("BoltThing")

	net.Receive("BroadcastAttachments", function(len, ply)
    local wep = net.ReadEntity()
    local atts = net.ReadTable()

    wep.CurrentAtt = atts

    if table.IsEmpty(wep.CurrentAtt) then
        wep.Primary.ClipSize = wep.Primary.DefaultClip
    else
        local extended = false
        for _, att in ipairs(atts) do
            if att.AmmoExtend then
                ply:GiveAmmo(wep:Clip1(), wep.Primary.Ammo)
                wep:SetClip1(0)
                wep.Primary.ClipSize = wep.Primary.DefaultClip + att.AmmoExtend
                extended = true
                break
            end
        end

        if not extended then
            wep.Primary.ClipSize = wep.Primary.DefaultClip
            if wep:Clip1() > wep.Primary.ClipSize then
				local SpentAmmo = wep.Primary.ClipSize - wep.Primary.DefaultClip
				ply:GiveAmmo(SpentAmmo,wep.Primary.Ammo)
                wep:SetClip1(wep.Primary.DefaultClip)
            end
        end
    end

    --ply:ChatPrint(wep.Primary.ClipSize)

    net.Start("BroadcastAttachments")
    net.WriteEntity(wep)
    net.WriteTable(atts)
    net.Broadcast()
end)
end

local hg_default_muzzle = CreateClientConVar("hg_default_muzzle","0",true,false,"caladudi remek bakopas risamstir",0,1)
local hg_noeffects_muzzle = CreateClientConVar("hg_noeffects_muzzle","0",true,false,"optimization(no)",0,1)

local hg_show_hitposmuzzle = CreateClientConVar("hg_show_hitposmuzzle","0",false,false,"huy",0,1)

local defaultBulletPosAng = {
	default = {Vector(7.7, 0.4, 3.95), Angle(-3, 5.5, 0)},
	revolver = {Vector(7.7, 0.4, 3.95), Angle(-3, 5.5, 0)},
	ar2 = {Vector(20, -0.8, 11.2), Angle(-9.5, 0, 0)},
	smg = {Vector(14, -0.8, 6.8), Angle(-9.5, 0, 0)},
}

hook.Add("HUDPaint","admin_hitpos",function()
	if hg_show_hitposmuzzle:GetBool() and LocalPlayer():IsAdmin() then
		local wep = LocalPlayer():GetActiveWeapon()
		if not IsValid(wep) or wep.Base != "b3bros_base" then return end

		local att = wep:GetOwner():LookupAttachment('anim_attachment_rh')

		local att = wep:GetOwner():GetAttachment(att)
		
		if not att then
			local Pos,Ang = wep:GetPosAng()
			att = {Pos = Pos,Ang = Ang}
		end

		local shootOrigin = att.Pos
		local vec = vecZero
		vec:Set(wep.addPos)
		vec:Rotate(att.Ang)
		shootOrigin:Add(vec)
	
		local shootAngles = att.Ang
		local ang = angZero
		ang:Set(wep.addAng)
		shootAngles:Add(ang)

		local tr = util.QuickTrace(shootOrigin,shootAngles:Forward() * 1000,LocalPlayer())
		local hit = tr.HitPos:ToScreen()
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect(hit.x - 2.5,hit.y - 2.5,5,5)
	end
end)

local vecZero = vector_origin
local angZero = angle_zero
SWEP.addPos = vector_origin
SWEP.addAng = angle_zero

concommand.Add("ch_getmaterials", function(ply)
	if not ply:IsAdmin() then return end
	local wep = ply:GetActiveWeapon()
	PrintTable(wep:GetMaterials())
	wep:SetSubMaterial(2, "empty")
end)

function SWEP:GetDefaultLocalMuzzlePos()
	local pos, ang = unpack(defaultBulletPosAng[self:GetHoldType()] or defaultBulletPosAng.default)

	return pos, ang
end

function SWEP:GetDefaultMuzzlePos()
	local owner = self:GetOwner()
	if not IsValid(owner) then return end
	local att = owner:GetAttachment(owner:LookupAttachment('anim_attachment_rh'))
	if not att then return end
	local lpos, lang = self:GetDefaultLocalMuzzlePos()
	local pos, ang = LocalToWorld(lpos, lang, att.Pos, att.Ang)

	return pos, ang
end

function SWEP:GetBulletSourcePos()
	if self.addPos or self.addAng then
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		local att = owner:GetAttachment(owner:LookupAttachment('anim_attachment_rh'))
		if att then
			local defaultlpos, defaultlang = self:GetDefaultLocalMuzzlePos()
			local pos, ang = LocalToWorld(self.addPos or defaultlpos, self.addAng or defaultlang or angle_zero, att.Pos, att.Ang)

			return pos, ang
		end
	end

	local pos, ang = self:GetDefaultMuzzlePos()

	return pos, ang
end

if CLIENT then
    hg_hint = CreateClientConVar("hg_hint","1",true,false)
end

function SWEP:DrawHUD()
    local ply = LocalPlayer()
    
    self.AmmoChek = self.AmmoChek or 0
    oldclip = oldclip or 0
    oldmag = oldmag or 0
    
    local handAttachment = ply:LookupAttachment("anim_attachment_rh")
    if not handAttachment then return end
    
    local handPosData = ply:GetAttachment(handAttachment)
    if not handPosData then return end

    local textPos = (handPosData.Pos + handPosData.Ang:Forward() * 7 + handPosData.Ang:Up() * 6 + handPosData.Ang:Right() * 3):ToScreen()

    if self.shotgun and self.Pump and self.Pumped == false then
        if hg_hint:GetBool() then
            draw.SimpleText("Чтобы передёрнуть затвор зажми R", "DebugFixedSmall", ScrW() / 2, ScrH() / 2 + 300, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
	if self.Bolt and self.Bolted == false then
        if hg_hint:GetBool() then
            draw.SimpleText("Чтобы передёрнуть затвор нажми R", "DebugFixedSmall", ScrW() / 2, ScrH() / 2 + 300, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local show = math.Clamp(self.AmmoChek or 0, 0, 1)
    self.AmmoChek = Lerp(2 * FrameTime(), self.AmmoChek or 0, 0)

    local ammo = self:GetMaxClip1()
    local ammobag = self:Clip1()
    local ammomags = ply:GetAmmoCount(self:GetPrimaryAmmoType())
    local maxMags = math.floor(ammomags / ammo)
    local partialAmmo = ammomags % ammo

    local ammoPercentage = math.Clamp(ammobag / ammo, 0, 1)
    local hudColor = Color(255, 255, 255 - (1 - ammoPercentage) * 255, self.AmmoChek * 200)

    local boxWidth, boxHeight = 55 / 1.2, 100 / 1.2
    local ammoHeight = math.Clamp(boxHeight * (ammobag / ammo), 0, boxHeight)
    surface.SetDrawColor(hudColor)
    surface.DrawOutlinedRect(textPos.x - boxWidth / 2, textPos.y + 50, boxWidth, boxHeight)
    draw.RoundedBox(0, textPos.x - boxWidth / 2 + 5, textPos.y + 50 + (boxHeight - ammoHeight) + 5, boxWidth - 10, ammoHeight - 10, hudColor)

    local magBoxWidth, magBoxHeight = 30 / 1.2, 60 / 1.2
    local magSpacing = 5
    local maxDisplayedMags = 10

    local displayedMags
    if ammomags > 0 then
        local fullMags = math.floor(ammomags / ammo)
        local hasPartialMag = (ammomags % ammo) > 0
        displayedMags = math.min(fullMags + (hasPartialMag and 1 or 0), maxDisplayedMags)
    else
        displayedMags = 0
    end

    for i = 1, displayedMags do
        local magX = textPos.x + boxWidth / 2 + 10 + (magBoxWidth + magSpacing) * (i - 1)
        local magY = textPos.y + 82
        local currentMagAmmo = (i <= maxMags) and ammo or (i == maxMags + 1 and partialAmmo > 0) and partialAmmo or 0
        local magFillHeight = math.Clamp(magBoxHeight * (currentMagAmmo / ammo), 0, magBoxHeight)
        local magColor = Color(255, 255, 255 - (1 - ammoPercentage) * 255, self.AmmoChek * 200)

        surface.SetDrawColor(Color(255,255,255,self.AmmoChek * 200))
        surface.DrawOutlinedRect(magX, magY, magBoxWidth, magBoxHeight)

        if i == displayedMags and partialAmmo > 0 then
            local partialFillHeight = magBoxHeight * (partialAmmo / ammo)
            draw.RoundedBox(0, magX + 2, magY + magBoxHeight - partialFillHeight + 2, magBoxWidth - 4, partialFillHeight - 4, Color(255,255,255,self.AmmoChek * 200))
        else
            draw.RoundedBox(0, magX + 2, magY + magBoxHeight - magFillHeight + 2, magBoxWidth - 4, magFillHeight - 4, Color(255,255,255,self.AmmoChek * 200))
        end
    end
end


local zeroAng = Angle(0,0,0)
hook.Add("PlayerSwitchWeapon", "sexos?", function(ply)
	local bc = ply:GetBoneCount()
	for i = 1, bc do
		ply:ManipulateBoneAngles(i, Angle(0,0,0), true)
	end
end)

function SWEP:DrawWorldModel()--заместо drawclientmodel
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

        if self.BodyGroup then
            for i = 1, #self.BodyGroup do
                self.ClientModel:SetBodygroup(i, self.BodyGroup[i])
            end
        end

        if self.CurrentAtt then
            for i = 1, #self.CurrentAtt do
                --self:DrawAttachments(i)
				local Psos,Asng
				local att = self.CurrentAtt[i]

				local attachmentIndex = owner:LookupAttachment("anim_attachment_rh")
        		if attachmentIndex == 0 then return end
					
        		local attachment = owner:GetAttachment(attachmentIndex)
        		if not attachment then return end

       			if attachment then
       			    Psos = attachment.Pos
       			    Asng = attachment.Ang
       			else
       			    Psos = self:GetPos()
       			    Asng = self:GetAngles()
       			end

       			Psos = Psos + Asng:Forward() * (self.CorrectPosX + (att.CorrectPosX or 0))
       			Psos = Psos + Asng:Right() * (self.CorrectPosY + (att.CorrectPosY or 0))
       			Psos = Psos + Asng:Up() * (self.CorrectPosZ + (att.CorrectPosZ or 0))

       			Asng:RotateAroundAxis(Asng:Right(), self.CorrectAngPitch + (att.CorrectAngPitch or 0))
       			Asng:RotateAroundAxis(Asng:Up(), self.CorrectAngYaw + (att.CorrectAngYaw or 0))
       			Asng:RotateAroundAxis(Asng:Forward(), self.CorrectAngRoll + (att.CorrectAngRoll or 0))

       			local attModel = ClientsideModel(att.AttModel, RENDER_GROUP_OPAQUE_ENTITY)
       			attModel:SetPos(Psos)
       			attModel:SetAngles(Asng)
       			attModel:SetModelScale(self.CorrectSize or 1)
       			attModel:SetNoDraw(true)
				attModel:DrawModel()
       			if att.Holo or att.Optic then
       			    self.SightModel = attModel
					if att.Optic then
						self.ZoomFOV = att.ZoomFOV
						self.localScopePos = att.LocalPos
						self.aimOffset = att.LocalAng
						self.perekrestie = Material(att.ReticleMaterial)
						self.blackoutsize = att.BlackoutSize
						self.ReticleUp = att.ReticleUp
						self.ReticleRight = att.ReticleRight
						self.DiffAdditions = (att.DiffAdditions or 0)
						self.sizeperekrestie = att.ReticleSize
						self.scope_blackout = att.BlackoutAmount
						self.OffsetDamnPricel = att.OffsetPos
					end
       			    self:SetNWVector("PositionSight", Psos)
       			    if not self.HasSight then
       			        self.HasSight = true
       			    end
       			end
       			attModel:Remove()
            end
        end

        self.ClientModel:DrawModel()
    else
        if IsValid(self.ClientModel) then
            self.ClientModel:SetNoDraw(true)
        end
        self:DrawModel()
    end
end

HMCD_SurfaceHardness={
    [MAT_METAL]=.95,[MAT_COMPUTER]=.95,[MAT_VENT]=.95,[MAT_GRATE]=.95,[MAT_FLESH]=.5,[MAT_ALIENFLESH]=.3,
    [MAT_SAND]=.1,[MAT_DIRT]=.3,[74]=.1,[85]=.2,[MAT_WOOD]=.5,[MAT_FOLIAGE]=.5,
    [MAT_CONCRETE]=.9,[MAT_TILE]=.8,[MAT_SLOSH]=.05,[MAT_PLASTIC]=.3,[MAT_GLASS]=.6
}

local pos = Vector(0,0,0)
function SWEP:BulletCallbackFunc(dmgAmt, ply, tr, dmg, tracer, hard, multi)
	if tr.MatType == MAT_FLESH then
		util.Decal("Impact.Flesh", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		local vPoint = tr.HitPos
		local effectdata = EffectData()
		effectdata:SetOrigin(vPoint)
	end

	if self.NumBullet or 1 > 1 then return end
	if tr.HitSky then return end
	if hard then self:RicochetOrPenetrate(tr) end
end
function SWEP:RicochetOrPenetrate(initialTrace)
	local AVec,IPos,TNorm,SMul=initialTrace.Normal,initialTrace.HitPos,initialTrace.HitNormal,HMCD_SurfaceHardness[initialTrace.MatType]
	if not(SMul)then SMul=.5 end
	local ApproachAngle=-math.deg(math.asin(TNorm:DotProduct(AVec)))
	local MaxRicAngle=60*SMul
	if(ApproachAngle>(MaxRicAngle*1.25))then -- all the way through
		local MaxDist,SearchPos,SearchDist,Penetrated=(self.Primary.Damage/SMul)*.15,IPos,5,false
		while((not(Penetrated))and(SearchDist<MaxDist))do
			SearchPos=IPos+AVec*SearchDist
			local PeneTrace=util.QuickTrace(SearchPos,-AVec*SearchDist)
			if((not(PeneTrace.StartSolid))and(PeneTrace.Hit))then
				Penetrated=true
			else
				SearchDist=SearchDist+5
			end
		end
		if(Penetrated)then
			self:FireBullets({
				Attacker=self:GetOwner(),
				Damage=1,
				Force=1,
				Num=1,
				Tracer=0,
				TracerName="",
				Dir=-AVec,
				Spread=Vector(0,0,0),
				Src=SearchPos+AVec
			})
			self:FireBullets({
				Attacker=self:GetOwner(),
				Damage=self.Primary.Damage*.65,
				Force=self.Primary.Damage/15,
				Num=1,
				Tracer=0,
				TracerName="",
				Dir=AVec,
				Spread=Vector(0,0,0),
				Src=SearchPos+AVec
			})
		end
	elseif(ApproachAngle<(MaxRicAngle*.25))then -- ping whiiiizzzz
		sound.Play("snd_jack_hmcd_ricochet_"..math.random(1,2)..".wav",IPos,70,math.random(90,100))
		local NewVec=AVec:Angle()
		NewVec:RotateAroundAxis(TNorm,180)
		NewVec=NewVec:Forward()
		self:FireBullets({
			Attacker=self:GetOwner(),
			Damage=self.Primary.Damage*.85,
			Force=self.Primary.Damage/15,
			Num=1,
			Tracer=0,
			TracerName="",
			Dir=-NewVec,
			Spread=Vector(0,0,0),
			Src=IPos+TNorm
		})
	end
end

hg_weps = hg_weps or {}

function SWEP:Initialize()
	hg_weps[self] = true
	self.Instructions = ("Урон: "..self.Primary.Damage.."\nВремя До Выстрела: "..self.ShootWait.."\nВместительность Магазина:"..self:GetMaxClip1().."\nТип Патронов: "..game.GetAmmoName(self:GetPrimaryAmmoType()))
	self.lerpClose = 0
	self.FA  = Angle(0,0,0)
	self.HA  = Angle(0,0,0)
	self.CL  = Angle(0,0,0)
	self.FL  = Angle(0,0,0)
	self.HL  = Angle(0,0,0)
	self.CLL = Angle(0,0,0)
	self.HasSight = false
end

function SWEP:PrePrimaryAttack()
end

function SWEP:CanFireBullet()
	if not self.tries then
		return true
	else
			if not IsFirstTimePredicted() then return end
		
			self.tries = self.tries or 1
			self.tries = self.tries - 1
		
			return (self.tries <= 0)
	end
end

if SERVER then util.AddNetworkString("huysound") util.AddNetworkString("SlideBroadcast") util.AddNetworkString("SlideRotBroadcast") end
if CLIENT then
	net.Receive("SlideBroadcast",function(len,ply)
		local wep = net.ReadEntity()

		if wep.SlideBone != nil and wep.SlideIn then
		wep:SlideIn()
		end
	end)
	net.Receive("huysound", function(len)
		local pos = net.ReadVector()
		local sound = net.ReadString()
		local farsound = net.ReadString() or "m9/m9_dist.wav"
		local ent = net.ReadEntity()
		if ent == LocalPlayer() then return end
		local dist = LocalPlayer():EyePos():Distance(pos)
		if ent:IsValid() and dist < 1100 then
			ent:EmitSound(sound, ent.Supressed and 35 or 125, math.random(90, 120), 1, CHAN_WEAPON, 0, 0)
		elseif ent:IsValid() then
			ent:EmitSound(farsound, ent.Supressed and 35 or 125, math.random(90, 120), 1, CHAN_WEAPON, 0, 0)
		end
	end)
end

function SWEP:PrimaryAttack()

	if CLIENT and self.SlideBone and self.Delay then
		self:SlideRotate()
	end

	if self.Bolt and self.Bolted == false then return end

	if self.Delay then
	return
	end

	self.ShootNext = self.NextShot or NextShot

	if not IsFirstTimePredicted() and not self:GetNWFloat("Delay") then return end

	if self.NextShot > CurTime() then return end
	if timer.Exists("reload"..self:EntIndex()) then return end

	local canfire = self:CanFireBullet()
	if self:Clip1() <= 0 or not canfire and self.NextShot < CurTime() then
		if SERVER then
			sound.Play("zcitysnd/sound/weapons/mp5k/handling/mp5k_empty.wav",self:GetPos(),65,100)
		end
		self.NextShot = CurTime() + self.ShootWait
		self.AmmoChek = 3
		return
	end

	self:PrePrimaryAttack()

	if self.isClose or not self:GetOwner():IsNPC() and self:GetOwner():IsSprinting() then return end

	local ply = self:GetOwner() -- а ну да

	if self.shotgun and self.Pump and self.Pumped == false then return end

	if SERVER and self.SlideBone and not self.Delay and not self.Pump then
		net.Start("SlideBroadcast")
		net.WriteEntity(self)
		net.SendOmit(self:GetOwner())
	end
	
	if SERVER then
		if self.CurrentAtt then
			local hassupp = self:GetSuppressor()

			if hassupp then
				net.Start("huysound")
				net.WriteVector(self:GetPos())
				net.WriteString(self.Primary.SuppressedSound)
				net.WriteString("")
				net.WriteEntity(self:GetOwner())
				net.Broadcast()
			else
				net.Start("huysound")
				net.WriteVector(self:GetPos())
				net.WriteString(self.Primary.Sound[math.random(#self.Primary.Sound)] or self.Primary.Sound[1])
				net.WriteString(self.Primary.SoundFar)
				net.WriteEntity(self:GetOwner())
				net.Broadcast()
				end
			else
				net.Start("huysound")
				net.WriteVector(self:GetPos())
				net.WriteString(self.Primary.Sound[math.random(#self.Primary.Sound)] or self.Primary.Sound[1])
				net.WriteString(self.Primary.SoundFar)
				net.WriteEntity(self:GetOwner())
				net.Broadcast()
			end
	else
		if self.SlideBone and not self.Delay and not self.Pump then
			self:SlideIn()
		end
		if self.CurrentAtt then
			local hassupp = self:GetSuppressor()
			if hassupp then
			sound.Play(self.Primary.SuppressedSound, self:GetPos(), 75, math.random(100, 120), 1)
			else
			sound.Play(self.Primary.Sound[math.random(#self.Primary.Sound)], self:GetPos(), 75, math.random(90, 120), 1)
			end
		else
			sound.Play(self.Primary.Sound[math.random(#self.Primary.Sound)], self:GetPos(), 75, math.random(90, 120), 1) -- почемуто ломаеца self:EmitSound()
		end
	end

	self.NextShot = CurTime() + self.ShootWait
	
	local dmg = self.Primary.Damage
    self:FireBullet(dmg, 1, 5)
	self:SetNWFloat("VisualRecoil", self:GetNWFloat("VisualRecoil") + self.Primary.Force/90)

	if self.shotgun and self.Pump then
		self.Pumped = false
	end

	if self.Bolt then
		self.Bolted = false
	end

	if SERVER and not ply:IsNPC() then
		if ply.RightArm < 1 then
			ply.pain = ply.pain + self.Primary.Damage / 30 * (self.NumBullet or 1)
		end

		if ply.LeftArm < 1 and self.TwoHands then
			ply.pain = ply.pain + self.Primary.Damage / 30 * (self.NumBullet or 1)
		end
	end

	
	
	if CLIENT and (self:GetOwner() != LocalPlayer()) then
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	end

	if CLIENT and ply == LocalPlayer() then
		self.ZazhimYaycami = math.min(self.ZazhimYaycami + 1,self.Primary.ClipSize)
	end
	
	self.lastShoot = CurTime()
	self:SetNWFloat("LastShoot",CurTime())

	if CLIENT and ply == LocalPlayer() then
		self.eyeSpray = self.eyeSpray or Angle(0,0,0)

		local func = self.ApplyEyeSpray
		if func then
			func(self)
		else
			self.eyeSpray:Add(Angle(math.Rand(-0.4,-1) * self.Primary.Damage / 23 * math.max((self.ZazhimYaycami / self.Primary.ClipSize),0.2) - (self.Recoil or 0.3),math.Rand(-0.2,0.2) * self.Primary.Damage / 30 * math.max((self.ZazhimYaycami / self.Primary.ClipSize),0.2),0))
		end
	end
end

local function rolldrum(ply,wpn)
	if not ply:IsSuperAdmin() then return end
    local wep = type(wpn) == "string" and ply:GetActiveWeapon() or wpn
    
    if not IsValid(ply) or not IsValid(wep) then return end

    wep.tries = math.random(math.max(wep:GetMaxClip1( ) - wep:Clip1(),1))

    if CLIENT then
        net.Start("hg_rolldrum")
        net.WriteEntity(wep)
        net.WriteInt(wep.tries,4)
        net.SendToServer()
    else
        net.Start("hg_rolldrum")
        net.WriteEntity(wep)
        net.WriteInt(wep.tries,4)
        net.Send(ply)
    end
end

function SWEP:RollDrum()
    rolldrum(self:GetOwner(),self)
end

concommand.Add("hg_rolldrum",rolldrum)

concommand.Add("hg_detachmodule", function(ply, len, args)
    local weapon = ply:GetActiveWeapon()

    if not IsValid(weapon) or not weapon.CurrentAtt then
        return
    end

    local searchKey = string.lower(args[1])
    local attachmentIndex = nil
	local attacmintnig

    for index, att in ipairs(weapon.CurrentAtt) do
        if string.lower(att.name) == searchKey then
            attachmentIndex = index
			attacmintnig = att
            break
        end
    end

    if not attachmentIndex then
        return
    end

	if attacmintnig.AmmoExtend then
		weapon.Primary.ClipSize = weapon.Primary.DefaultClip
	end

    table.remove(weapon.CurrentAtt, attachmentIndex)

    PrintTable(weapon.CurrentAtt)
    net.Start("BroadcastAttachments")
    net.WriteEntity(weapon)
    net.WriteTable(weapon.CurrentAtt)
    net.SendToServer()
end)

concommand.Add("hg_attachmodule", function(ply, len, args)
    local weapon = ply:GetActiveWeapon()

    if not IsValid(weapon) or not weapon.PossibleAtt then
        return
    end

    local searchKey = string.lower(args[1])
    local attachment = nil

    for key, att in pairs(weapon.PossibleAtt) do
        if string.lower(key) == searchKey then
            attachment = att
            break
        end
    end

    if not attachment or (weapon.CurrentAtt and table.HasValue(weapon.CurrentAtt, attachment)) then
        return
    end

	if not weapon.CurrentAtt then
		weapon.CurrentAtt = {}
	end

	if #weapon.CurrentAtt > 0 then
    for i = 1,#weapon.CurrentAtt do
		if weapon.CurrentAtt[i].name == attachment.name
		or weapon.CurrentAtt[i].Holo and attachment.Holo
		or weapon.CurrentAtt[i].Optic and attachment.Holo
		or weapon.CurrentAtt[i].Holo and attachment.Optic
		then weapon.CurrentAtt[i] = attachment end--анти даун action
	end
	end

	if attachment.AmmoExtend then
		weapon.Primary.ClipSize = weapon.Primary.DefaultClip + attachment.AmmoExtend
	end

    table.insert(weapon.CurrentAtt, attachment)

    PrintTable(weapon.CurrentAtt)
    net.Start("BroadcastAttachments")
    net.WriteEntity(weapon)
    net.WriteTable(weapon.CurrentAtt)
    net.SendToServer()
end)



if SERVER then
    util.AddNetworkString("hg_rolldrum")

    net.Receive("hg_rolldrum",function(len,ply)
        local wep = net.ReadEntity()

        wep.tries = net.ReadInt(4)
        if wep.shotgun then
			ply:ChatPrint("Buckshot Roulete reference...")
		else
			ply:ChatPrint("Ты прокрутил магазин.")
		end
    end)
else
    net.Receive("hg_rolldrum",function(len)
        local ply = LocalPlayer()

        local wep = net.ReadEntity()
        wep.tries = net.ReadInt(4)
    end)
end

function SWEP:GetHolo()
	if not self.CurrentAtt then return end
	for i = 1,#self.CurrentAtt do
		if self.CurrentAtt[i].Holo then
			return true
		else
		if i == #self.CurrentAtt then
			return false
			end
		end
	end
end

function SWEP:GetSuppressor()
	if not self.CurrentAtt then return end
	for i = 1,#self.CurrentAtt do
		if self.CurrentAtt[i].Suppress then
			return true
		else
		if i == #self.CurrentAtt then
			return false
			end
		end
	end
end

function SWEP:ShootFunc()

	self.ShootNext = self.NextShot or NextShot

	if self.NextShot > CurTime() then return end
	if timer.Exists("reload"..self:EntIndex()) then return end

	local canfire = self:CanFireBullet()
	if self:Clip1() <= 0 or not canfire and self.NextShot < CurTime() then
		if SERVER then
			sound.Play("snd_jack_hmcd_click.wav",self:GetPos(),65,100)
		end
		self.NextShot = CurTime() + self.ShootWait
		self.AmmoChek = 3
		return
	end

	self:PrePrimaryAttack()

	if self.isClose or not self:GetOwner():IsNPC() and self:GetOwner():IsSprinting() then return end

	local ply = self:GetOwner()
	
	if SERVER then
		net.Start("huysound")
		net.WriteVector(self:GetPos())
		net.WriteString(self.Primary.Sound[math.random(#self.Primary.Sound)] or self.Primary.Sound[1])
		net.WriteString(self.Primary.SoundFar)
		net.WriteEntity(self:GetOwner())
		net.Broadcast()
	else
		if CLIENT and self.SlideBone and not self.Delay and not self.Pump then
			self:SlideIn()
		end
		sound.Play(self.Primary.Sound[math.random(#self.Primary.Sound)], self:GetPos(), 75, math.random(90, 120), 1) -- почемуто ломаеца self:EmitSound()
	end

	self.NextShot = CurTime() + self.ShootWait
	
	local dmg = self.Primary.Damage
    self:FireBullet(dmg, 1, 5)
	self:SetNWFloat("VisualRecoil", self:GetNWFloat("VisualRecoil") + self.Primary.Force/90)

	if SERVER and not ply:IsNPC() then
		if ply.RightArm < 1 then
			ply.pain = ply.pain + self.Primary.Damage / 30 * (self.NumBullet or 1)
		end

		if ply.LeftArm < 1 and self.TwoHands then
			ply.pain = ply.pain + self.Primary.Damage / 30 * (self.NumBullet or 1)
		end
	end

	if CLIENT and ply == LocalPlayer() then
		self.ZazhimYaycami = math.min(self.ZazhimYaycami + 1,self.Primary.ClipSize)
	end
	
	if CLIENT and (self:GetOwner() != LocalPlayer()) then
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	end
	
	self.lastShoot = CurTime()
	self:SetNWFloat("LastShoot",CurTime())

	if CLIENT and ply == LocalPlayer() then
		self.eyeSpray = self.eyeSpray or Angle(0,0,0)

		local func = self.ApplyEyeSpray
		if func then
			func(self)
		else
			self.eyeSpray:Add(Angle(math.Rand(-0.9,0.5) * self.Primary.Damage / 30 * math.max((self.ZazhimYaycami / self.Primary.ClipSize),0.2),math.Rand(-0.5,0.5) * self.Primary.Damage / 30 * math.max((self.ZazhimYaycami / self.Primary.ClipSize),0.2),0))
		end
	end
end

function GetReloadDelay(holdtype)
	if holdtype == "ar2" then
		return ar2	
	elseif holdtype == "smg" then
		return smg
	elseif holdtype == "revolver" then
		return revolver
	elseif holdtype == "pistol" then
		return pistol
	elseif holdtype == "rpg" then
		return rpg
	end
end

function SWEP:EmitReload()
	local reloaddelay = GetReloadDelay(self:GetHoldType())
	timer.Simple(reloaddelay[1],function()
		self:EmitSound(self.Reload1)
	end)
	timer.Simple(reloaddelay[2],function()
		self:EmitSound(self.Reload2)
	end)
	if self:Clip1() <= 0 or self.ReloadEmpty then
	timer.Simple(reloaddelay[3],function()
		self:EmitSound(self.Reload3)
		if CLIENT and self.SlideBone and not self.Delay then
			self:SlideOutSlow()
		end
	end)
	timer.Simple(reloaddelay[4],function()
		self:EmitSound(self.Reload4)
		if CLIENT and self.SlideBone and not self.Delay then
			self:SlideIn()
		end
	end)
	end
end




function SWEP:GetPosAng()
	if !self.UsingVM then return end
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

function SWEP:Reload()
	if self.Bolt and self.Bolted == false then
		if CLIENT then
			if self.Bolting then return end
			self.Bolting = true

			self:BoltProgress()

			timer.Simple(1,function()
			self.Bolted = true
			self.Bolting = false
			end)
		else
			if self.Bolting then return end
			self.Bolting = true
			sound.Play("zcitysnd/sound/weapons/mosin/handling/mosin_boltrelease.wav",self:GetPos())
			timer.Simple(0.1,function()
				sound.Play("zcitysnd/sound/weapons/mosin/handling/mosin_boltback.wav",self:GetPos())
				timer.Simple(0.3,function()
					sound.Play("zcitysnd/sound/weapons/mosin/handling/mosin_boltforward.wav",self:GetPos())
					timer.Simple(0.3,function()
						sound.Play("zcitysnd/sound/weapons/mosin/handling/mosin_boltlatch.wav",self:GetPos())
					end)
				end)
			end)
			timer.Simple(1,function()
			self.Bolted = true
			self.Bolting = false
			end)
		end
	end
    if !self:GetOwner():KeyDown(IN_WALK) then
        local a = true
        self.AmmoChek = 3
		if self.Pumping and self.Pump or !self.Pumped and self.Pump or self.Delayed and self.Pump then return end
		if self.Bolt and self.Bolting then return end
        if timer.Exists("reload"..self:EntIndex()) or self:Clip1() >= self:GetMaxClip1() or self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 then return nil end
        if self:GetOwner():IsSprinting() then return nil end
        if self.NextShot > CurTime() then return end
        self:GetOwner():SetAnimation(PLAYER_RELOAD)
        self:EmitReload()
        self:GetOwner():SetNWFloat("PosaVistrela", 1)
		if CLIENT and self.Breaking then
			if self:Clip1() == 0 then
			net.Start("ShellThing")
			net.WriteEntity(self:GetOwner())
			net.WriteEntity(self)
			net.SendToServer()

			net.Start("ShellThing")
			net.WriteEntity(self:GetOwner())
			net.WriteEntity(self)
			net.SendToServer()
			else
			net.Start("ShellThing")
			net.WriteEntity(self:GetOwner())
			net.WriteEntity(self)
			net.SendToServer()

			net.Start("ShellThing")
			net.WriteEntity(self:GetOwner())
			net.WriteEntity(self)
			net.SendToServer()
			end
		elseif SERVER and self.Breaking then
			self.ShellType = "ShotGunBreaking"

			timer.Simple(0.2,function()
				self.ShellType = nil
			end)
		end
		self.Reloading = true
        timer.Create("reload"..self:EntIndex(), self.ReloadTime, 1, function()
            if IsValid(self) and IsValid(self:GetOwner()) and self:GetOwner():GetActiveWeapon() == self then
                local oldclip = self:Clip1()
				self.Reloading = false
                self:SetClip1(math.Clamp(self:Clip1() + self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()), 0, self:GetMaxClip1()))
                local needed = self:Clip1() - oldclip
                self:GetOwner():SetAmmo(self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) - needed, self:GetPrimaryAmmoType())
                self.AmmoChek = 5
				if CLIENT then
					if self:GetClass() == "weapon_rpg7" then
						self.ClientModel:SetBodygroup(1,0)
					end
				end
            end
        end)
    else
        self.AmmoChek = 5
    end
end

SWEP.addPos = Vector(0,0,0)
SWEP.addAng = Angle(0,0,0)

if SERVER then
	util.AddNetworkString("shoot_huy")
else
	net.Receive("shoot_huy", function(len)
		local tr = net.ReadTable()
		local dist, vec, dist2 = util.DistanceToLine(tr.StartPos, tr.HitPos, EyePos())
		if dist < 128 and dist2 > 128 then EmitSound("snd_jack_hmcd_bc_" .. tostring(math.random(1, 7)) .. ".wav", vec, 1, CHAN_WEAPON, 1, 75, 0, 100) end
	end)
end

function SWEP:FireBullet(dmg, numbul, spread)
	if self:Clip1() <= 0 then return end
	if timer.Exists("reload"..self:EntIndex()) then return nil end
	
	local ply = self:GetOwner()

	self.Shooting = true

	self.LerpingRecoil = true

	self.Lerping = true

	self.DelayY = CurTime() + 0.1

	self.DelaY = CurTime() + 0.8

	ply:LagCompensation(true)

	if CLIENT then
		net.Start("ShellThing")
		net.WriteEntity(ply)
		net.WriteEntity(self)
		net.SendToServer()
	end
	
	local wep = self
	local attac = wep:GetOwner():LookupAttachment('anim_attachment_rh')
	local att = wep:GetOwner():GetAttachment(attac)
	
	if not att then
		local Pos,Ang = self:GetPosAng()
		att = {Pos = Pos,Ang = Ang}
	end

	if not att then
		local Pos,Ang = wep:GetPosAng()
		att = {Pos = Pos,Ang = Ang}
	end
	local shootOrigin = att.Pos
	local vec = vecZero
	vec:Set(wep.addPos)
	vec:Rotate(att.Ang)
	shootOrigin:Add(vec)

	local shootAngles = att.Ang
	local ang = angZero
	ang:Set(wep.addAng)
	shootAngles:Add(ang)

	
	local cone = self.Primary.Cone

	local shootOriginFX = att.Pos
	local vecFX = vecZero
	vecFX:Set(self.MuzzleFXPos)
	vecFX:Rotate(att.Ang)
	shootOriginFX:Add(vecFX)

	local shootDir = shootAngles:Forward()

	local npc = ply:IsNPC() and ply:GetShootPos() or shootOrigin
	local npcdir = ply:IsNPC() and ply:GetAimVector() or shootDir
	local bullet = {}
	bullet.Num 			= self.NumBullet or 1
	bullet.Src 			= npc
	bullet.Dir 			= npcdir
	bullet.Spread 		= Vector(cone,cone,0)
	bullet.Force		= self.Primary.Force / 40
	bullet.Damage		= self.Primary.Damage * 4
	bullet.AmmoType     = self.Primary.Ammo
	bullet.Attacker 	= self:GetOwner()
	bullet.Tracer       = 1
	bullet.TracerName   = self.Tracer or "Tracer"
	bullet.IgnoreEntity = not self:GetOwner():IsNPC() and self:GetOwner():GetVehicle() or self:GetOwner()

	if self.Pump then
		self.Pumped = false
	end

	timer.Simple(0.02,function()
		self.Shooting = false	
	end)

	bullet.Callback = function(ply,tr,dmgInfo)
		ply:GetActiveWeapon():BulletCallbackFunc(self.Primary.Damage,ply,tr,self.Primary.Damage,false,true,false)

		if self.Primary.Ammo == "buckshot" then
			local k = math.max(1 - tr.StartPos:Distance(tr.HitPos) / 750,0)

			dmgInfo:ScaleDamage(k)
		end
		
		local effectdata = EffectData()
		effectdata:SetEntity(tr.Entity)
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetStart(tr.StartPos)

		effectdata:SetSurfaceProp(tr.SurfaceProps)
		effectdata:SetDamageType(DMG_BULLET)
		effectdata:SetHitBox(tr.HitBox)

		util.Effect("Impact",effectdata,true,true)
		net.Start("shoot_huy")
		net.WriteTable(tr)
		net.Broadcast()
	end

	if SERVER then self:TakePrimaryAmmo(1) end

	if ply:GetNWBool("Suiciding") then
		if SERVER then
			ply.KillReason = "killyourself"
			ply.LastDMGInfo = dmgInfo
			ply.LastHitBoneName = "ValveBiped.Bip01_Head1"
			ply:DropWeapon1()
			local dmgInfo = DamageInfo()
			dmgInfo:SetAttacker(ply)
			dmgInfo:SetInflictor(self)
			dmgInfo:SetDamage(bullet.Damage * 4 * (self.NumBullet or 1))
			dmgInfo:SetDamageType(DMG_BULLET)
			dmgInfo:SetDamageForce(shootDir * 1024)
			dmgInfo:SetDamagePosition(ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1")))
			ply.LastDMGInfo = dmgInfo
			ply.LastHitBoneName = "ValveBiped.Bip01_Head1"
			ply:TakeDamageInfo(dmgInfo)
			
		end
	elseif not self:GetOwner():IsNPC() then
		if SERVER then
			self:GetOwner():FireBullets(bullet)
		end
		self:SetLastShootTime()
	else
		self:FireBullets(bullet)
	end

	ply:LagCompensation(false)

	if GetConVar("hg_noeffects_muzzle"):GetBool() == false then
		local effectdata = EffectData()
		effectdata:SetOrigin(shootOriginFX)
		effectdata:SetAngles(shootAngles)
		effectdata:SetScale(self:IsScope() and 0.1 or 1)
		effectdata:SetNormal(shootDir)
		local hassupp = self:GetSuppressor()
		if hassupp then return end
		if self.Efect then
			util.Effect(self.Efect,effectdata)
		else
			if GetConVar("hg_default_muzzle"):GetBool() == true then
				util.Effect("MuzzleEffect", effectdata)
			elseif GetConVar("hg_default_muzzle"):GetBool() == false then
				if self.NumBullet then
					ParticleEffect("AC_explosive_round",shootOriginFX,shootAngles)
					ParticleEffect("AC_muzzle_shotgun",shootOriginFX,shootAngles)
					ParticleEffect("AC_explosive_round",shootOriginFX,shootAngles)
					ParticleEffect("AC_muzzle_shotgun",shootOriginFX,shootAngles)
				else
					ParticleEffect("AC_muzzle_pistol",shootOriginFX,shootAngles)
				end
			end
		end
	end
end

local mul = 1
local FrameTime,TickInterval = FrameTime,engine.TickInterval

hook.Add("Think","Mul lerpB3BASE",function()
	mul = FrameTime() / TickInterval()
end)

local Lerp,LerpVector,LerpAngle = Lerp,LerpVector,LerpAngle
local math_min = math.min

function LerpFT(lerp,source,set)
	return Lerp(math_min(lerp * mul,8),source,set)
end

function LerpVectorFT(lerp,source,set)
	return LerpVector(math_min(lerp * mul,8),source,set)
end

function LerpAngleFT(lerp,source,set)
	return LerpAngle(math_min(lerp * mul,8),source,set)
end

local pairs,IsValid = pairs,IsValid

local function GetHolo(num, info)
    if num > 1 then
        for i = 1, num do
            if info[i] and info[i].Holo then
                return i
            end
        end
    else
        if info[1] and info[1].Holo then
            return 1
        end
    end
    return nil
end

hook.Add("Think","weapons-b3bros_base",function()
	for wep in pairs(hg_weps) do
		if not IsValid(wep) then hg_weps[wep] = nil continue end

		local owner = wep:GetOwner()
		if not IsValid(owner) or (owner:IsPlayer() and not owner:Alive()) or owner:GetActiveWeapon() ~= wep then continue end--wtf i dont know

		if wep.Step then wep:Step() end
	end
end)

function GetSight(num, info)
    if num > 1 then
        for i = 1, num do
            if info[i] and info[i].Optic then
                return i
            end
        end
    else
        if info[1] and info[1].Optic then
            return 1
        end
    end
    return nil
end

function SWEP:Think()
	local ply = self:GetOwner()

	if self.CustomThink then
		self:CustomThink()
	end

	if CLIENT then
		if self.CurrentAtt then
			if GetSight(#self.CurrentAtt,self.CurrentAtt) != nil then
				self:DoRT()
			end
		end
	end

		if self:IsScope() then
			self.LerpaNeck = LerpAngleFT(0.1,self.LerpaNeck,Angle(-10,-20,20))
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Neck1"),self.LerpaNeck,false)
		else
			self.LerpaNeck = LerpAngleFT(0.1,self.LerpaNeck,Angle(0,0,0))
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Neck1"),self.LerpaNeck,false)
		end
	
	if CLIENT then
		local function GetSight(num, info)
			if num > 1 then
				for i = 1, num do
					if info[i] and info[i].Optic then
						return i
					end
				end
			else
				if info[1] and info[1].Optic then
					return 1
				end
			end
			return nil
		end
		if self:GetClass() == "weapon_rpg7" and self:Clip1() == 0 then
			self.ClientModel:SetBodygroup(1,1)
		elseif self:GetClass() == "weapon_rpg7" and self:Clip1() > 0 then
			self.ClientModel:SetBodygroup(1,0)
		end
	end

	if not self.Delay then return end

	local lerpSpeed = 0.25
	local LerpEnd = 0
	

	if ply:KeyDown(IN_ATTACK) then
		if not self.Shooted then
			LerpEnd = 1
		else
			LerpEnd = 0
		end
		
		if not self.SoundPlayed then
			self.SoundPlayed = true
			sound.Play(self.HammerSound,self:GetPos(),75,100,1,0)
		end
	else
		LerpEnd = 0
		self.SoundPlayed = false
		self.Shooted = false
	end

	self.Delay = LerpFT(lerpSpeed, self.Delay, LerpEnd)
	self:SetNWFloat("Delay", math.Round(self.Delay,2))

	if math.abs(self.Delay) < 0.01 then
		self.Delay = 0
	end

	if self.Delay >= 0.98 and not self.Shooted and CLIENT then
		self.Delay = 0
		self.Shooted = true
		self:ShootFunc()
		net.Start("SyncDelay")
		net.WriteEntity(self)
		net.WriteFloat(self.Delay)
		net.SendToServer()
	end
end

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

if SERVER then
	concommand.Add("suicide",function(ply)
		if not ply:Alive() then return end
		ply.suiciding = not ply.suiciding
		ply:SetNWBool("Suiciding",ply.suiciding)
	end)
end

hook.Add("PlayerDeath","suciding",function(ply)
	ply.suiciding = false
	ply:SetNWBool("Suiciding",false)
	ply.suicidingknife = false
	ply:SetNWBool("Suicidingknife",false)
end)

local util_QuickTrace = util.QuickTrace
local math_Clamp = math.Clamp
local closeAng = Angle(0,0,0)

local angZero = Angle(0,0,0)
local angSuicide = Angle(160,30,90)
local angSuicide2 = Angle(160,30,90)
local angSuicide3 = Angle(60,-30,90)

function SWEP:OnRemove()
    local hookNameWorldModel = "DrawSWEPWorldModel_" .. self:EntIndex()
    hook.Remove("PostDrawOpaqueRenderables", hookNameWorldModel)

    timer.Remove("BoneSlideIn_" .. self:EntIndex())
    timer.Remove("BoneSlideRotate_" .. self:EntIndex())

    if IsValid(self.ClientModel) then
        self.ClientModel:Remove()
        self.ClientModel = nil
    end
end


function SWEP:Step()
	local ply = self:GetOwner()
	local isLocal = self:IsLocal()	
	if not IsValid(ply) or ply:IsNPC() or IsValid(ply:GetNWEntity("Ragdoll")) then return end
	self.animProg = self:GetNWFloat("VisualRecoil") or 0
	self.animLerp = self.animLerp or Angle(0, 0, 0)
	self.animLerp = LerpAngleFT(0.25, self.animLerp, Angle(5, 0, self.HoldType == "revolver" and 0 or -2) * self.animProg)

	--[[ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_Head1"),1) --режим алкаша
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_Spine"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_Spine2"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_Spine4"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_Pelvis"),1)

	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_L_Thigh"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_R_Thigh"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_R_Calf"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_L_Calf"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_R_Foot"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_L_Foot"),1)

	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_L_Hand"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_R_Hand"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_L_ForeArm"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_R_ForeArm"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),1)
	ply:ManipulateBoneJiggle(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),1)]]

	if self.DelayY and self.DelayY < CurTime() then
		self.LerpingRecoil = false	
	end

	if self.DelaY and self.DelaY < CurTime() then
		self.Lerping = false
	end
	
	if ply:KeyDown(IN_ATTACK) then
		if not self.LerpPalchik then
			self.LerpPalchik = Angle(0,0,0)
		end

		self.LerpPalchik = LerpAngleFT(0.4,self.LerpPalchik,Angle(0,-30,0))

        ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger1"),self.LerpPalchik)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger11"),self.LerpPalchik)
	else
		if not self.LerpPalchik then
			self.LerpPalchik = Angle(0,0,0)
		end

		self.LerpPalchik = LerpAngleFT(0.1,self.LerpPalchik,Angle(0,0,0))

        ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger1"),self.LerpPalchik)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger11"),self.LerpPalchik)
    end

	if CLIENT and self.Pump and self.shotgun and !self.Pumped and !self.Delayed then
		if not self.Pump then return end
		if ply.PumpProg == nil then
			ply.PumpProg = 0
		end
	
		if ply:KeyDown(IN_RELOAD) and not ply:KeyDown(IN_ATTACK) then
			lerpa = 1
		else
			lerpa = 0
		end
	
		local pizdec = LerpFT(0.2, ply.PumpProg, lerpa)
		ply.PumpProg = math.Round(pizdec, 2)
	
		if math.abs(ply.PumpProg) < 0.01 then
			ply.PumpProg = 0
		end
	
		if ply.PumpProg >= 0.9 and !self.Pumping then
			self.Pumping = true
			ply.PumpProg = nil
			self.Delayed = true
			net.Start("PumpSync")
			net.WriteEntity(self)
			net.WriteBool(self.Pumping)
			net.WriteBool(self.Pumped)
			net.SendToServer()
			self:SlideOutSlow()
			net.Start("PumpVFX")
			net.WriteEntity(ply)
			net.SendToServer()
			--self:EmitSound("zcitysnd/sound/weapons/ak47/handling/ak47_boltback.wav")
			timer.Simple(0.1,function()
			--self:EmitSound("zcitysnd/sound/weapons/ak47/handling/ak47_boltrelease.wav")
			self:SlideIn()
			self.Pumping = false
			self.Pumped = true
			net.Start("PumpSync")
			net.WriteEntity(self)
			net.WriteBool(self.Pumping)
			net.WriteBool(self.Pumped)
			net.WriteBool(self.Delayed)
			net.SendToServer()
			timer.Simple(0.5,function()
			self.Delayed = false
			net.Start("PumpSync")
			net.WriteEntity(self)
			net.WriteBool(self.Pumping)
			net.WriteBool(self.Pumped)
			net.WriteBool(self.Delayed)
			net.SendToServer()
			end)
			end)
		end
	end
	
	local ply = self:GetOwner()

	if self.Pump and not self.Lerp1 then
		self.Lerp1 = Angle(0,0,0)
	end

	if self.Pump and not ply:GetNWBool("Suiciding") then
	if self.Pumping then
		local Lerpp = Angle(-10,0,-40)
		if CLIENT then
		self.Lerp1 = LerpAngleFT(0.3,self.Lerp1,Lerpp)
		else
		self.Lerp1 = LerpAngleFT(0.3,self.Lerp1,Lerpp)
		end
	else
		local Lerpp = Angle(0,0,0)
		if CLIENT then
		self.Lerp1 = LerpAngleFT(0.3,self.Lerp1,Lerpp)
		else
		self.Lerp1 = LerpAngleFT(0.3,self.Lerp1,Lerpp)
		end
	end
	self.FA = self.Lerp1
	end

	if CLIENT and IsValid(self:GetOwner()) and self.UsingVM then
		if self:Clip1() <= 0 and self.EmptyBoltOut == true and not self.aasdadasdasd then
			self:SlideOutEmpty()
			self.aasdadasdasd = 1
		end
		if self:Clip1() <= 0 and self.EmptyBoltOut == true then
			if timer.Exists("reload"..self:EntIndex()) then
				timer.Simple(self.ReloadTime + 0.2,function()
				self.aasdadasdasd = nil
				end)
			end
		end
		--self:CreateClientsideModel()
	
	elseif CLIENT and not IsValid(self:GetOwner()) and self.UsingVM then
		hook.Remove("PostDrawOpaqueRenderables", "DrawSWEPWorldModel_" .. self:EntIndex())
	end

	if isLocal then
		self.eyeSpray = self.eyeSpray or Angle(0,0,0)
		
		ply:SetEyeAngles(ply:EyeAngles() + self.eyeSpray)
		
		self.eyeSpray = LerpAngleFT(0.5,self.eyeSpray,Angle(0,0,0))

		if not ply:KeyDown(IN_ATTACK) then
			self.ZazhimYaycami = math.max((self.ZazhimYaycami or 0) - 3,0)
		end
	end

	if SERVER then
		ply:SetNWInt("RightArm",ply.RightArm)
		ply:SetNWInt("LeftArm",ply.LeftArm)
	end

	local t = {}

	if not self.TwoHands then
		t.start = ply:GetShootPos() + ply:GetAngles():Right()*2.5
	else
		t.start = ply:GetShootPos() + ply:GetAngles():Right()*7
	end

	t.endpos = t.start + Angle(0,ply:GetAngles().y,ply:GetAngles().z):Forward() * 100
	t.filter = player.GetAll(),ply:GetNWEntity("Armor")
	local tr = util.TraceLine(t)
	self.dist = (tr.HitPos - t.start):Length()

	if not ply:IsSprinting() then
		local scope = self:IsScope()
		if SERVER then self:SetNWBool("IsScope",scope) end

		if isLocal then
			if (ply:GetNWInt("LeftArm") < 1 or ply:GetNWInt("RightArm") < 1) then
				local p = 0.3 - math.min((painlosing or 0),0.3)
				self.eyeSpray = self.eyeSpray + Angle(math.Rand(-p,p),math.Rand(-p,p),math.Rand(-p,p))
			end
		end

		if isLocal or SERVER then
			local head = ply:LookupBone("ValveBiped.Bip01_L_Hand")

			if head then
				local pos,ang = ply:GetBonePosition(head)
				pos[3] = pos[3] + 5
				ang:RotateAroundAxis(ang:Up(),-90)

				local dir = ang:Forward() * 1000
				local tr = util_QuickTrace(pos,dir,ply)
				local dist = pos:DistToSqr(tr.HitPos)

				self.isClose = self.dist <= 35 and not self:IsReloaded()
				
				if SERVER then self:SetNWBool("isClose",self.isClose) end
			end
		else
			self.isClose = self:GetNWBool("isClose")
		end
		if not self.isClose and not ply:IsSprinting() then
			if not ply:GetNWBool("Suiciding") then
				self:SetWeaponHoldType(self.HoldType)
				if not self.Pumping then
				if self.HoldType == "revolver" then
				self.FA  = LerpAngleFT(0.05,self.FA,Angle(30,-70,0))
				else
				self.FA  = LerpAngleFT(0.05,self.FA,angZero)	
				end
				end
				if self.HoldType == "revolver" and not ply:GetNWBool("Suiciding") then
				if ply:GetVelocity():Length() < 60 then
					if ply:Crouching() then
						self.HA  = LerpAngleFT(0.5,self.HA,Angle(30,56,-20))
						self.CL  = LerpAngleFT(0.5,self.CL,Angle(0,40,-40))
						self.HL  = LerpAngleFT(0.5,self.HL,angZero)
						self.CLAVL = LerpAngleFT(0.5,self.CLAVL,angZero)
						self.CLAV = LerpAngleFT(0.5,self.CLAV,Angle(30,-0,0))
					else 
						self.HA  = LerpAngleFT(0.5,self.HA,Angle(5,40,-10))
						self.CL  = LerpAngleFT(0.5,self.CL,Angle(0,30,-40))
						self.HL  = LerpAngleFT(0.5,self.HL,angZero)
						self.CLAVL = LerpAngleFT(0.5,self.CLAVL,angZero)
						self.CLAV = LerpAngleFT(0.32,self.CLAV,Angle(-5,0,-5))
					end
				elseif ply:GetVelocity():Length() > 60 then
					if ply:Crouching() then
						self.HA  = LerpAngleFT(0.38,self.HA,Angle(30,56,-20))
						self.CL  = LerpAngleFT(0.35,self.CL,Angle(0,40,-40))
						self.HL  = LerpAngleFT(0.35,self.HL,angZero)
						self.CLAVL = LerpAngleFT(0.35,self.CLAVL,angZero)
						self.CLAV = LerpAngleFT(0.3,self.CLAV,Angle(30,0,0))
					else 
						self.HA  = LerpAngleFT(0.35,self.HA,Angle(0,55,0))
						self.CL  = LerpAngleFT(0.35,self.CL,Angle(20,30,-40))
						self.HL  = LerpAngleFT(0.35,self.HL,angZero)
						self.CLAVL = LerpAngleFT(0.35,self.CLAVL,angZero)
						self.CLAV = LerpAngleFT(0.12,self.CLAV,Angle(7,0,-5))
					end
				end
				else
				if self.HoldType == "ar2" and not ply:GetNWBool("Suiciding") or self.HoldType == "smg" and not ply:GetNWBool("Suiciding") then
				self.HA  = LerpAngleFT(0.35,self.HA,Angle(15,5,-35))
				self.CL  = LerpAngleFT(0.35,self.CL,Angle(-10,-20,12))
				self.FL  = LerpAngleFT(0.35,self.FL,Angle(0,0,0))
				self.HL  = LerpAngleFT(0.35,self.HL,Angle(0,0,0))
				self.CLL = LerpAngleFT(0.35,self.CLL,Angle(0,0,0))
				self.CLAVL = LerpAngleFT(0.35,self.CLAVL,Angle(0,0,0))
				self.CLAV = LerpAngleFT(0.32,self.CLAV,Angle(0,0,-30))
				self.HA  = LerpAngleFT(0.35,self.HA,Angle(15,5,-35))
				self.CL  = LerpAngleFT(0.35,self.CL,Angle(-10,-20,12))
				self.FL  = LerpAngleFT(0.35,self.FL,Angle(0,0,0))
				self.HL  = LerpAngleFT(0.35,self.HL,Angle(0,0,0))
				self.CLL = LerpAngleFT(0.35,self.CLL,Angle(0,0,0))
				self.CLAVL = LerpAngleFT(0.35,self.CLAVL,Angle(0,0,0))
				self.CLAV = LerpAngleFT(0.32,self.CLAV,Angle(0,0,-30))
				else
				if not ply:GetNWBool("Suiciding") then
				self.HA  = LerpAngleFT(0.35,self.HA,angZero)
				self.CL  = LerpAngleFT(0.35,self.CL,angZero)
				self.FL  = LerpAngleFT(0.35,self.FL,angZero)
				self.HL  = LerpAngleFT(0.35,self.HL,angZero)
				self.CLL = LerpAngleFT(0.35,self.CLL,angZero)
				self.CLAVL = LerpAngleFT(0.35,self.CLAVL,angZero)
				self.CLAV = LerpAngleFT(0.32,self.CLAV,angZero)
				end
				end
				end
			elseif not self.TwoHands and ply:GetNWBool("Suiciding") then
				self:SetWeaponHoldType("normal")
				self.FA  = LerpAngleFT(0.1,self.FA,Angle(-15,-100,40))
				self.HA  = LerpAngleFT(0.1,self.HA,Angle(45,-35,-70))
				self.CL  = angZero
				self.FL  = angZero
				self.HL  = angZero
				self.CLL = angZero
				self.CLAVL = angZero
				self.CLAV = angZero
			elseif ply:GetNWBool("Suiciding") then
				self:SetWeaponHoldType("normal")
				self.FA  = LerpAngleFT(0.11,self.FA ,Angle(0,-60,30))
				self.HA  = LerpAngleFT(0.11,self.HA ,Angle(40,-105,-80))
				self.CL  = LerpAngleFT(0.11,self.CL ,Angle(0,0,0))
				self.FL  = LerpAngleFT(0.11,self.FL ,Angle(20,-100,0))
				self.HL  = LerpAngleFT(0.11,self.HL ,Angle(0,-50,0))
				self.CLL = LerpAngleFT(0.11,self.CLL,Angle(0,-40,0))
				self.CLAVL = angZero
				self.CLAV = angZero
			end
		end
	else
		self.isClose = true 
	end

	self.lerpClose = LerpFT(0.15, self.lerpClose, (self.isClose and 1) or 0)

	if self.HoldType == "ar2" or self.HoldType == "smg" or self.HoldType == "rpg" and not ply:GetNWBool("Suiciding") then
	self.CloseCl = Angle(0,0,0) * self.lerpClose
	self.CloseCl2 = Angle(0,30,-20) * self.lerpClose
	self.CloseCl3 = Angle(0,-50,0) * self.lerpClose
	else
	if not ply:GetNWBool("Suiciding") then
	self:SetHoldType("revolver")
	if ply:GetVelocity():Length() < 160 then
	self.Cal = LerpAngleFT(0.1,self.Cal,Angle(0,0,0))
	self.CloseCl = self.Cal * self.lerpClose
	self.CloseCl2 = Angle(-10,0,0) * self.lerpClose
	self.CloseCl3 = Angle(40,0,-10) * self.lerpClose	
	else
	self.Cal = LerpAngleFT(0.5,self.Cal,Angle(-20,20,0))
	self.CloseCl = self.Cal * self.lerpClose
	self.CloseCl2 = Angle(-10,0,0) * self.lerpClose
	self.CloseCl3 = Angle(40,0,-10) * self.lerpClose	
	end
end	
	end
	
	if not ply:LookupBone("ValveBiped.Bip01_R_Forearm") then return end
	if ply:GetNWBool("Suiciding") then 
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"),self.FL,true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"),self.HL,true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"),self.CLL,true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),self.CLAVL)
	
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"),self.FA,true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),self.CLAV)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"),self.CL,true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"),self.HA,true)
	end	
	if ply:GetNWFloat("PosaVistrela") == 1 and not ply:GetNWBool("Suiciding")then
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"),self.FL,true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"),self.HL,true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"),self.CLL,true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),self.CLAVL)
	
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"),self.FA + self.CloseCl,true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),self.CLAV)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"),self.CL + self.CloseCl2,true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"),self.HA + self.CloseCl3,true)	
	end
end

function SWEP:Holster( wep )
	local ply = self:GetOwner()

	if self.ACHO then
		self.ACHO = nil
	end
		if wep.UsingVM then
				local hookName = "DrawSWEPWorldModel_" .. self:EntIndex()
				hook.Remove("PostDrawOpaqueRenderables", hookName)
				if IsValid(self.ClientModel) then
					self.ClientModel:Remove()
					self.ClientModel = nil
				end	
		end
	if SERVER then
		self:GetOwner():EmitSound("homigrad/player/holster"..math.random(1,3)..".wav", 65,(self.TwoHands and 100) or (!self.TwoHands and 110), 1, CHAN_AUTO)
	end

	if not IsValid(ply) or not ply:LookupBone("ValveBiped.Bip01_R_Forearm") then return end
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Hand" ), Angle( 0,0,0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Forearm" ), Angle( 0,0,0 ))
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_UpperArm" ),Angle( 0,0,0 ))
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Hand" ), Angle( 0,0,0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Forearm" ), Angle( 0,0,0 ))
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_UpperArm" ),Angle( 0,0,0 ))

	return true
end

hook.Add("PlayerDeath","weapons",function(ply)
	ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"),angZero,true)
	ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"),angZero,true)
	ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"),angZero,true)
	ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"),angZero,true)
	ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"),angZero,true)
	ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"),angZero,true)
end)

function SWEP:SecondaryAttack() return end

function SWEP:Deploy()
	self:SetHoldType("normal")

	self:EmitSound(self.DeploySound)

	if SERVER then
		self:GetOwner():EmitSound("homigrad/player/deploy"..math.random(1,3)..".wav", 65,(self.TwoHands and 100) or (!self.TwoHands and 110), 1, CHAN_AUTO)
	end
	self.NextShot = CurTime() + 0.5
	if self.HoldType != "pistol" and self.HoldType != "revolver" then
		self:GetOwner():SetNWFloat("PosaVistrela",1)
	end
	self:SetHoldType(self.HoldType)
end
function SWEP:ShouldDropOnDie()
	return true
end
if SERVER then
	util.AddNetworkString("RifleShellVFX")
	util.AddNetworkString("ShellThing")

	net.Receive("ShellThing", function(l,ply)
		local wep = net.ReadEntity()
		if not ply:GetActiveWeapon().Shooting then return end
	
		if not IsValid(ply) or not ply:IsPlayer() then
			return
		end
	
		local shellEffectMap = {
			["Pistol"] = "ShellEject",
			["ShotGun"] = "ShotgunShellEject",
			["ShotGunBreaking"] = "ShotgunShellEject",
			["Rifle"] = "RifleShellEject"
		}
	
		local shellEffect = shellEffectMap[wep.ShellType]
		if shellEffect then
			local boneIndex = ply:LookupAttachment("anim_attachment_rh")
			if not boneIndex then
				return
			end
	
			local attachment = ply:GetAttachment(boneIndex)
			if not attachment then
				return
			end
	
			local bonePos, boneAng = attachment.Pos, attachment.Ang
			if not bonePos or not boneAng then
				return
			end
			
			if wep.ShellType == "Pistol" then
				local offset = boneAng:Forward() * 5 + boneAng:Right() * 2 + boneAng:Up() * 3
				local effectPos = bonePos + offset
				local effectdata = EffectData()
				effectdata:SetOrigin(effectPos)
				effectdata:SetAngles(boneAng + Angle(-40, -90, 180))
				effectdata:SetScale(0.1)
				util.Effect(shellEffect, effectdata)
			elseif wep.ShellType == "Rifle" then
				local offset = boneAng:Forward() * 5 + boneAng:Right() * 3 + boneAng:Up() * 3
				local effectPos = bonePos + offset
				local effectdata = EffectData()
				effectdata:SetOrigin(effectPos)
				effectdata:SetAngles(boneAng + Angle(0, -90, 180))
				effectdata:SetScale(0.1)
				util.Effect(shellEffect, effectdata)
			elseif wep.ShellType == "ShotGun" then
				local offset = boneAng:Forward() * 9 + boneAng:Right() * 3 + boneAng:Up() * 3
				local effectPos = bonePos + offset
				local effectdata = EffectData()
				effectdata:SetOrigin(effectPos)
				effectdata:SetAngles(boneAng + Angle(0, -90, 180))
				effectdata:SetScale(0.1)
				util.Effect(shellEffect, effectdata)
			elseif wep.ShellType == "ShotGunBreaking" then
				local offset = boneAng:Forward() * 9 + boneAng:Right() * 3 + boneAng:Up() * 3
				local effectPos = bonePos + offset
				local effectdata = EffectData()
				effectdata:SetOrigin(effectPos)
				effectdata:SetAngles(boneAng + Angle(-50, 180, 0))
				effectdata:SetScale(0.1)
				util.Effect(shellEffect, effectdata)
			end
		end
	end)
	
	
	util.AddNetworkString("PumpVFX")
	
	net.Receive("PumpVFX",function (len,ply)
			if not ply:Alive() then return end
			if not weapons.Get(ply:GetActiveWeapon():GetClass()).Pump then
			ply:ChatPrint('чечовирус октивирован ыы')
			ply.informedaboutneuro = true
			ply.ISEXPLOITERHAHA = true
			ply:Say("я сын тайской шлюхи,я не знаю кто мой биологический отец [ANTI-EXPLOIT SYSTEM]")
			--ply:Kick("пасасал? - "..ply:IPAddress())
			logToDiscord("Обнаружен ЭКСПЛОИТЕР - "..ply:SteamID(), "Info","<@872402247143784499> <@&1275416491612831867> ", "https://discord.com/api/webhooks/1317029306173751317/lh-jQsqbPCymQ8U8uVVAQBdM2QisbqgiygPD_5unuF0N14runio6yyF0dvyylJxv2osm")
			return
			end -- а вот это уже заявочка..
			if not ply:GetActiveWeapon().Pumped == false then return end
			if not ply:Alive() then return end
			sound.Play("zcitysnd/sound/weapons/ak47/handling/ak47_boltback.wav",ply:GetActiveWeapon():GetPos())
		timer.Simple(0.2,function()
			sound.Play("zcitysnd/sound/weapons/ak47/handling/ak47_boltrelease.wav",ply:GetActiveWeapon():GetPos())
		end)
	
		local boneIndex = ply:LookupBone("ValveBiped.Bip01_R_Hand")
		if boneIndex then
			local bonePos, boneAng = ply:GetBonePosition(boneIndex)
	
			local effectdata = EffectData()
			effectdata:SetOrigin(bonePos)
			effectdata:SetAngles(boneAng + Angle(0,-40,0))
			util.Effect("ShotgunShellEject", effectdata)
		end
	end)
	
	net.Receive("RifleShellVFX",function (len,ply)
	
		local boneIndex = ply:LookupBone("ValveBiped.Bip01_R_Hand")
		if boneIndex then
			local bonePos, boneAng = ply:GetBonePosition(boneIndex)
	
			local effectdata = EffectData()
			effectdata:SetOrigin(bonePos)
			effectdata:SetAngles(boneAng)
			util.Effect("RifleShellEject", effectdata)
		end
	end)
	end
end