SWEP.Base = "weapon_base"
SWEP.PrintName = "Homigrad Weapon Base"

SWEP.ViewModel = "models/weapons/arccw_go/v_pist_p2000.mdl"
SWEP.WorldModel = "models/weapons/arccw_go/v_pist_p2000.mdl"

SWEP.Spawnable = true
SWEP.Category = "Оружие: Базы"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ishgwep = true
SWEP.SupportTPIK = true

SWEP.CanSuicide = true

SWEP.IKAnimationProxy = {}
SWEP.Animations = {}

SWEP.Rarity = 3

SWEP.animmul = 0

SWEP.Slot = 2
SWEP.SlotPos = 0 

SWEP.HoldType = "revolver"
SWEP.Primary.Damage = 10
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.Primary.Wait = 0.1
SWEP.Primary.Force = 5
SWEP.Sound = "arccw_go/hkp2000/hkp2000-1.wav"

hg.Weapons = hg.Weapons or {}

function SWEP:Initialize()
    hg.Weapons[self] = true

    self:SetHoldType(self.HoldType)

    self:Deploy()
end

function SWEP:CanShoot()
    return (!self.reload and self:Clip1() > 0 and !self:IsSprinting() and !self:GetOwner():GetNWBool("otrub")) and !self:IsTooClose()
end

function SWEP:IsSprinting()
	local ply = self:GetOwner() 

    if self.reload then
        return false
    end

	if !IsValid(ply) then
		return false
	end

	if ply.Fake then
		return false
	end

	if ply:IsSprinting() then
		return true
	end

	return false
end

function SWEP:IsLocal()
	return CLIENT and self:GetOwner() == LocalPlayer()
end

if SERVER then
    util.AddNetworkString("hg shoot")
else
    net.Receive("hg shoot",function()
        local wep = net.ReadEntity()

        if wep.Shoot then
            wep:Shoot()
        end
    end)
end

function SWEP:PrimaryAttack()
    if self:Clip1() == 0 and SERVER then
		self.Primary.Automatic = false
		sound.Play("weapons/clipempty_pistol.wav",self:GetPos(),75,math.random(95,105),1)
		return
	end
	self.Primary.Automatic = weapons.Get(self:GetClass()).Primary.Automatic
    if !self:CanShoot() then
        return
    end
    if self:GetNextShoot() > CurTime() then
        return
    end
    
    self:Shoot()
end

function SWEP:PrimaryAdd()
end

function SWEP:SecondaryAttack()
end

function SWEP:OwnerChanged()
    if IsValid(self.worldModel) then
        self.worldModel:Remove()
        self.worldModel = nil
    end
end

function SWEP:IsPistolHoldType()
    if self.HoldType == "revolver" then
        return true 
    else
        return false
    end
end

function SWEP:Deploy()
    local ply = self:GetOwner()
	self:SetHoldType("normal")
	if self:IsPistolHoldType() then
		self:EmitSound("homigrad/weapons/draw_pistol.mp3")
	else
		self:EmitSound("homigrad/weapons/draw_rifle.mp3")
	end
	if self.Animations then
        hg.PlayAnim(self,"draw")
    end

    local pos,ang = self:WorldModel_Holster_Transform()

    ply.prev_wep_ang = ang
end

function SWEP:SetNextShoot(value)
    self.NextShoot = value
end

function SWEP:GetNextShoot()
    return self.NextShoot or 0
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 1, "SequenceIndex")
	self:NetworkVar("Float", 2, "SequenceProxy")
	self:NetworkVar("Float", 3, "IKTimeLineStart")
    self:NetworkVar("Float", 4, "IKTime")
    self:NetworkVar("Float", 5, "SequenceSpeed")
    self:NetworkVar("Float", 6, "ProcessedValue")

	self:NetworkVar("String", 0, "IKAnimation")
end

function SWEP:PostAnim()
    if self.BoltBone and self.BoltVec and CLIENT then
        local bone = self:GetWM():LookupBone(self.BoltBone)

        if bone then
            self:GetWM():ManipulateBonePosition(bone,self.BoltVec * self.animmul)
        end
    end

    self.animmul = LerpFT(0.25,self.animmul,0)
end

function SWEP:IsClose()
    local Pos,Ang = self:GetTrace(true)

    local ply = self:GetOwner()

    local tr_tbl = {
        start = Pos - Ang:Forward() * 55,
        endpos = Pos,
        filter = {self.worldModel,hg.GetCurrentCharacter(ply)}
    }

    local tr = util.TraceLine(tr_tbl)

    local tr_tbl2 = {
        start = tr_tbl.start - Ang:Forward() * 10,
        endpos = (Pos) + Ang:Forward() * Pos:Distance(tr.HitPos),
        filter = {self.worldModel,hg.GetCurrentCharacter(ply)}
    }

    local tr = util.TraceLine(tr_tbl2)

    local dist = (tr.Hit and Pos:Distance(tr.HitPos) + 2 or LerpFT(0.1,(dist or 1),0))

    if GetConVar("developer"):GetBool() and CLIENT then
        local hit = tr.HitPos:ToScreen()
        surface.SetDrawColor( 255, 0, 0, 255)
        surface.DrawRect(hit.x,hit.y,4,4)
    end

    //self.ClosePos = LerpFT(0.1,self.ClosePos,dist)
    //self.Isclose = tr.Hit

    return tr.Hit,dist
end

function SWEP:IsTooClose()
    return false
end

function SWEP:Step()
    local ply = self:GetOwner()
    
    self:PostAnim()

    if !IsValid(ply) then
        return
    end

    self:Step_Spray()

    if ply:GetActiveWeapon() != self then
        self:WorldModel_Holster_Transform()
    end
    
    self:SetNWBool("sighted",ply:KeyDown(IN_ATTACK2))

    self.NoLHand = (self:IsPistolHoldType() and ply:GetNWBool("suiciding") or false)

    self:SetHoldType((ply:GetNWBool("suiciding") and "normal" or self.HoldType))

    self.speed = (ply:GetNWBool("suiciding") and 0 or LerpFT(0.12,self.speed or 0,((self:IsSprinting() or self.ClosePos > 10) and 1 or 0)))
end

hook.Add("Think","Homigrad-Weapon",function()
    for wep, _ in pairs(hg.Weapons) do
        if IsValid(wep) and wep.Step then
            wep:Step()
            if IsValid(wep:GetOwner()) and wep.IsClose and wep:GetOwner():GetActiveWeapon() == wep then
                local is,dist = wep:IsClose()

                //if SERVER then
                //    wep.ClosePos = dist
                //    wep.Isclose = is
                //else
                //    wep.ClosePos = (wep:GetOwner() == LocalPlayer() and dist or 0)
                //    wep.Isclose = is
                //end
            end
        end
    end
end)

function SWEP:IsSighted()
    local ply = self:GetOwner()
    if SERVER then
        return ply:KeyDown(IN_ATTACK2)
    else
        return self:GetNWBool("sighted",false)
    end
end