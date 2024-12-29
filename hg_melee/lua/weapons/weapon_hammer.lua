SWEP.PrintName = "Молоток"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Spawnable = true
SWEP.Base = 'hg_melee'

SWEP.WorldModel = "models/weapons/w_jjife_t.mdl"
SWEP.ViewModel =  "models/weapons/w_jjife_t.mdl"

SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize		= 30
SWEP.Secondary.DefaultClip	= 30
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "ammo_crossbow"

SWEP.HardAttack = false
SWEP.Damage = 95
SWEP.DamageType = DMG_CLUB
SWEP.Delay = 1
SWEP.StaminaCost = 6
SWEP.CustomAnim = true
SWEP.HoldType = "knife"
SWEP.TimeUntilHit = 0.2
SWEP.TwoHanded = true
SWEP.ShouldDecal = false
SWEP.DeploySound = {"weapons/melee/melee_draw_temp1.wav","weapons/melee/melee_draw_temp2.wav"}
SWEP.HolsterSound = {"weapons/melee/melee_holster_temp1.wav","weapons/melee/melee_holster_temp2.wav"}
SWEP.SwingSound = {"weapons/melee/swing_heavy_blunt_01.wav","weapons/melee/swing_heavy_blunt_02.wav"}
SWEP.HitFleshSound = {"weapons/melee/flesh_impact_blunt_05.wav"}
SWEP.HitSound = {"snd_jack_hmcd_hammerhit.wav"}

SWEP.AnimLerpLC = Angle(0,0,0)
SWEP.AnimLerpLF = Angle(0,0,0)
SWEP.AnimLerpLH = Angle(0,0,0)

SWEP.AnimLerpRC = Angle(0,0,0)
SWEP.AnimLerpRF = Angle(0,0,0)
SWEP.AnimLerpRH = Angle(0,0,0)

SWEP.CorrectPosX =     -2.5
SWEP.CorrectPosY =     1.2
SWEP.CorrectPosZ =     0

SWEP.CorrectAngPitch = -20
SWEP.CorrectAngYaw =   0
SWEP.CorrectAngRoll =  180

SWEP.CorrectSize = 1.3

local function TwoTrace(ply)
    local owner = ply
    local tr = {}
    tr.start = owner:GetAttachment(owner:LookupAttachment("eyes")).Pos
    local dir = Vector(1,0,0)
    dir:Rotate(owner:EyeAngles())
    tr.endpos = tr.start + dir * 75
    tr.filter = {owner}

    local tRes1 = util.TraceLine(tr)
    if not IsValid(tRes1.Entity) then return end

    tr.start = tRes1.HitPos + tRes1.Normal
    tr.endpos = tRes1.HitPos + dir * 25

    tr.filter[2] = tRes1.Entity
    if SERVER then
        for i,info in pairs(constraint.GetTable(tRes1.Entity)) do
            if info.Ent1 ~= game.GetWorld() then table.insert(tr.filter,info.Ent1) end
            if info.Ent2 ~= game.GetWorld() then table.insert(tr.filter,info.Ent2) end
        end
    end
    local tRes2 = util.TraceLine(tr)
    if not tRes2.Hit then return end

    return tRes1,tRes2
end

if SERVER then
    util.AddNetworkString("molotok_mode")
    util.AddNetworkString("wtf_huy")

    hook.Add("Fake Up","molotok",function(ply,rag)
        if (rag.IsWeld or 0) > 0 then return false end
    end)
else
    net.Receive("molotok_mode",function(len)
        net.ReadEntity().mode = net.ReadBool()
    end)
end

local white = Color(255,255,255)
local bonenames = {
    ['ValveBiped.Bip01_Head1']="голову",
    ['ValveBiped.Bip01_Spine']="позвоночник",
    ['ValveBiped.Bip01_Spine2']="позвоночник",
    ['ValveBiped.Bip01_Pelvis']="живот",
    ['ValveBiped.Bip01_R_Hand']="правую руку",
    ['ValveBiped.Bip01_R_Forearm']="правое предплечье",
    ['ValveBiped.Bip01_R_UpperArm']="правое плечо",
    ['ValveBiped.Bip01_R_Foot']="правую ступню",
    ['ValveBiped.Bip01_R_Thigh']="правое бедро",
    ['ValveBiped.Bip01_R_Calf']="правую икру",
    ['ValveBiped.Bip01_R_Shoulder']="правое плечо",
    ['ValveBiped.Bip01_R_Elbow']="правый локоть",
    ['ValveBiped.Bip01_L_Hand']="левую руку",
    ['ValveBiped.Bip01_L_Forearm']="левое предплечье",
    ['ValveBiped.Bip01_L_UpperArm']="левое плечо",
    ['ValveBiped.Bip01_L_Foot']="левую ступню",
    ['ValveBiped.Bip01_L_Thigh']="левое бедро",
    ['ValveBiped.Bip01_L_Calf']="левую икру",
    ['ValveBiped.Bip01_L_Shoulder']="левое плечо",
    ['ValveBiped.Bip01_L_Elbow']="левый локоть"
}
function SWEP:DrawHUD()
    local owner = self:GetOwner()
    local tr = {}
    tr.start = owner:GetAttachment(owner:LookupAttachment("eyes")).Pos
    local dir = Vector(1,0,0)
    dir:Rotate(owner:EyeAngles())
    tr.endpos = tr.start + dir * 75
    tr.filter = owner

    local tRes1,tRes2 = TwoTrace(owner)

    local traceResult = util.TraceLine(tr)
    local hit = traceResult.Hit and 1 or 0
    local hitEnt = traceResult.Entity~=Entity(0) and 1 or 0
    local isRag = traceResult.Entity:IsRagdoll()
    local frac = traceResult.Fraction
    surface.SetDrawColor(Color(255 * hitEnt, 255 * hitEnt, 255 * hitEnt, 255 * hit))
    draw.NoTexture()
    Circle(traceResult.HitPos:ToScreen().x, traceResult.HitPos:ToScreen().y, 5 / frac, 32)
    draw.DrawText(not tRes1 and "" or isRag and ("Прибить "..tostring(bonenames[traceResult.Entity:GetBoneName(traceResult.Entity:TranslatePhysBoneToBone(traceResult.PhysicsBone))])) or (tobool(hitEnt) and tobool(hit)) and "Nail prop" or "","TargetID",traceResult.HitPos:ToScreen().x,traceResult.HitPos:ToScreen().y - 40,color_white,TEXT_ALIGN_CENTER)
end

function SWEP:HammerThink()
    local ply = self:GetOwner()
    if SERVER then
        if ply:KeyDown(IN_ATTACK2) then
            if ply:KeyDown(IN_USE) and not self.modechanged then
                self.modechanged = true

                self.mode = not (self.mode or false)
                net.Start("molotok_mode")
                net.WriteEntity(self)
                net.WriteBool(self.mode)
                net.Send(ply)
                ply:ChatPrint(not self.mode and "Режим Забивания" or "Режим Отдирания")
            end
        else
            self.modechanged = false
        end
    end
end

function SWEP:Think()
    self:HammerThink()

    

    if self.Anim1 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(-80,60,0))
        self.AnimLerpRF = LerpAngleFT(0.1,self.AnimLerpRF,Angle(70,30,50))
        self.AnimLerpRH = LerpAngleFT(0.1,self.AnimLerpRH,Angle(-30,0,-50))
    elseif self.Anim2 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(1,self.AnimLerpRC,Angle(0,-20,-70))
        self.AnimLerpRF = LerpAngleFT(1,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(1,self.AnimLerpRH,Angle(-40,-20,0))
    elseif self.Anim3 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)
            
        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(0,0,0))
        self.AnimLerpRF = LerpAngleFT(0.6,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(0.3,self.AnimLerpRH,Angle(0,0,0))
    end

    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(20,25, 30) + self.AnimLerpRC, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0,-10,0) + self.AnimLerpRF, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,20,30) + self.AnimLerpRH, true)

	--self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(20,20, 30) + self.AnimLerpRC, true)
	--self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0,0,0) + self.AnimLerpRF, true)
	--self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,20,30) + self.AnimLerpRH, true)

    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(30, -30, 0) + self.AnimLerpLC, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(10, 90, 0) + self.AnimLerpLF, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(30, -20, 0) + self.AnimLerpLH, true)
    

    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_Spine4"), Angle(0,-20, 0), true)
end

function SWEP:SecondaryAttack()
    if not self.mode then
        local att = self:GetOwner()

        local tRes1,tRes2 = TwoTrace(att)
        if not tRes1 then return end
        if self:Clip2() == 0 then return end
        self:EmitSound(self.SwingSound[math.random(#self.SwingSound)])
        self.Anim1 = true
		    self.Anim2 = false
		    self.Anim3 = false
		    timer.Simple(self.TimeUntilHit,function() 
		    self.Anim1 = false
		    self.Anim2 = true
		    self.Anim3 = false
		    timer.Simple(0.1,function()
		    self.Anim1 = false
		    self.Anim2 = false
		    self.Anim3 = true
		    end)
        end)
        if SERVER then
            timer.Simple(self.TimeUntilHit,function()
            self:SetClip2(self:Clip2() - 1)
            
            local ent1,ent2 = tRes1.Entity,tRes2.Entity

            ent1.IsWeld = (ent1.IsWeld or 0) + 1
            ent2.IsWeld = (ent2.IsWeld or 0) + 1

            local ply = RagdollOwner(ent1) or RagdollOwner(ent2) or false
            if ply then
                local dmg = DamageInfo()
                dmg:SetDamage(10)
                dmg:SetAttacker(self)
                dmg:SetDamageType(DMG_SLASH)

                ply:TakeDamageInfo(dmg)
                ply.Bloodlosing = ply.Bloodlosing + 10

                if GuiltLogic(att,ply,dmg) then
                    att.Guilt = 10

                    GuiltCheck(att)
                end
            end

            if not IsValid(ent1:GetPhysicsObject()) or not IsValid(ent2:GetPhysicsObject()) then return end

            local weldEntity = constraint.Weld(ent1,ent2,tRes1.PhysicsBone or 0,tRes2.PhysicsBone or 0,0,false,false)
            ent1.weld = ent1.weld or {}
            ent2.weld = ent2.weld or {}
            ent1.weld[weldEntity] = ent2
            ent2.weld[weldEntity] = ent1

            self:GetOwner():EmitSound("snd_jack_hmcd_hammerhit.wav",65)
        end) 
        end
        self:SetNextSecondaryFire(CurTime() + 0.7)
        
    else
        local att = self:GetOwner()
        local tRes1,tRes2 = TwoTrace(att)
        if not tRes1 then return end
        local ent1,ent2 = tRes1.Entity,tRes2.Entity

        local ply = RagdollOwner(ent1) or RagdollOwner(ent2)
        if ent1.weld then
            for weldEntity,ent2 in pairs(ent1.weld) do
                ent1.IsWeld = math.max((ent1.IsWeld or 0) - 1,0)
                ent2.IsWeld = math.max((ent2.IsWeld or 0) - 1,0)
                if ent1.IsWeld == 0 and ent2.IsWeld == 0 then
                    ent2.weld[weldEntity] = nil
                    ent1.weld[weldEntity] = nil

                    weldEntity:Remove()
                end
                self:SetClip2(self:Clip2() + 1)

                ent1:EmitSound("snd_jack_hmcd_hammerhit.wav",65)
               
            end

            if ply then
                local dmg = DamageInfo()
                dmg:SetDamage(10)
                dmg:SetAttacker(self)
                dmg:SetDamageType(DMG_SLASH)

                ply.Bloodlosing = ply.Bloodlosing + 10

                if GuiltLogic(att,ply,dmg,true) then
                    att.Guilt = math.max(att.Guilt - 2,0)
                end
            end
        end

        self:SetNextSecondaryFire(CurTime() + 1)
    end
end