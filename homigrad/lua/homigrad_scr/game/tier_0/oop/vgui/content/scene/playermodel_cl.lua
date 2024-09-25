local PANEL = oop.Reg("v_playermodel","v_scene")
if not PANEL then return end

VGUIPlayerModel = {}

PANEL:Event_Add("Init","PlayerModel",function(self)
    self.fovMin = 7
    self.fovMax = 20

    self.cameraFOV = self.fovMax

    self.cameraAng = Angle(0,180,0)
    self.cameraPos = Vector(125,0,35)

    self.znear = 1

    VGUIPlayerModel[self] = true
end)

PANEL:Event_Add("Remove","Remove Link VGUI",function(self)
    VGUIPlayerModel[self] = nil
end)

function PANEL:SetPlayer(ply)
    if IsValid(self.mdl) then self.mdl:Remove() end
    
    local mdl = ClientsideModel(ply:GetModel(),RENDERGROUP_OTHER)
    mdl.GetPlayerColor = function() return ply:GetPlayerColor() end
    mdl:ResetSequence(mdl:LookupSequence("walk_all"))
    mdl:SetIK(false)

    mdl:SetSkin(ply:GetSkin())

	for k,v in pairs(ply:GetBodyGroups()) do
		mdl:SetBodygroup(v.id,ply:GetBodygroup(v.id))
	end

    self.mdl = mdl
    self.ply = ply

    self:InsertInScene(mdl)

    hook.Run("VGUIPlayerModel Set Player",self,ply)

    return mdl
end

local DrawModel = ClientsideModel("models/hunter/plates/plate.mdl",RENDER_GROUP_OPAQUE_ENTITY)
DrawModel:SetNoDraw(true)

function PANEL:Draw(w,h)
    FORCEDRAW = DrawModel
    local mdl = self.mdl
    
    local vec = self.ply:Eye()
    mdl:SetEyeTarget(vec)

    self:OpenScene(w,h)
    self:DrawObjects()
    hook.Run("PostPlayerDraw VGUI",self.ply,mdl)
    self:CloseScene()

    FORCEDRAW = nil
end

function PANEL:OnWheel(wheel)
    if input.IsButtonDown(KEY_LSHIFT) then
        self.cameraFOV = math.Clamp(self.cameraFOV - wheel * 2,self.fovMin,self.fovMax)
    else
        self.cameraPos[3] = self.cameraPos[3] + wheel * 5
    end
end

function PANEL:Step()
    if self.mouse[MOUSE_RIGHT] then
        local mdl = self.mdl
        local ang = mdl:GetAngles()
        ang[2] = ang[2] - mousedx
        ang:Normalize()

        mdl:SetAngles(ang)
    end
end