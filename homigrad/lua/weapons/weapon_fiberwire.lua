--SWEP.PrintName = "Удавка" -- хитмон
SWEP.PrintName = "Fiber Wire"
SWEP.Category = "Предметы: Предатель"
SWEP.Spawnable = true

SWEP.WorldModel = "models/hmc/weapons/w_fibrewire.mdl"
SWEP.ViewModel = "models/hmc/weapons/w_fibrewire.mdl"

SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = "none"

SWEP.RagCarry = nil
SWEP.Delay = 3
SWEP.DamagKD = 0

function SWEP:Initialize()
    self:SetHoldType('normal')
end

function SWEP:PrimaryAttack()
    if CLIENT then return end
    local ply = self:GetOwner()
    if not IsValid(ply) or self.RagCarry != nil then return end
    self:SetNextPrimaryFire(CurTime() + self.Delay)
    local taras = ply:GetEyeTrace()
    self:SetHoldType("duel")
    timer.Simple(1,function()
    if self.RagCarry == nil then
        self:SetHoldType('normal')
    end
    end)
    if taras.Hit and taras.Entity:IsPlayer() then
        if self:IsFromBehind(taras.Entity) then
            self:CatchSomeone(taras.Entity)
        end
    end
end

function SWEP:Holster()
    if CLIENT then return end
    if self.RagCarry != nil then 
        return false 
    else
        return true
    end
end

function SWEP:IsFromBehind(npc)--а кто мне запрещает пиздить что то из хомисайда моддед?))))))) 

	local pos1 = self:GetOwner():GetShootPos()
	local pos2 = npc:GetShootPos()

	if pos1:Distance(pos2) > 50 then return end

	local forward = self:GetOwner():GetAimVector()
	local dir = npc:GetForward()
	local dot = dir:Dot( forward ) >= math.cos(math.rad(180/2))

	return dot

end

function SWEP:IsTargetHuman(npc)
	local head = npc:LookupBone("ValveBiped.Bip01_Head1")
	
	if head ~= nil then return true end
	
	return false
	
end

function SWEP:SecondaryAttack()
if self.RagCarry != nil then
    self.RagCarry:GetNWEntity("RagdollOwner").Dushat = false
    self.RagCarry:GetNWEntity("RagdollOwner").PenisDushilin = nil
    self.RagCarry = nil
    self:SetHoldType('normal')
end
end

function SWEP:CatchSomeone(ent)-- ДААА ДУШИ МЕНЯ SWEP:CATCHSOMEONE(ENT)
    if CLIENT then return end
    if not ent:IsPlayer() or not IsValid(ent) then return end
    self:SetHoldType("camera")

    ent:DropWeapon1()

    ent.PenisDushilin = self:GetOwner()

    Faking(ent)

    ent.Dushat = true

    self.RagCarry = ent:GetNWEntity("Ragdoll")
end

function SWEP:Think()
    if CLIENT then return end
    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    local eyeAttachment = ply:LookupAttachment("eyes")
    if eyeAttachment == 0 then return end

    local eyePos = ply:GetAttachment(eyeAttachment).Pos
    local eyeAngles = ply:EyeAngles() + Angle(4, 0, 0)
    local traceData = {
        start = eyePos,
        endpos = eyePos + eyeAngles:Forward() * 35,
        filter = ply
    }

    local tr = util.TraceLine(traceData)

    if self.RagCarry and IsValid(self.RagCarry) then
        local rag = self.RagCarry
        local SpineInd = rag:LookupBone("ValveBiped.Bip01_Spine4")
        local HeadInd = rag:LookupBone("ValveBiped.Bip01_Head1")
        local RAInd = rag:LookupBone("ValveBiped.Bip01_R_Hand")
        local LAInd = rag:LookupBone("ValveBiped.Bip01_L_Hand")

        if not SpineInd or not HeadInd or not RAInd or not LAInd then return end

        rag:SetCollisionGroup(COLLISION_GROUP_NONE)

        if self.DamagKD < CurTime() then
            self.DamagKD = CurTime() + 0.5
            rag:TakeDamage(2)
        end

        local SpinePhys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(SpineInd))
        local HeadPhys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(HeadInd))
        local RAPhys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(RAInd))
        local LAPhys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(LAInd))

        if IsValid(SpinePhys) then
            local SpinePos = SpinePhys:GetPos()
            local direction = (traceData.endpos - SpinePos):GetNormalized()
            local velocityMagnitude = 600
            local targetVelocity = direction * velocityMagnitude
            local newVelocity = LerpVector(0.1, SpinePhys:GetVelocity(), targetVelocity)
            SpinePhys:SetVelocity(newVelocity)

            local Angli = ply:EyeAngles()
            Angli:RotateAroundAxis(Angli:Right(), 90)
            Angli:RotateAroundAxis(Angli:Forward(), -90)

            local currentAngles = SpinePhys:GetAngles()
            local newAngles = LerpAngle(0.05, currentAngles, Angli)
            SpinePhys:SetAngles(newAngles)

            if IsValid(HeadPhys) then
                local HeadPos = HeadPhys:GetPos()


                if IsValid(RAPhys) and self.RagCarry:GetNWEntity("RagdollOwner") != NULL and self.RagCarry:GetNWEntity("RagdollOwner"):Alive() then
                    local directionToHead = (HeadPos - RAPhys:GetPos()):GetNormalized()
                    RAPhys:SetVelocity(directionToHead * 150)
                end

                if IsValid(LAPhys) and self.RagCarry:GetNWEntity("RagdollOwner") != NULL and self.RagCarry:GetNWEntity("RagdollOwner"):Alive() then
                    local directionToHead = (HeadPos - LAPhys:GetPos()):GetNormalized()
                    LAPhys:SetVelocity(directionToHead * 150)
                end
            end
        end
    end
end


--[[ 
Я промолчу.

⣿⡟⢸⣿⣿⣿⣄⠹⣷⠰⣤⣌⡙⢿⠏⣠⣿⣿⣿⣿⡇⣸
⣿⡇⣾⣿⣿⣿⣿⡧⠈⣀⣹⣿⣿⣦⣰⣿⣿⣿⣿⣿⡇⣿
⣿⡇⢿⣿⣿⣿⣿⣶⣶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡇⣿
⣿⣇⢸⣿⡿⠿⠿⠿⠿⣿⣿⣿⣿⠿⠟⠛⠛⢻⣿⣿⢁⣿
⡿⠿⠄⠻⡖⢰⡆⠀⠀⢸⣿⣿⡇⠀⠀⢸⡆⢹⠋⠁⠚⣿
⣷⡀⠲⣶⡇⢺⣷⡀⢀⡾⠿⣿⣷⣀⣀⣾⠇⣸⡿⠋⣰⣿
⣿⣿⢁⣦⣀⣡⣿⣿⡿⠿⠛⠻⠟⢻⣿⣥⣀⣽⣷⡌⢻⣿
⣿⣿⣬⣭⣌⡙⠛⠿⣷⣶⣾⣿⣿⣿⠛⢛⣀⣬⣥⣤⣼⣿
⣿⣿⣿⣿⣿⣿⣄⠒⢶⣾⣿⣿⣿⣿⣧⡈⢿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡏⠐⢻⣿⣿⣿⣿⣿⣿⣧⠘⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⠃⣼⣿⣿⣿⣿⣿⣿⣿⡇⢻⣿⣿⣿⣿
]]--