SWEP.Base                   = "weapon_base"

SWEP.PrintName 				= "Рация"
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

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Slot					= 5
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/radio/w_radio.mdl"
SWEP.WorldModel				= "models/radio/w_radio.mdl"


function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
    hg.DrawWeaponSelection(self,x,y,wide,tall,alpha)
end

SWEP.IconAng = Angle(-90,0,0)
SWEP.IconPos = Vector(70,-0.5,0)

SWEP.Rarity = 2

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
            if not output:Alive() or output.unconscious or not input:Alive() or input.unconscious then return false end
            if output:InVehicle() and output:IsSpeaking() then self.voiceSpeak = CurTime() + 0.5 end

            if not input:HasWeapon("weapon_radio") then return end

            if output:GetActiveWeapon() != self or (not isChat and not self.Transmit) then return end

            if output:Team() == input:Team() or output:Team() == 1002 then return true end
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

        if output:GetActiveWeapon() != self then
            table.Empty(self.lisens)
            return
        end

        local Transmit = self:CanTransmit()
        self.Transmit = Transmit


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

    hook.Add("Player Can Lisen","radio",function(output,input,isChat)
        local wep = output:GetWeapon("weapon_radio")

        if IsValid(wep) and wep:CanLisen(output,input,isChat) and output:GetActiveWeapon() == wep then
            if isChat then
                for i,input in pairs(GetAll()) do
                    if not wep:CanLisen(output,input,isChat) then continue end

                    wep:BippSound(input,140)
                end
            end

            return true,false
        else
            return
        end
    end)
else
    function SWEP:Step()
        if IsValid(self:GetOwner()) then
            local ply = self:GetOwner()

            if self:GetNWBool("Tran") then
                if !ply:KeyDown(IN_DUCK) then
                    hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,-20,0),1,0.125)
                    hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(-5,-110,50),1,0.125)
                    hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(0,0,0),1,0.125)
                else
                    hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,-20,0),1,0.125)
                    hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(-10,-10,50),1,0.125)
                    hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(0,0,0),1,0.125)
                end
            else
                hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,0,0),1,0.125)
                hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(0,0,0),1,0.125)
                hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(0,0,0),1,0.125)
            end
        end
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

SWEP.WorldAng = Angle(-90,0,-90)
SWEP.WorldPos = Vector(3,0,1.5)

function SWEP:CreateWorldModel()
    if not IsValid(self:GetOwner()) then return end
    if IsValid(self.worldModel) then return end
    local WorldModel = ClientsideModel(self.WorldModel)
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
        if owner.Fake then self.worldModel:Remove() return end 
        if !owner:Alive() then return end
        local Att = owner:GetAttachment(owner:LookupAttachment("anim_attachment_RH"))
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