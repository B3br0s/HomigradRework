SWEP.Base = "homigrad_base"
SWEP.PrintName = ".357 Magnum"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Half-Life"
SWEP.WorldModel = "models/sirgibs/hl2/weapons/357.mdl"

SWEP.CorrectAng = Angle(0,0,0)
SWEP.CorrectPos = Vector(1.8,-1.5,-0.3)
SWEP.HolsterPos = Vector(-7,0,2)
SWEP.HolsterAng = Angle(0,-45,-90)
SWEP.BoltBone = "Hammer"
SWEP.BoltVec = Angle(0,0,-45)

SWEP.IsRevolver = true

SWEP.ZoomPos = Vector(-6,0.025,5.33)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(-2,0,0)
SWEP.AttAng = Angle(0,0.4,0)
SWEP.MuzzlePos = Vector(12,0,4)
SWEP.MuzzleAng = Angle(0,0,0)
SWEP.Empty3 = false
SWEP.Empty4 = false

SWEP.Primary.DefaultClip = 6
SWEP.Primary.ClipSize = 6
SWEP.Primary.Damage = 45
SWEP.Primary.Force = 15
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Wait = 0.5
SWEP.Primary.Sound = {"weapons/357/357_fire1.wav","weapons/357/357_fire2.wav","weapons/357/357_fire3.wav"}
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.RecoilForce = 8
SWEP.rollmul = 0

SWEP.IconPos = Vector(13.5,100,-5)
SWEP.IconAng = Angle(0,0,0)

SWEP.Blank = 0

SWEP.Reload1 = "weapons/357/357_reload1.wav"
SWEP.Reload2 = "weapons/357/357_reload2.wav"
SWEP.Reload3 = "weapons/357/357_reload3.wav"
SWEP.Reload4 = "weapons/357/357_reload4.wav"

function SWEP:PostAnim()
	//self.rollmul = LerpFT(0.2,self.rollmul,55550)
	if self.BoltBone and IsValid(self.worldModel) and self.BoltVec != nil then
		local bone = self.worldModel:LookupBone(self.BoltBone)

		self.animmul = LerpFT(0.15,self.animmul,0)
		self.rollmul = LerpFT(0.2,self.rollmul,10)

		self.worldModel:ManipulateBoneAngles(bone,self.BoltVec * (1 - self.animmul))
		self.worldModel:ManipulateBoneAngles(self.worldModel:LookupBone("Clipazine_Child"),Angle(0,45,0) * (10 - self.rollmul))
	end
end

function SWEP:CanShoot()
	self.Blank = self.Blank - 1
	if SERVER and self:GetOwner().suiciding and self:Clip1() > 0 then
		self:GetOwner().adrenaline = self:GetOwner().adrenaline + 1.5
	end
	self.animmul = 1
	self.rollmul = 7.5
    return (!self.reload and !self.Inspecting and self:Clip1() > 0 and !self:IsSprinting() and !self:IsClose() and self.Blank <= 0)
end

function SWEP:Roll()
	self.rollmul = -100
	if SERVER then
		self.Blank = math.random(math.max((self:GetMaxClip1() + math.random(0,1)) - self:Clip1(), math.random(1,2)))
		self:SetNWInt("Blank",self.Blank)
		sound.Play("weapons/357/357_spin1.wav",self.worldModel:GetPos(),80,100,1)
	end
end

function RollDrum(wep)
	local self = wep
	if SERVER then
		self.Blank = math.random(math.max((self:GetMaxClip1() + math.random(0,1)) - self:Clip1(), math.random(1,2)))
		self:SetNWInt("Blank",self.Blank)
		sound.Play("weapons/357/357_spin1.wav",self.worldModel:GetPos(),80,100,1)
	end
	net.Start("LoadedZalupa")
	net.WriteEntity(wep)
	net.WriteFloat(wep.Blank)
	net.Broadcast()
end

if CLIENT then
	net.Receive("LoadedZalupa",function()
		local wep = net.ReadEntity()
		local amt = net.ReadFloat()

		wep.rollmul = -100
		wep.Blank = amt

		if wep.IsShotgun then
			wep.CanShoot = function()
				local self = wep
				self.Blank = self.Blank - 1
				if self.Blank > 0 then
					self.Pumped = false
				end
				if SERVER and self:GetOwner().suiciding and self:Clip1() > 0 then
					self:GetOwner().adrenaline = self:GetOwner().adrenaline + 1.5
				end
    		return (!self.Reloading and !self.Inspecting and self:Clip1() > 0 and self.Pumped and !self:IsSprinting() and !self:IsClose() and (self.Blank or 0) <= 0)
		end
	end
	end)
else
	util.AddNetworkString("LoadedZalupa")

	concommand.Add("hg_roll",function(ply,cmd,args)
		if !ply:Alive() then
			return
		end
		if ply:GetActiveWeapon().Roll or ply:IsSuperAdmin() and ply:GetActiveWeapon().IsShotgun then
			if ply:GetActiveWeapon().Roll then
				ply:GetActiveWeapon():Roll()
			else
				RollDrum(ply:GetActiveWeapon())
				ply:GetActiveWeapon().CanShoot = function()
						local self = ply:GetActiveWeapon()
						if !self.Blank then
							self.Blank = 0
						end
						self.Blank = self.Blank - 1
						if self.Blank > 0 then
							self.Pumped = false
							self:TakePrimaryAmmo(1)
						end
						if SERVER and self:GetOwner().suiciding and self:Clip1() > 0 then
							self:GetOwner().adrenaline = self:GetOwner().adrenaline + 1.5
						end
    				return (!self.Reloading and !self.Inspecting and self:Clip1() > 0 and self.Pumped and !self:IsSprinting() and !self:IsClose() and (self.Blank or 0) <= 0)
				end
			//ply:ChatPrint("No, i wanna taste real luck.")
			end
			net.Start("LoadedZalupa")
			net.WriteEntity(ply:GetActiveWeapon())
			net.WriteFloat(ply:GetActiveWeapon().Blank)
			net.Broadcast()
		end
	end,false,"No, i wanna taste real luck.")
end