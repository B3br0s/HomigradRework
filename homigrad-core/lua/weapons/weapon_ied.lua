SWEP.Base                   = "weapon_base"

SWEP.PrintName 				= "Самодельное взрывное устройство"
SWEP.Author 				= "Homigrad"
//SWEP.Instructions			= "ЛКМ - Поставить | Заложить \n ПКМ - взорвать"
SWEP.Category 				= "Оружие: Остальное"

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

SWEP.Rarity = 4

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Slot					= 4
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/props_junk/cardboard_jox004a.mdl"
SWEP.WorldModel				= "models/props_junk/cardboard_jox004a.mdl"

SWEP.IconPos = Vector(70,0,0)
SWEP.IconAng = Angle(0,90,90)
SWEP.WepSelectIcon2 = Material("null")
SWEP.IconOverride = ""

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	hg.DrawWeaponSelection(self,x,y,wide,tall,alpha)
end

function SWEP:Think()
   self:SetHoldType("normal")
end

if SERVER then

    local function Bomb(ent)
        local SelfPos,PowerMult,Model = ent:LocalToWorld(ent:OBBCenter()),6,ent:GetModel()

        ent:EmitSound("nokia.wav")

		timer.Simple(0.5,function()
            ParticleEffect("pcf_jack_groundsplode_large",SelfPos,vector_up:Angle())
            util.ScreenShake(SelfPos,99999,99999,1,3000)
            sound.Play("BaseExplosionEffect.Sound", SelfPos,120,math.random(90,110))

            for i = 1,4 do
                sound.Play("explosions/doi_ty_01_close.wav",SelfPos,140,math.random(80,110))
            end

            if util.GetSurfaceIndex(ent:GetBoneSurfaceProp(0)) == 3 or util.GetSurfaceIndex(ent:GetBoneSurfaceProp(0)) == 66 then
                JMod.FragSplosion(ent, SelfPos + Vector(0, 0, 1), 1024, 50, 3500, ent.owner or game.GetWorld())
            end

            timer.Simple(.1,function()
                for i = 1, 5 do
                    local Tr = util.QuickTrace(SelfPos, VectorRand() * 20)

                    if Tr.Hit then
                        util.Decal("Scorch", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
                    end
                end
            end)

            JMod.WreckBuildings(ent, SelfPos, PowerMult)
            JMod.BlastDoors(ent, SelfPos, PowerMult)

            if IsValid(ent) then
                ent:RemoveCallOnRemove("homigrad-bomb")
                ent:Remove()
            end
            timer.Simple(0,function()
                local ZaWarudo = game.GetWorld()
                local Infl, Att = (IsValid(ent) and ent) or ZaWarudo, (IsValid(ent) and IsValid(ent.owner) and ent.owner) or (IsValid(ent) and ent) or ZaWarudo
                util.BlastDamage(Infl,Att,SelfPos,60 * PowerMult,120 * PowerMult)
            end)
		end)
        if IsValid(ent.parentBomb) then ent.parentBomb:Remove() end
    end

    function SWEP:Initialize()
        self:SetHoldType("normal")
    end

    function SWEP:PrimaryAttack()
        local owner = self:GetOwner()
        if IsValid(self.bomb) then return end

        local tr = {}
        tr.start = owner:GetAttachment(owner:LookupAttachment("eyes")).Pos
        local dir = Vector(1,0,0)
        dir:Rotate(owner:EyeAngles())
        tr.endpos = tr.start + dir * 75
        tr.filter = owner

        local traceResult = util.TraceLine(tr)
        local ent = traceResult.Entity

        if not IsValid(ent) then
            ent = ents.Create("ent_ied_prop")
            ent:SetModel("models/props_junk/cardboard_box004a.mdl")

			ent:SetModelScale(0.5,0)

            ent:SetPos(traceResult.HitPos)
            ent:Spawn()
        end

        self:GetOwner().gg = true

        owner = ent
        self.bomb = owner
        ent.parentBomb = self
        ent.owner = self:GetOwner()
        ent:CallOnRemove("homigrad-bomb",Bomb)
        ent:EmitSound("buttons/button24.wav",75,50)
        self:SetNWBool("hasbomb",true)
    end

    function SWEP:SecondaryAttack()
        if not IsValid(self.bomb) then return end

        Bomb(self.bomb)
        self.bomb = nil
        self:Remove()
    end
else
    function SWEP:DrawWorldModel()
        local owner = self:GetOwner()

        if not IsValid(owner) then self:DrawModel() return end

        self.mdl = self.mdl or false
        if not IsValid(self.mdl) then
            self.mdl = ClientsideModel("models/props_junk/cardboard_jox004a.mdl")
            self.mdl:SetNoDraw(true)
            self.mdl:SetModelScale(0.35)
        end
        self:CallOnRemove("ModelRemoveHG",function() self.mdl:Remove() end)
        local matrix = self:GetOwner():GetBoneMatrix(11)
        if not matrix then return end

		self.mdl:SetModelScale(0.35)
        self.mdl:SetRenderOrigin(matrix:GetTranslation()+matrix:GetAngles():Forward()*3+matrix:GetAngles():Right()*3)
        self.mdl:SetRenderAngles(matrix:GetAngles())
        self.mdl:DrawModel()
    end
    function SWEP:DrawHUD()
        local owner = self.Owner
        local tr = {}
        tr.start = owner:GetAttachment(owner:LookupAttachment("eyes")).Pos
        local dir = Vector(1,0,0)
        dir:Rotate(owner:EyeAngles())
        tr.endpos = tr.start + dir * 75
        tr.filter = owner

        local traceResult = util.TraceLine(tr)
        local ent = traceResult.Entity

        if not IsValid(ent) then
            local hit = traceResult.Hit and 1 or 0
            local frac = traceResult.Fraction
            surface.SetDrawColor(Color(255, 255, 255, 255 * hit))
            draw.NoTexture()
            Circle(traceResult.HitPos:ToScreen().x, traceResult.HitPos:ToScreen().y, 5 / frac, 32)
        else
            local frac = traceResult.Fraction
            surface.SetDrawColor(Color(255, 255, 255, 255))
            draw.NoTexture()
            Circle(traceResult.HitPos:ToScreen().x, traceResult.HitPos:ToScreen().y, 5 / frac, 32)
            draw.DrawText( hg.GetPhrase("ied_plant").." "..tostring((util.GetSurfaceIndex(ent:GetBoneSurfaceProp(0)) == 3 or util.GetSurfaceIndex(ent:GetBoneSurfaceProp(0)) == 66) and hg.GetPhrase("ied_metalprop") or ""), "TargetID", traceResult.HitPos:ToScreen().x, traceResult.HitPos:ToScreen().y - 40, color_white, TEXT_ALIGN_CENTER )
        end
    end
end