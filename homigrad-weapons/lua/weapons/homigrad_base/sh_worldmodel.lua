SWEP.WorldAng = Angle(0,0,0)
SWEP.WorldPos = Vector(0,0,0)

SWEP.HolsterAng = Angle(0,0,0)
SWEP.HolsterPos = Vector(0,0,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Pelvis"

//SWEP.LHandAng = Angle(0,0,0)
//SWEP.LHand = Vector(0,0,0)
//SWEP.RHandAng = Angle(0,0,0)
//SWEP.RHand = Vector(0,0,0)

SWEP.ClosePos = 0
SWEP.Isclose = false    

SWEP.DetailsDraw = {}

SWEP.Bodygroups = {}

local suicide_pist_ang = Angle(120,0,0)
local suicide_pist_pos = Vector(-25,-2,-1.5)

local suicide_rifle_ang = Angle(100,0,0)
local suicide_rifle_pos = Vector(-40,-4.35,-0.5)

SWEP.speed = 0

function SWEP:WorldModel_Transform(nomod)
    local ply = self:GetOwner()

    if ply:GetNWBool("otrub") /*or !self.Deployed*/ then
        local pos,ang = self:WorldModel_Holster_Transform()
        return pos,ang
    end

    //if IsValid(self.worldModel) and ply:GetActiveWeapon() != self then 
    //    return self:WorldModel_Holster_Transform()
    //end

    if IsValid(self.worldModel) and ply:GetActiveWeapon() == self then
        self.worldModel:SetNoDraw(false)
        self.worldModel.NoRender = false

        if CLIENT then
            if self.Bodygroups then
	            for k, v in ipairs(self.Bodygroups) do
	                self.worldModel:SetBodygroup(k, v)
	            end
	        end

            if self.Skin then
                self.worldModel:SetSkin(self.Skin)
            end
        end
    end

    if !IsValid(ply) then
        return
    end

    local ent = hg.GetCurrentCharacter(ply)

    local r_hand_index = (self.SupportTPIK and ply:LookupBone("ValveBiped.Bip01_Head1") or ply:LookupBone("ValveBiped.Bip01_R_Hand"))

    if !IsValid(ent) then
        return  
    end

    local mat = ent:GetBoneMatrix(r_hand_index)

    if !mat then
        return
    end

    local zapasnoy_plan = hg.eyeTrace(ply)

    local Pos = mat:GetTranslation() or zapasnoy_plan.StartPos// + (ply:EyeAngles().p > 0 and ply:EyeAngles():Up() * 5 or Vector())
    local Ang = ply:EyeAngles()

    local isclose = self.Isclose

    local closepos = (isclose and Ang:Forward() * self.ClosePos or Vector(0,0,0))
    
    Pos = Pos - closepos

    if CLIENT then
        //print(ply.prev_wep_ang)
        ply.prev_wep_ang = LerpAngleFT(0.015,ply.prev_wep_ang or self.DWorldAng,self.WorldAng)
        ply.prev_wep_pos = LerpVectorFT(0.015,ply.prev_wep_pos or self.DWorldPos,self.WorldPos)
    else
        ply.prev_wep_ang = self.WorldAng
        ply.prev_wep_pos = self.WorldPos
    end

    //if self.Deploye then
        Ang:RotateAroundAxis(Ang:Right(),ply.prev_wep_ang[1])
        Ang:RotateAroundAxis(Ang:Up(),ply.prev_wep_ang[2])
        Ang:RotateAroundAxis(Ang:Forward(),ply.prev_wep_ang[3])
    //end

    if !ply:GetNWBool("suiciding") then
        //ply.prev_wep_ang = LerpAngleFT((self:IsSighted() and 0.2 or 0.04),ply.prev_wep_ang,Ang)
    else
        Ang.p = 0
        
        local sangs = self:IsPistolHoldType() and suicide_pist_ang or suicide_rifle_ang
        local spos = self:IsPistolHoldType() and suicide_pist_pos or suicide_rifle_pos

        Ang:RotateAroundAxis(Ang:Right(),sangs[1])
        Ang:RotateAroundAxis(Ang:Up(),sangs[2])
        Ang:RotateAroundAxis(Ang:Forward(),sangs[3])

        Pos = Pos + Ang:Forward() * spos[1]
        Pos = Pos + Ang:Right() * spos[2]
        Pos = Pos + Ang:Up() * spos[3]
    end

    if !ply:GetNWBool("suiciding") then
        Pos = Pos + Ang:Forward() * ply.prev_wep_pos[1]
        Pos = Pos + Ang:Right() * ply.prev_wep_pos[2]
        Pos = Pos + Ang:Up() * ply.prev_wep_pos[3]
    end

    //self:DrawAttachments()

    local model = self.worldModel

    local final_ang = Ang
    local final_pos = Pos

    if IsValid(model) and !nomod then
        model:SetPos(Pos)
        model:SetAngles(Ang)
        model:SetParent(ent)
        local speed_pos = (self:IsPistolHoldType() or self:GetRunAnim()) and (vector_up * (6 * self.speed)) - Ang:Forward() * (-4 * self.speed) or (Ang:Forward() * 2 + Ang:Right() * -8 + Ang:Up() * 0) * self.speed
        local speed_ang = (self:IsPistolHoldType() or self:GetRunAnim()) and Angle(30 * self.speed,0 * self.speed,0) or Angle(-20,-40,0) * self.speed

        //ply.prev_wep_ang[1] = ply.prev_wep_ang[1] * (1 - self.speed)

        Ang[1] = Ang[1] * (1 - self.speed)

        model:SetRenderOrigin((Pos - speed_pos) - vector_up * (8 * self.speed))
        model:SetRenderAngles(Ang - speed_ang - Angle(2 * (self:IsLocal() and vis_recoil or 0)))

        final_ang = Ang - speed_ang //- Angle(2 * (self:IsLocal() and vis_recoil or 0))
        final_pos = (Pos - speed_pos) - vector_up * (8 * self.speed)
    end

    if self.Details and CLIENT then
        self:WorldModel_Details()
    end

    return final_pos,final_ang
end

function SWEP:WorldModel_Details()
    for _, detail in ipairs(self.Details) do
        if !IsValid(self.DetailsDraw[_]) then
            self.DetailsDraw[_] = ClientsideModel(detail.Model)

            self.DetailsDraw[_]:SetupBones(true)

            //self:CallOnRemove("remove_det",function(
            //    self.DetailsDraw[_]:Remove()
            //    self.DetailsDraw[_] = nil
            //end))

            //hg.SetupModel(self,self.worldModel)
        else
            //hg.SetupModel(self,self.worldModel)

            if !detail.Bone then
                continue 
            end

            local id = self.worldModel:LookupBone(detail.Bone)

            if !id then
                continue 
            end

            local mat = self.worldModel:GetBoneMatrix(id)

            if !mat then
                continue 
            end

            local ang = mat:GetAngles()
            local pos = mat:GetTranslation()

            ang:RotateAroundAxis(ang:Right(),detail.Ang[1])
            ang:RotateAroundAxis(ang:Up(),detail.Ang[2])
            ang:RotateAroundAxis(ang:Forward(),detail.Ang[3])

            pos = pos + ang:Forward() * detail.Pos[1]
            pos = pos + ang:Right() * detail.Pos[2]
            pos = pos + ang:Up() * detail.Pos[3]

            self.DetailsDraw[_]:SetPredictable(true)

            self.DetailsDraw[_]:SetAngles(ang)
            self.DetailsDraw[_]:SetPos(pos)
        end
    end
end

function SWEP:WorldModel_Holster_Transform(nomod)
    local ply = self:GetOwner()

    if self:GetNWBool("DontShow") then
        if IsValid(self.worldModel) then
            self.worldModel:SetNoDraw(true)
            self.worldModel.NoRender = true
        end
        return
    end

    if !IsValid(ply) then
        return
    end

    local ent = hg.GetCurrentCharacter(ply)

    if !IsValid(ent) then
        return
    end

    local index = ent:LookupBone(self.HolsterBone)

    local mat = ent:GetBoneMatrix(index)

    if !mat then
        return
    end

    local Pos = mat:GetTranslation()
    local Ang = mat:GetAngles()

    Ang:RotateAroundAxis(Ang:Right(),self.HolsterAng[1])
    Ang:RotateAroundAxis(Ang:Up(),self.HolsterAng[2])
    Ang:RotateAroundAxis(Ang:Forward(),self.HolsterAng[3])

    Pos = Pos + Ang:Forward() * self.HolsterPos[1]
    Pos = Pos + Ang:Right() * self.HolsterPos[2]
    Pos = Pos + Ang:Up() * self.HolsterPos[3]

    local model = self.worldModel

    if IsValid(model) and !nomod then
        model.IsIcon = true

        model:SetPos(Pos)
        model:SetAngles(Ang)

        model:SetRenderOrigin(Pos)
        model:SetRenderAngles(Ang)

        //ply.prev_wep_ang = Ang
    end

    return Pos,Ang
end

function SWEP:GetWM()
    if IsValid(self.worldModel) then
        return self.worldModel
    else
        self:CreateWorldModel()
        return self.worldModel
    end
end

function SWEP:GetRunAnim()
    if self.PistolRun then
        return true
    else
        return false
    end
end

function SWEP:CreateWorldModel()
    self.worldModel = ClientsideModel(self.WorldModelReal or self.WorldModel)

    local wm = self.worldModel

    self:CallOnRemove("zaebal_remove",function()
        wm:Remove()
    end)

    table.insert(hg.csm,wm)
end

function SWEP:DrawWorldModel()
    local ply = self:GetOwner()

    if !IsValid(ply) then
        self:DrawModel()

        if self.Skin then
            self:SetSkin(self.Skin)
        end

        if self.Bodygroups then
	        for k, v in ipairs(self.Bodygroups) do
	            self:SetBodygroup(k, v)
	        end
	    end

        return
    else
        if not IsValid(self.worldModel) then
            self:CreateWorldModel()
            return
        end

        self:WorldModel_Transform()

        if IsValid(self.worldModel) then
            //self.worldModel:DrawModel()
        end

        if self.Details and CLIENT then
            //self:WorldModel_Details()
        end
    end
end

if CLIENT then
    concommand.Add("wm_getbones",function(ply)
        local self = ply:GetActiveWeapon()
        if self.worldModel then
            for boneID = 0, self.worldModel:GetBoneCount() - 1 do
                local boneName = self.worldModel:GetBoneName(boneID)
                print(boneName)
            end
        else
            for boneID = 0, self:GetBoneCount() - 1 do
                local boneName = self:GetBoneName(boneID)
                print(boneName)
            end
        end
    end)

    concommand.Add("wm_getsequence",function(ply)
        local self = ply:GetActiveWeapon()
        if self.worldModel then
            PrintTable(self.worldModel:GetSequenceList())
        else
            PrintTable(self:GetSequenceList())
        end
    end)

    concommand.Add("wm_getbg",function(ply)
        local self = hg.eyeTrace(ply,200).Entity

        for _, bg in ipairs(self:GetBodyGroups()) do
            print(_,bg)
            PrintTable(bg)
        end
    end)

    concommand.Add("wm_getmat",function(ply)
        local self = hg.eyeTrace(ply,200).Entity

        for _, bg in ipairs(self:GetMaterials()) do
            print(bg)
        end
    end)

    concommand.Add("wm_setbgs",function(ply,cmd,arg)
        local self = hg.eyeTrace(ply,200).Entity

        self:SetBodyGroups(arg[1])
    end)
end