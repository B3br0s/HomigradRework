if engine.ActiveGamemode() == "homigrad" then
    SWEP.Base = 'weapon_base' -- base
    SWEP.Author = "Homigrad"
    SWEP.PrintName = "IHomig X" 
    SWEP.WorldModel = "models/lt_c/tech/cellphone.mdl"
    SWEP.Instructions = "ЛКМ - Вызов 911                              ПКМ - Тапать хомяка"
    SWEP.ViewModel = "models/lt_c/tech/cellphone.mdl"
    SWEP.Spawnable = true
    SWEP.CanClick = true
    SWEP.HoldType = "revolver"

    SWEP.Secondary.ClipSize		= -1
    SWEP.Secondary.DefaultClip	= -1
    SWEP.Secondary.Automatic	= false
    SWEP.Secondary.Ammo			= "none"

    SWEP.Primary.ClipSize		= -1
    SWEP.Primary.DefaultClip	= -1
    SWEP.Primary.Automatic	= false
    SWEP.Primary.Ammo			= "none"

    function SWEP:PrimaryAttack()
        self:SetHoldType("pistol")
        if SERVER then
            if self.CanClick then
            self.CanClick = false
            self:EmitSound("again.mp3")
            timer.Simple(4,function ()
                self:GetOwner():ChatPrint("Вы вызвали 911")
                self:Remove()
                timer.Simple(15,function ()
                    RunConsoleCommand("say","!forcepolice")
                end)
            end)
        end
        else
            if self.CanClick then
                self.CanClick = false
            self:EmitSound("again.mp3")
            timer.Simple(6,function ()
                self:EmitSound("homigrad/radio/default/endvoice2.wav")
            end)
        end
        end
    end

    function SWEP:SecondaryAttack()
        self:SetHoldType("revolver")
        timer.Simple(0.2,function ()
            self:EmitSound("homigrad/radio/default/startvoice_pixel.wav")
            self:SetHoldType("pistol")
        end)
    end

    SWEP.dwmModeScale = 1
    SWEP.dwmForward = 4
    SWEP.dwmRight = 1.8
    SWEP.dwmUp = -3.6
    
    SWEP.dwmAUp = 20
    SWEP.dwmARight = 90
    SWEP.dwmAForward = 0
    local model 
    if CLIENT then
        model = GDrawWorldModel or ClientsideModel(SWEP.WorldModel,RENDER_GROUP_OPAQUE_ENTITY)
        GDrawWorldModel = model
        model:SetNoDraw(true)
    end
    if SERVER then
        function SWEP:GetPosAng()
            local owner = self:GetOwner()
            local Pos,Ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
            if not Pos then return end
            
            Pos:Add(Ang:Forward() * self.dwmForward)
            Pos:Add(Ang:Right() * self.dwmRight)
            Pos:Add(Ang:Up() * self.dwmUp)
    
    
            Ang:RotateAroundAxis(Ang:Up(),self.dwmAUp)
            Ang:RotateAroundAxis(Ang:Right(),self.dwmARight)
            Ang:RotateAroundAxis(Ang:Forward(),self.dwmAForward)
    
            return Pos,Ang
        end
    else
        function SWEP:SetPosAng(Pos,Ang)
            self.Pos = Pos
            self.Ang = Ang
        end
        function SWEP:GetPosAng()
            return self.Pos,self.Ang
        end
    end
    function SWEP:DrawWorldModel()
        local owner = self:GetOwner()
        if not IsValid(owner) then
            self:DrawModel()
    
            return
        end
    
        model:SetModel(self.WorldModel)
    
        local Pos,Ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
        if not Pos then return end
        
        Pos:Add(Ang:Forward() * self.dwmForward)
        Pos:Add(Ang:Right() * self.dwmRight)
        Pos:Add(Ang:Up() * self.dwmUp)
    
    
        Ang:RotateAroundAxis(Ang:Up(),self.dwmAUp)
        Ang:RotateAroundAxis(Ang:Right(),self.dwmARight)
        Ang:RotateAroundAxis(Ang:Forward(),self.dwmAForward)
        
        self:SetPosAng(Pos,Ang)
    
        model:SetPos(Pos)
        model:SetAngles(Ang)
    
        model:SetModelScale(self.dwmModeScale)
    
        model:DrawModel()
    end
    end