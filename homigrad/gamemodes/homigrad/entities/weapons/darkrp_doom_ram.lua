if SERVER then
    AddCSLuaFile()
end

SWEP.PrintName = "Battering Ram"
SWEP.Author = "Homigrad"
SWEP.Category = "Разное"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.ViewModelFOV = 54

SWEP.HitDistance = 80

function SWEP:Initialize()
    self:SetHoldType("rpg")
end

local function IsDoor(ent)
    if not IsValid(ent) then return false end
    local class = ent:GetClass()
    return class == "prop_door_rotating" or class == "func_door" or class == "func_door_rotating"
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 1)

    local owner = self:GetOwner()
    owner:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")

    if SERVER then
        local tr = owner:GetEyeTrace()
        local target = tr.Entity

        if IsDoor(target) and tr.HitPos:Distance(owner:GetPos()) <= self.HitDistance then
            self:EmitSound("snd_jack_hmcd_explosion_far.wav")

            if target:GetClass() == "prop_door_rotating" then
                local doorPos = target:GetPos()
                local doorAngles = target:GetAngles()
                local doorModel = target:GetModel()
                local doorSkin = target:GetSkin() or 0

                target:Fire("Unlock", "", 0)
                target:Fire("Open", "", 0)
                target:Remove()


                local physDoor = ents.Create("prop_physics")
                physDoor:SetModel(doorModel)
                physDoor:SetPos(doorPos)
                physDoor:SetAngles(doorAngles)
                physDoor:SetSkin(doorSkin)
                physDoor:Spawn()

                local phys = physDoor:GetPhysicsObject()
                if IsValid(phys) then
                    local forceDirection = owner:GetAimVector() * 10000
                    phys:ApplyForceCenter(forceDirection)
                end
            elseif target:GetClass() == "func_door" or target:GetClass() == "func_door_rotating" then
                local doorPos = target:GetPos()
                local doorAngles = target:GetAngles()
                local doorModel = target:GetModel()
                local doorSkin = target:GetSkin() or 0

                target:Fire("Unlock", "", 0)
                target:Fire("Open", "", 0)
                target:Fire("Disable", "", 0.1)

                local physDoor = ents.Create("prop_physics")
                physDoor:SetModel(doorModel)
                physDoor:SetPos(doorPos)
                physDoor:SetAngles(doorAngles)
                physDoor:SetSkin(doorSkin)
                physDoor:Spawn()

                target:Remove()

                local phys = physDoor:GetPhysicsObject()
                if IsValid(phys) then
                    local forceDirection = owner:GetAimVector() * 10000
                    phys:ApplyForceCenter(forceDirection)
                end
            end
        else
            self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
        end
    end
end

function SWEP:SecondaryAttack()
end
