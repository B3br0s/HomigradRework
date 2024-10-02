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

SWEP.HitDistance = 120

function SWEP:Initialize()
    self:SetHoldType("rpg")
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 1)

    local owner = self:GetOwner()
    owner:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")

    if SERVER then
        util.AddNetworkString("HuyJopaPizda")
        local tr = owner:GetEyeTrace()
        local target = tr.Entity

        if tr.HitPos:Distance(owner:GetPos()) <= self.HitDistance then
            self:EmitSound("snd_jack_hmcd_explosion_far.wav")

            net.Start("HuyJopaPizda")
            net.WriteString("snd_jack_hmcd_explosion_far.wav")
            net.Send(self:GetOwner())

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
                    for i = 1,50 do
                        timer.Simple(0.001 * i,function ()
                    phys:ApplyForceCenter(forceDirection)
                    end)
                end
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
                    for i = 1,50 do
                    timer.Simple(0.001 * i,function ()
                    phys:ApplyForceCenter(forceDirection)
                    end)
                end
                end
            elseif target:GetClass() == "player" then
                Faking(target)
            
                    local ragdoll = target:GetNWEntity("Ragdoll")
                    if IsValid(ragdoll) then
                        local forceDirection = owner:GetAimVector() * 99999999 * 50
                        for i = 1,50 do
                        timer.Simple(0.001 * i,function ()
                            ragdoll:GetPhysicsObject():ApplyForceCenter(forceDirection * 2)    
                        end)
                        end
                    else
                        print("Ragdoll entity is not valid!")
                    end
                elseif target:GetClass() == "prop_ragdoll" then
                    if IsValid(target) then
                        local forceDirection = owner:GetAimVector() * 100
                        local ragdoll = target
                
                        -- Number of physics objects (body parts) in the ragdoll
                        local numPhysObjs = ragdoll:GetPhysicsObjectCount()
                
                        for i = 1, 50 do
                            timer.Simple(0.01 * i, function()
                                -- Apply force to each physics object (each body part) of the ragdoll
                                for physIndex = 0, numPhysObjs - 1 do
                                    local physObj = ragdoll:GetPhysicsObjectNum(physIndex)
                                    if IsValid(physObj) then
                                        physObj:ApplyForceCenter(forceDirection * 2)
                                    end
                                end
                            end)
                        end
                    else
                        print("Ragdoll entity is not valid!")
                    end
                end
            end
            
        else
            self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
        end
end

if CLIENT then
    net.Receive("HuyJopaPizda",function ()
        LocalPlayer():EmitSound(net.ReadString())
    end)  
end


function SWEP:SecondaryAttack()
end
