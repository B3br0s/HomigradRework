SWEP.Base = "wep_food_base" //БЕТОН
SWEP.PrintName = "Арматура"
SWEP.Category = "Еда"
SWEP.Spawnable = true

SWEP.WorldModel = "models/props_debris/rebar004a_32.mdl"

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.UseHands = true
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true

SWEP.Regens = 15
SWEP.BiteSounds = "BETON"

SWEP.Rarity = 5

SWEP.WorldAng = Angle(0,0,180)
SWEP.WorldPos = Vector(0,0,3)

SWEP.IconAng = Angle(0,0,90)
SWEP.IconPos = Vector(100,0,0)

function SWEP:Eat()
    local ply = self:GetOwner()

    if SERVER then
        ply.hunger = ply.hunger + self.Regens

        if self.Bites == 1 then
            local Shalava = DamageInfo()
            Shalava:SetDamage(1e8)
            Shalava:SetDamageType(DMG_CRUSH)
            Shalava:SetInflictor(self)
            Shalava:SetAttacker(ply)

            ply:TakeDamageInfo(Shalava)

            local Pos,Ang = ply:GetPos(),(vector_up * 32):Angle()
            net.Start("blood particle explode")
            net.WriteVector(Pos)
            net.WriteVector(Pos + Ang:Up() * 10)
            net.Broadcast()
            net.Start("bp fall")
            net.WriteVector(Pos)
            net.WriteVector(Pos + Ang:Up() * 10)
            net.Broadcast()

            timer.Simple(0,function()
                ply.FakeRagdoll:Remove()
            end)

            util.BlastDamage(self,ply,Pos,100,50)
        end
    else
        if self.Bites == 2 then
            self.worldModel:SetModel("models/props_debris/rebar002a_32.mdl")
            self.WorldModel = "models/props_debris/rebar002a_32.mdl"
        end
    end
end

function SWEP:OnRemove()
    if IsValid(self.worldModel) then
        DropProp("models/props_debris/rebar001a_32.mdl",1,self.worldModel:GetPos(),self.worldModel:GetAngles(),Vector(0,0,0) - self.worldModel:GetAngles():Up() * 150,VectorRand(-250,250))
        self.worldModel:Remove()
    end
end