if SERVER then
    AddCSLuaFile()
end

SWEP.PrintName = "Удавка"
SWEP.Author = "Homigrad"
SWEP.Instructions = "ЛКМ - душить человека."
SWEP.Category = "Разное"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/freeman/flexcuffs.mdl"
SWEP.WorldModel = "models/freeman/flexcuffs.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

local CHOKE_DISTANCE = 120
local BACKSTAB_ANGLE = 60

function SWEP:Initialize()
    self:SetHoldType("duel")
end

local function IsBehindTarget(owner, target)
    local targetForward = target:GetForward()
    local directionToOwner = (owner:GetPos() - target:GetPos()):GetNormalized()
    local angleDifference = math.deg(math.acos(targetForward:Dot(directionToOwner)))
    return angleDifference > (180 - BACKSTAB_ANGLE)
end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    if not IsValid(owner) or not owner:IsPlayer() then return end

    owner:LagCompensation(true)
    local trace = owner:GetEyeTrace()

    local target = trace.Entity
    if IsValid(target) and target:IsPlayer() and trace.HitPos:DistToSqr(owner:GetShootPos()) <= (CHOKE_DISTANCE * CHOKE_DISTANCE) then
        if IsBehindTarget(owner, target) then
            if SERVER then
                if not target:GetNWBool("SuffocatingFiber", false) and not target.fake then
                    owner:ChatPrint("Ты начал душить "..target:Name())
                    target:SetNWBool("SuffocatingFiber", true)
                    target:ChatPrint("Тебя душат.")
                    target.SuffocatingFiber = true
                    target:EmitSound("homigrad/suffocation_rope.wav")
                    target:EmitSound("homigrad/suffocation.wav")
                    target:Freeze(true)
                    owner:Freeze(true)
                    target.SuffocatingFiberTime = CurTime()
                    target:SetNWEntity("Choker", owner)
                end
            end
            self:SetNextPrimaryFire(CurTime() + 1)
        else
            if SERVER then
                owner:ChatPrint("Ты должен быть сзади игрока.")
            end
        end
    end

    owner:LagCompensation(false)
end

function SWEP:SecondaryAttack()
end

if CLIENT then
    function SWEP:PreDrawViewModel(vm, wep, ply)
    end

    function SWEP:GetViewModelPosition(pos, ang)
        pos = pos - ang:Up() * 10 + ang:Forward() * 30 + ang:Right() * 7
        ang:RotateAroundAxis(ang:Up(), 90)
        ang:RotateAroundAxis(ang:Right(), -10)
        ang:RotateAroundAxis(ang:Forward(), -10)
        return pos, ang
    end

    local WorldModel = ClientsideModel(SWEP.WorldModel)
    WorldModel:SetNoDraw(true)

    function SWEP:DrawWorldModel()
        local _Owner = self:GetOwner()

        if IsValid(_Owner) then
            local offsetVec = Vector(3, -13, 0)
            local offsetAng = Angle(90, -30, 0)

            local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand")
            if not boneid then return end

            local matrix = _Owner:GetBoneMatrix(boneid)
            if not matrix then return end

            local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

            WorldModel:SetPos(newPos)
            WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
        else
            WorldModel:SetPos(self:GetPos())
            WorldModel:SetAngles(self:GetAngles())
        end

        WorldModel:DrawModel()
    end
end

if SERVER then
    hook.Add("Think", "UnfreezePlayersAfterChoke", function()
        for _, ply in ipairs(player.GetAll()) do
            if ply:GetNWBool("SuffocatingFiber", false) then
                local choker = ply:GetNWEntity("Choker")

                if not ply:Alive() or not choker:Alive() or ply.otrub == true or ply.fake == true then
                    ply:SetNWBool("SuffocatingFiber", false)
                    ply.SuffocatingFiber = false
                    ply:Freeze(false)
                    if IsValid(choker) then
                        choker:Freeze(false)
                    end
                    ply.SuffocatingFiberTime = nil
                    print("AASDASDDASADSADSADSADSSADDDDDDDDDDDDDDDDDDD")
                elseif ply.SuffocatingFiber and ply.SuffocatingFiberTime and CurTime() > ply.SuffocatingFiberTime then
                    ply:SetNWBool("SuffocatingFiber", true)
                    ply.SuffocatingFiber = true
                    ply:TakeDamage(15)
                    ply.o2 = ply.o2 - 0.3
                    ply:Freeze(true)
                    if IsValid(choker) then
                        choker:Freeze(true)
                    end
                    ply.SuffocatingFiberTime = CurTime() + 2
                end
            end
        end
    end)
end
