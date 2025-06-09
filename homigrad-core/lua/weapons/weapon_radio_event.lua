SWEP.Base                   = "weapon_base"

SWEP.PrintName 				= "Event Speaker"
SWEP.Author 				= "Homigrad"
SWEP.Category 				= "Остальное"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.NoLHand = true

SWEP.SupportTPIK = true

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Slot					= 5
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/radio/w_radio.mdl"
SWEP.WorldModel				= "models/radio/w_radio.mdl"
SWEP.WorldModelReal				= "models/radio/c_radio.mdl"


function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
    hg.DrawWeaponSelection(self,x,y,wide,tall,alpha)
end

SWEP.IconAng = Angle(-90,0,0)
SWEP.IconPos = Vector(70,-0.5,0)

SWEP.Rarity = 2

SWEP.TPIK_Anims = true

function SWEP:GetWM()
    return self.worldModel or self
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

function SWEP:Initialize()
        self:SetHoldType("normal")

        self.voiceSpeak = 0
        self.lisens = {}

        hg.Weapons[self] = true
    end

if SERVER then

    local can,bipp

    function SWEP:BippSound(ent,pitch)
        ent:EmitSound("buttons/button16.wav",75,pitch)
    end

    function SWEP:CanLisen(output,input,isChat)
        if output:InVehicle() and output:IsSpeaking() then self.voiceSpeak = CurTime() + 0.5 end

        return true
    end

    local CurTime = CurTime
    local GetAll = player.GetAll

    function SWEP:CanTransmit()
        local owner = self:GetOwner()
        return not owner:InVehicle() and (self.voiceSpeak > CurTime() or owner:KeyDown(IN_ATTACK2))
    end

    function SWEP:Step()
        local output = self:GetOwner()
        if not IsValid(output) then return end

        local Transmit = self:CanTransmit()
        self.Transmit = Transmit

        if output:GetActiveWeapon() != self then
            table.Empty(self.lisens)
            return
        end

        if Transmit then
            self:SetNWBool("Tran",true)
            local lisens = self.lisens
            for i,input in pairs(GetAll()) do
                if not self:CanLisen(output,input) then
                    if lisens[input] then
                        lisens[input] = nil
                        self:BippSound(input,80)
                    end
                elseif not lisens[input] then
                    lisens[input] = true
                    //input:ChatPrint("Вещает : " .. output:Nick())
                    self:BippSound(input,100)
                end
            end

            //self:SetHoldType("slam")
        else
            local lisens = self.lisens
            for input in pairs(lisens) do
                lisens[input] = nil
                self:BippSound(input,80)
            end

            self:SetNWBool("Tran",false)
            //self:SetHoldType("normal")
        end
    end

    function SWEP:OnRemove() end

    hook.Add("Player Can Lisen","radio_event",function(output,input,isChat)
        local wep = input:GetWeapon("weapon_radio_event")

        if IsValid(wep) and input:GetActiveWeapon() == wep and wep:CanTransmit() then
            return true, false
        else
            return
        end
    end)
else
    function SWEP:Step()
        self:DrawWM()
    end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

//

function SWEP:Holster()
    if IsValid(self.worldModel) then
        self.worldModel:Remove()
    end
    return true
end

function SWEP:OnRemove()
    if IsValid(self.worldModel) then
        DropProp(self.WorldModel,1,self.worldModel:GetPos(),self.worldModel:GetAngles(),Vector(0,0,0) - self.worldModel:GetAngles():Up() * 150,VectorRand(-250,250))
        self.worldModel:Remove()
    end
end

function SWEP:OwnerChanged()
    if IsValid(self.worldModel) then
        self.worldModel:Remove()
    end
end

SWEP.WorldAng = Angle(20,0,0)
SWEP.WorldPos = Vector(-6,-2,0)

function SWEP:CreateWorldModel()
    if not IsValid(self:GetOwner()) then return end
    if IsValid(self.worldModel) then return end
    local WorldModel = ClientsideModel(self.WorldModelReal)
    WorldModel.IsIcon = true

    WorldModel:SetOwner(self:GetOwner())
    WorldModel:SetModelScale(0.8,0)

    self:CallOnRemove("RemoveWM", function() WorldModel:Remove() end)

    self.worldModel = WorldModel

    return WorldModel
end

function SWEP:DrawWM()
    if not IsValid(self:GetOwner()) then return end 
        local WM = self.worldModel
        local owner = self:GetOwner()
        if owner:GetActiveWeapon() != self then
            return
        end
        if not IsValid(WM) then self:CreateWorldModel() return end
        //if owner.Fake then self.worldModel:Remove() return end 
        if !owner:Alive() then return end
        local asdasdasd = hg.eyeTrace(owner)
        local ent = hg.GetCurrentCharacter(owner)
        local mat = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Head1"))
        local pos = ent:IsRagdoll() and mat:GetTranslation() or asdasdasd.StartPos
        local Att = {Pos = pos,Ang = owner:EyeAngles()}//owner:GetAttachment(owner:LookupAttachment("anim_attachment_RH"))
        WM.IsIcon = true
        //WM:SetNoDraw(false)
        
        local Pos = Att.Pos
        local Ang = Att.Ang
        
        Pos = Pos + Ang:Forward() * self.WorldPos[1] + Ang:Right() * self.WorldPos[2] + Ang:Up() * self.WorldPos[3]
        Ang:RotateAroundAxis(Ang:Forward(),self.WorldAng[1])
        Ang:RotateAroundAxis(Ang:Right(),self.WorldAng[2])
        Ang:RotateAroundAxis(Ang:Up(),self.WorldAng[3])
        
        WM:SetAngles(Ang)
        WM:SetPos(Pos)
        WM:SetOwner(owner)
        WM:SetParent(owner)
        WM:SetPredictable(true)
        
        WM:SetRenderAngles(Ang)
        WM:SetRenderOrigin(Pos)

        return Pos,Ang
end

function SWEP:DrawWorldModel()
    if not IsValid(self:GetOwner()) then self:DrawModel() return end
    local owner = self:GetOwner()

	local Pos,Ang = self:DrawWM()

	if IsValid(self.worldModel) and Pos then
		self.worldModel:SetPos(Pos)
		self.worldModel:SetAngles(Ang)
	end
end