-- sh_attachment.lua"

AddCSLuaFile()
local angFull = Angle(-30, 30, 30)
local angZero = Angle(0, 0, 0)
hg.attachments = hg.attachments or {}
SWEP.availableAttachments = {}
local hg_random_atts = ConVarExists("hg_random_atts") and GetConVar("hg_random_atts") or CreateConVar("hg_random_atts", 0, FCVAR_SERVER_CAN_EXECUTE, "", 0, 1)
function SWEP:ClearAttachments(randomAttachments)
	self.attachments = {
		barrel = {},
		sight = {},
		mount = {},
		grip = {},
		underbarrel = {},
		magwell = {},
	}

	if SERVER then
		if hg_random_atts:GetBool() or randomAttachments then
			self.attachments.barrel = self.availableAttachments.barrel and table.Random(self.availableAttachments.barrel) or self.attachments.barrel
			if self.availableAttachments.sight then
				for att, attdata in RandomPairs(hg.attachments.sight) do
					local tbl = self.availableAttachments.sight.mountType
					if attdata.mountType == (istable(tbl) and tbl[1] or tbl) then
						self.attachments.sight = {att, {}}
						break
					end
				end
			end

			if self.availableAttachments.grip then
				for att, attdata in RandomPairs(hg.attachments.grip) do
					local tbl = self.availableAttachments.grip.mountType
					if attdata.mountType == (istable(tbl) and tbl[1] or tbl) then
						self.attachments.grip = {att, {}}
						break
					end
				end
			end

			if self.availableAttachments.underbarrel then
				for att, attdata in RandomPairs(hg.attachments.underbarrel) do
					local tbl = self.availableAttachments.underbarrel.mountType
					if attdata.mountType == (istable(tbl) and tbl[1] or tbl) then
						self.attachments.underbarrel = {att, {}}
						break
					end
				end
			end
		end

		if self.attachments and table.IsEmpty(self.attachments.barrel) then self.attachments.barrel = self.availableAttachments.barrel and self.availableAttachments.barrel["empty"] or {} end
		if self.attachments and table.IsEmpty(self.attachments.sight) then self.attachments.sight = self.availableAttachments.sight and self.availableAttachments.sight["empty"] or {} end
		if self.attachments and table.IsEmpty(self.attachments.mount) then self.attachments.mount = self.availableAttachments.mount and self.availableAttachments.mount["empty"] or {} end
	end

	if SERVER then timer.Simple(0.1, function() if IsValid(self) then self:SyncAtts() end end) end
	self:CallOnRemove("removeAtt", function()
		self.attachments = nil
		if self.modelAtt then
			for atta, model in pairs(self.modelAtt) do
				if not atta then continue end
				if IsValid(model) then model:Remove() end
				self.modelAtt[atta] = nil
			end
		end
	end)
end

function SWEP:HasAttachment(whereabouts, attachment)
	local has = self.attachments[whereabouts]
	if !istable(has) then return end
	if not has or table.IsEmpty(has) then return false end
	if attachment then
		has = string.find(has[1], attachment) and true
	else
		has = has[1] ~= "empty"
	end
	return has and self.attachments[whereabouts], has and hg.attachments[whereabouts][attachment or self.attachments[whereabouts][1]]
end

function SWEP:AttachmentsSetup()
end

function SWEP:ThinkAtt()
end

local colBlackTransparent = Color(0, 0, 0, 125)
local angZero = Angle(0, 0, 0)
local vecZero = Vector(0, 0, 0)
function SWEP:ThinkAtt()
	if true then return end
	if SERVER then return end
	local att = self:GetMuzzleAtt()
	local owner = self:GetOwner()
	if not self:IsLocal() then return end
end

if CLIENT then
	local function attachmentMenu()
		RunConsoleCommand("hg_get_attachments", 0)
	end

	local function dropAttachmentMenu()
		RunConsoleCommand("hg_get_attachments", 1)
	end

	hook.Add("radialOptions", "attachments", function()
		if not LocalPlayer().otrub then
			local tbl = {attachmentMenu, "Attachments Menu"}
			hg.radialOptions[#hg.radialOptions + 1] = tbl
		end
	end)
else
	if hg.weapons then
		for self in pairs(hg.weapons) do
			if not IsValid(self) then return end
			self:SyncAtts()
		end
	end
end

local angZero = Angle(0, 0, 0)
local vecZero = Vector(0, 0, 0)
local hg_attachment_draw_distance = ConVarExists("hg_attachment_draw_distance") and GetConVar("hg_attachment_draw_distance") or CreateClientConVar("hg_attachment_draw_distance", 0, true, nil, "distance to draw attachments", 0, 4096)
function SWEP:DrawAttachments()
	local gun = self:GetWeaponEntity()
	local att = self:GetMuzzleAtt(gun, true)
	if not att then return end
	if not self.attachments and CLIENT then
		self:SyncAtts()
		return
	end

	self.Supressor = (self:HasAttachment("barrel", "supressor") and true) or self.SetSupressor
	local magwell, magwellData = self:HasAttachment("magwell")
	if magwellData then
		self.Primary.ClipSize = magwellData.capacity
	else
		self.Primary.ClipSize = self.Primary.ClipSize2 or self.Primary.ClipSize
	end

	if SERVER then return end
	if self.availableAttachments.mount then
		if self:HasAttachment("sight") then
			local data = hg.attachments.sight[self.attachments.sight[1]]
			self.attachments.mount = self.availableAttachments.mount[data.mountType]
		end
	end

	local owner = self:GetOwner()
	self.modelAtt = self.modelAtt or {}
	for atta, curAtt in pairs(self.attachments) do
		local dontDraw = owner ~= LocalPlayer() and hg_attachment_draw_distance:GetInt() ~= 0 and hg_attachment_draw_distance:GetInt() < LocalPlayer():GetPos():Distance(self:GetPos())
		if not curAtt or (istable(curAtt) and table.IsEmpty(curAtt)) then continue end
		local attachmentData = hg.attachments[atta][curAtt[1]]
		dontDraw = atta ~= "underbarrel" and dontDraw or false
		if curAtt and attachmentData[2] ~= "" then
			self.modelAtt[atta] = self.modelAtt[atta] or ClientsideModel(attachmentData[2])
			if not dontDraw then
				local model = self.modelAtt[atta]
				if not IsValid(model) then continue end
				local pos2 = att.Pos
				vecZero:Zero()
				local pos = vecZero
				if isvector(curAtt[2]) then pos:Add(curAtt[2]) end
				if self.availableAttachments[atta]["mount"] then
					pos:Add(self.availableAttachments[atta]["mount"] or vector_origin)
				end
				
				if attachmentData.offset then
					pos:Add(attachmentData.offset or vector_origin)
				end

				local addAng = attachmentData[3] + (self.availableAttachments[atta]["mountAngle"] or angZero)
				pos:Rotate(att.Ang)
				pos:Add(att.Pos)
				local _, ang = LocalToWorld(vecZero, addAng, vecZero, att.Ang)
				model:SetRenderOrigin(pos)
				model:SetRenderAngles(ang)
				model:SetupBones()
				
				model:SetModelScale(attachmentData.modelscale or 1)

				if IsValid(gun) and not gun:GetNoDraw() then model:DrawModel() end
				model:SetNoDraw(IsValid(gun) and gun:GetNoDraw())
				if attachmentData[4] and not table.IsEmpty(attachmentData[4]) then
					for index, mat in pairs(attachmentData[4]) do
						local submat = model:GetSubMaterial(index)
						submat = #submat > 0 and submat or model:GetMaterials()[index]
						if submat ~= mat then model:SetSubMaterial(index, mat or "null") end
					end
				end

				if attachmentData.mount then
					self.modelAtt["mountex"] = self.modelAtt["mountex"] or ClientsideModel(attachmentData.mount)
					local mount = self.modelAtt["mountex"]
					local pos = vecZero
					pos:Set(attachmentData.mountVec)
					pos:Rotate(model:GetAngles())
					pos:Add(model:GetPos())
					local _, ang = LocalToWorld(vecZero, attachmentData.mountAng, vecZero, model:GetAngles())
					mount:SetRenderOrigin(pos)
					mount:SetRenderAngles(ang)
					mount:SetupBones()
					mount:DrawModel()
					mount:SetNoDraw(gun:GetNoDraw())
				end
			else
				if IsValid(self.modelAtt[atta]) then
					self.modelAtt[atta]:Remove()
					self.modelAtt[atta] = nil
				end
			end
		end

		local tblhuy = (not self:HasAttachment("sight")) and curAtt[2] or self.availableAttachments.sight["removehuy"]
		if istable(tblhuy) and not table.IsEmpty(tblhuy) then
			for index, mat in pairs(tblhuy) do
				local submat = gun:GetSubMaterial(index)
				--submat = #submat > 0 and submat or gun:GetMaterials()[index]
				if submat ~= mat then gun:SetSubMaterial(index, mat or "null") end
			end
		end

		hg.attachmentFunc(self, attachmentData)
	end
end

function hg.DrawAttachments_Ex(class, gun, owner, atts, self)
	local att = self:GetMuzzleAtt(gun, true)
	if not att or not atts or not IsValid(owner) then return end
	if self.availableAttachments.mount then
		if not table.IsEmpty(atts.sight) then
			local data = hg.attachments.sight[atts.sight[1]]
			atts.mount = self.availableAttachments.mount[data.mountType]
		end
	end

	gun.modelAtt = gun.modelAtt or {}
	for atta, curAtt in pairs(atts) do
		local dontDraw = owner ~= LocalPlayer() and hg_attachment_draw_distance:GetInt() ~= 0 and hg_attachment_draw_distance:GetInt() < LocalPlayer():GetPos():Distance(gun:GetPos())
		if not curAtt or (istable(curAtt) and table.IsEmpty(curAtt)) then continue end
		local attachmentData = hg.attachments[atta][curAtt[1]]
		dontDraw = atta ~= "underbarrel" and dontDraw or false
		if curAtt and attachmentData[2] ~= "" then
			gun.modelAtt[atta] = gun.modelAtt[atta] or ClientsideModel(attachmentData[2])
			if not dontDraw then
				local model = gun.modelAtt[atta]
				local pos2 = att.Pos
				vecZero:Zero()
				local pos = vecZero
				if isvector(curAtt[2]) then pos:Add(curAtt[2]) end

				if self.availableAttachments[atta]["mount"] then
					pos:Add(self.availableAttachments[atta]["mount"] or vector_origin)
				end

				if attachmentData.offset then
					pos:Add(attachmentData.offset or vector_origin)
				end

				local addAng = attachmentData[3] + (self.availableAttachments[atta]["mountAngle"] or angZero)
				pos:Rotate(att.Ang)
				pos:Add(att.Pos)
				local _, ang = LocalToWorld(vecZero, addAng, vecZero, att.Ang)
				model:SetRenderOrigin(pos)
				model:SetRenderAngles(ang)
				model:SetupBones()
				if IsValid(gun) and not gun:GetNoDraw() then model:DrawModel() end
				model:SetNoDraw(IsValid(gun) and gun:GetNoDraw())
				if attachmentData[4] and not table.IsEmpty(attachmentData[4]) then
					for index, mat in pairs(attachmentData[4]) do
						local submat = model:GetSubMaterial(index)
						submat = #submat > 0 and submat or model:GetMaterials()[index]
						if submat ~= mat then model:SetSubMaterial(index, mat or "null") end
					end
				end

				if attachmentData.mount then
					gun.modelAtt["mountex"] = gun.modelAtt["mountex"] or ClientsideModel(attachmentData.mount)
					local mount = gun.modelAtt["mountex"]
					local pos = vecZero
					pos:Set(attachmentData.mountVec)
					pos:Rotate(model:GetAngles())
					pos:Add(model:GetPos())
					local _, ang = LocalToWorld(vecZero, attachmentData.mountAng, vecZero, model:GetAngles())
					mount:SetRenderOrigin(pos)
					mount:SetRenderAngles(ang)
					mount:SetupBones()
					mount:DrawModel()
					mount:SetNoDraw(model:GetNoDraw())
				end
			else
				if IsValid(gun.modelAtt[atta]) then
					gun.modelAtt[atta]:Remove()
					gun.modelAtt[atta] = nil
				end
			end
		end

		local tblhuy = (atts.sight[1] == "empty" or table.IsEmpty(atts.sight)) and curAtt[2] or self.availableAttachments.sight["removehuy"]
		if istable(tblhuy) and not table.IsEmpty(tblhuy) then
			for index, mat in pairs(tblhuy) do
				local submat = gun:GetSubMaterial(index)
				submat = #submat > 0 and submat or gun:GetMaterials()[index]
				if submat ~= mat then gun:SetSubMaterial(index, mat or "null") end
			end
		end
	end
end

if SERVER then
	util.AddNetworkString("hmcd_togglelaser")
	local laserThingies = {
		[0] = 1,
		[1] = 0,
		[2] = 3,
		[3] = 2,
	}

	concommand.Add("hmcd_togglelaser", function(ply, cmd, args)
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or not wep.attachments then return end
		wep.lasertoggle = laserThingies[wep.lasertoggle or 0]
		ply:EmitSound("nvg/nvg_off2.wav", 65)
		net.Start("hmcd_togglelaser")
		net.WriteEntity(wep)
		net.WriteInt(wep.lasertoggle, 5)
		net.Broadcast()
	end)

	local flashlightThingies = {
		[0] = 2,
		[2] = 0,
		[1] = 3,
		[3] = 1,
	}

	hook.Add("PlayerSwitchFlashlight", "flashlightHuy", function(ply)
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or not wep.attachments then return end
		wep.lasertoggle = flashlightThingies[wep.lasertoggle or 0]
		ply:EmitSound("nvg/nvg_off2.wav", 65)
		net.Start("hmcd_togglelaser")
		net.WriteEntity(wep)
		net.WriteInt(wep.lasertoggle, 5)
		net.Broadcast()
		return false
	end)
else
	net.Receive("hmcd_togglelaser", function()
		local wep = net.ReadEntity()
		local turn = net.ReadInt(5)
		wep.lasertoggle = turn
	end)
end

if CLIENT then
	local function removeFlashlights(self)
		if self.flashlight and self.flashlight:IsValid() then
			self.flashlight:Remove()
			self.flashlight = nil
		end
	end

	local vecZero, angZero = Vector(0, 0, 0), Angle(0, 0, 0)
	local mat = Material("sprites/rollermine_shock")
	local mat2 = Material("sprites/light_glow02_add")
	local mat3 = Material("effects/flashlight/soft")
	local mat4 = Material("sprites/glow04_noz", "alphatest")
	function SWEP:DrawLaser()
		local laser = self.attachments.underbarrel
		if not laser or table.IsEmpty(laser) and not self.laser then return end
		local attachmentData
		if laser and not table.IsEmpty(laser) then
			attachmentData = hg.attachments.underbarrel[laser[1]]
		else
			attachmentData = self.laserData
		end

		if not self.modelAtt then
			self.modelAtt = {}
			return
		end

		local model = self.modelAtt["underbarrel"] or self:GetWeaponEntity()
		if not IsValid(model) then return end
		local pos, ang = model:GetPos(), model:GetAngles()
		local pos, _ = LocalToWorld(attachmentData.offsetPos or vecZero, angZero, pos, ang)
		local tr = util.TraceLine({
			start = pos,
			endpos = pos + ang:Forward() * 9999,
			filter = {self, self:GetOwner(), self:GetWeaponEntity(), model},
			mask = MASK_SHOT,
		})

		if (self.lasertoggle == 2 or self.lasertoggle == 3) and attachmentData.supportFlashlight then
			self.flashlight = self.flashlight or ProjectedTexture()
			if self.flashlight and self.flashlight:IsValid() then
				self.flashlight:SetTexture((attachmentData.mat or mat3):GetTexture("$basetexture"))
				self.flashlight:SetFarZ(attachmentData.farZ or 1500)
				self.flashlight:SetHorizontalFOV(attachmentData.size or 50)
				self.flashlight:SetVerticalFOV(attachmentData.size or 50)
				self.flashlight:SetConstantAttenuation(attachmentData.brightness2 or 1)
				self.flashlight:SetLinearAttenuation(attachmentData.brightness or 50)
				self.flashlight:SetPos(pos)
				self.flashlight:SetAngles(ang)
				self.flashlight:Update()
				render.SetMaterial(mat4)
				local view = render.GetViewSetup(true)
				render.DrawSprite(pos + ang:Forward(), 50 * math.min(ang:Forward():Dot(view.angles:Forward()), 0), 50 * math.min(ang:Forward():Dot(view.angles:Forward())), color_white)
			end
		else
			removeFlashlights(self)
		end

		if self.lasertoggle == 1 or self.lasertoggle == 3 then
			render.SetMaterial(mat)
			render.DrawBeam(pos, tr.HitPos, 0.75, 0, 800, attachmentData.color)
			render.SetMaterial(mat2)
			render.DrawSprite(tr.HitPos, 5, 5, attachmentData.color)
		end
	end
end

if SERVER then
	util.AddNetworkString("hg_add_attachment")
	util.AddNetworkString("hg_remove_attachment")
	util.AddNetworkString("hg_drop_attachment")
	net.Receive("hg_add_attachment", function(len, ply)
		local att = net.ReadString()
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or not wep.attachments then return end
		if not table.HasValue(ply.inventory.Attachments, att) then return end
		local placement = nil
		for plc, tbl in pairs(hg.attachments) do
			placement = tbl[att] and tbl[att][1] or placement
		end

		if not placement then return end
		if not (table.IsEmpty(wep.attachments[placement]) or wep.attachments[placement][1] == "empty") then
			ply:ChatPrint("There is no space for this attachment.")
			return
		end

		--if not wep.availableAttachments[placement] then return end
		local i
		if wep.availableAttachments[placement] then
			for n, atta in pairs(wep.availableAttachments[placement]) do
				i = atta[1] == att and n or i
			end
		end

		--if not i then ply:ChatPrint("You cant place this attachment on this weapon.") return end
		local mountType = wep.availableAttachments[placement] and wep.availableAttachments[placement]["mountType"]
		local mountType2 = hg.attachments[placement][att].mountType
		if not wep.availableAttachments[placement] then return end
		if not wep.availableAttachments[placement][i] and (not wep.availableAttachments[placement][i] and ((not mountType) or (not mountType2))) then return end
		local mounts = istable(mountType) and table.HasValue(mountType, hg.attachments[placement][att].mountType) or mountType == mountType2
		if not mounts then
			ply:ChatPrint("You cant place this attachment on this weapon.")
			return
		end

		table.RemoveByValue(ply.inventory.Attachments, att)
		wep.attachments[placement] = i and wep.availableAttachments[placement][i] or {att, {}}
		wep:SyncAtts()
	end)

	net.Receive("hg_remove_attachment", function(len, ply)
		local att = net.ReadString()
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or not wep.attachments then return end
		if table.HasValue(ply.inventory.Attachments, att) then
			ply:ChatPrint("You already have that attachment.")
			return
		end

		local placement = nil
		for plc, tbl in pairs(hg.attachments) do
			placement = tbl[att] and tbl[att][1] or placement
		end

		if not placement then return end
		if not wep.attachments[placement][1] == att then return end
		if table.IsEmpty(wep.attachments[placement]) or wep.attachments[placement][1] == "empty" then return end
		ply.inventory.Attachments[#ply.inventory.Attachments + 1] = att
		local i
		for n, atta in pairs(wep.availableAttachments[placement]) do
			i = atta[1] == "empty" and n or i
		end

		wep.attachments[placement] = wep.availableAttachments[placement][i] or {}
		wep:SyncAtts()
	end)

	net.Receive("hg_drop_attachment", function(len, ply)
		local att = net.ReadString()
		local placement = nil
		for plc, tbl in pairs(hg.attachments) do
			placement = tbl[att] and tbl[att][1] or placement
		end

		if not placement then return end
		if hg.attachments[placement][att] then
			local attEnt = ents.Create("ent_att_" .. att)
			attEnt:Spawn()
			attEnt:SetPos(ply:EyePos())
			attEnt:SetAngles(ply:EyeAngles())
			local phys = attEnt:GetPhysicsObject()
			if IsValid(phys) then phys:SetVelocity(ply:EyeAngles():Forward() * 100) end
			if IsValid(attEnt) then table.RemoveByValue(ply.inventory.Attachments, att) end
			ply:SyncAtts()
		end
	end)
end

if SERVER then
	util.AddNetworkString("sync_atts")
	util.AddNetworkString("sync_atts_ply")
	local PLAYER = FindMetaTable("Player")
	function SWEP:SyncAtts(ply)
		net.Start("sync_atts")
		net.WriteEntity(self)
		net.WriteTable(self.attachments or {})
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end

	function PLAYER:SyncAtts()
		net.Start("sync_atts_ply")
		net.WriteEntity(self)
		net.WriteTable(self.inventory.Attachments)
		net.Broadcast()
	end

	net.Receive("sync_atts", function(len, ply)
		local self = net.ReadEntity()
		net.Start("sync_atts")
		net.WriteEntity(self)
		net.WriteTable(self.attachments)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end)
else
	function SWEP:SyncAtts()
		net.Start("sync_atts")
		net.WriteEntity(self)
		net.SendToServer()
	end
end

if CLIENT then
	concommand.Add("hg_add_attachment", function(ply, cmd, args)
		local att = args[1]
		net.Start("hg_add_attachment")
		net.WriteString(att)
		net.SendToServer()
	end)

	local function addAttachment(att)
		RunConsoleCommand("hg_add_attachment", att)
	end

	concommand.Add("hg_remove_attachment", function(ply, cmd, args)
		local att = args[1]
		net.Start("hg_remove_attachment")
		net.WriteString(att)
		net.SendToServer()
	end)

	local function dropAttachment(att)
		RunConsoleCommand("hg_drop_attachment", att)
	end

	local function removeAttachment(att)
		RunConsoleCommand("hg_remove_attachment", att)
	end

	local plyAttachments = {}
	local weaponAttachments = {}
	local drop = false
	local gray = Color(200, 200, 200)
	local red = Color(75,25,25)
	local redselected = Color(150,0,0)
	local blue = Color(200, 200, 255)
	local black = Color(24,24,24)
	local whitey = Color(255, 255, 255)
	local menuPanel
	local chosen2

	local blurMat = Material("pp/blurscreen")
    local Dynamic = 0
	local function BlurBackground(panel)
		if not (IsValid(panel) and panel:IsVisible()) then return end
        local layers, density, alpha = 1, 1, 155
        local x, y = panel:LocalToScreen(0, 0)
        surface.SetDrawColor(255, 255, 255, alpha)
        surface.SetMaterial(blurMat)
        local FrameRate, Num, Dark = 1 / FrameTime(), 5, 190

        for i = 1, Num do
            blurMat:SetFloat("$blur", (i / layers) * density * Dynamic)
            blurMat:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
        end

        surface.SetDrawColor(0, 0, 0, Dark * Dynamic)
        surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
        Dynamic = math.Clamp(Dynamic + (1 / FrameRate) * 7, 0, 1)
	end
	
	local function CreateMenu()
		Dynamic = 0
		local sizeX, sizeY = ScrW() / 6, 100 + math.Clamp((#plyAttachments + #weaponAttachments) * 60,60,260)
		gray.a = 255
		blue.a = 255
		if IsValid(menuPanel) then
			menuPanel:Remove()
			menuPanel = nil
		end

		local onwep
		menuPanel = vgui.Create("DFrame")
		menuPanel:SetTitle("Attachments menu")
		menuPanel:SetPos(ScrW() / 2 - sizeX / 2, ScrH() / 2 - sizeY / 2)
		menuPanel:SetSize(sizeX, sizeY)
		menuPanel:MakePopup()
		menuPanel:SetKeyBoardInputEnabled(false)
		function menuPanel:Paint( w, h)
			draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 0, 0, 0, 140) )
            BlurBackground(menuPanel)
            surface.SetDrawColor( 255, 0, 0, 128)
            surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
		end

		local attachmentPanel = vgui.Create("DCategoryList", menuPanel)
		attachmentPanel:Dock(FILL)
		function attachmentPanel:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 140) )
		end
		local atts = attachmentPanel:Add("Attachments")
		function atts:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 44, 0, 0, 140) )
		end
		local chosen
		local add
		for i, att in pairs(plyAttachments) do
			local button = atts:Add("")
			button:SetSize(0,25)
			button:DockMargin(0,0,0,2.5)
			if chosen2 and chosen2[1] == i and chosen2[2] then
				chosen = button
				add = true
			end

			button.att = att
			button.DoClick = function()
				chosen = button
				chosen2 = {i, true}
				add = true
			end

			button.Paint = function(self, w, h)
				button.a = Lerp(0.1,button.a or 100,button:IsHovered() and 255 or 150)
				draw.RoundedBox(0, 0, 0, w, h, chosen == self and Color(redselected.r,redselected.g,redselected.b,button.a) or Color(red.r,red.g,red.b,button.a))
				draw.DrawText(language.GetPhrase(att), "DermaDefault", w / 2, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		if not drop then
			for i, att in pairs(weaponAttachments) do
				if chosen2 and chosen2[1] == i and not chosen2[2] then chosen = button end
				local button = atts:Add("")
				button:SetSize(0,25)
				button:DockMargin(0,0,0,2.5)
				button.att = att
				button.DoClick = function()
					chosen = button
					chosen2 = {i, false}
					add = false
				end

				button.Paint = function(self, w, h)
					button.a = Lerp(0.1,button.a or 100,button:IsHovered() and 255 or 150)
					draw.RoundedBox(0, 0, 0, w, h, chosen == self and Color(redselected.r,redselected.g,redselected.b,button.a) or Color(black.r,black.g,black.b,button.a))
					draw.DrawText(language.GetPhrase(att) .. " - on weapon", "DermaDefault", w / 2, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		end

		local button = vgui.Create("DButton", menuPanel)
		button:SetSize(sizeX, 25)
		button:Dock(BOTTOM)
		button:DockMargin(0, 2.5, 0, 0)
		button:SetText("")
		button.Paint = function(self, w, h)
			button.a = Lerp(0.1,button.a or 100,button:IsHovered() and 255 or 150)
			draw.RoundedBox(0, 0, 0, w, h, Color(red.r,red.g,red.b,button.a))
			draw.DrawText("Drop attachment", "DermaDefault", w / 2, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		button.DoClick = function()
			if not chosen then return end
			if not add then return end
			dropAttachment(chosen.att)
		end

		local button = vgui.Create("DButton", menuPanel)
		button:SetSize(sizeX, 25)
		button:Dock(BOTTOM)
		button:DockMargin(0, 2.5, 0, 0)
		button:SetText("")
		button.Paint = function(self, w, h)
			button.a = Lerp(0.1,button.a or 100,button:IsHovered() and 255 or 150)
			draw.RoundedBox(0, 0, 0, w, h, Color(red.r,red.g,red.b,button.a))
			draw.DrawText("Add attachment", "DermaDefault", w / 2, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		button.DoClick = function()
			if not chosen then return end
			if not add then return end
			if not drop then
				addAttachment(chosen.att)
			else
				dropAttachment(chosen.att)
			end
		end

		gray.a = 255
		if not drop then
			local button2 = vgui.Create("DButton", menuPanel)
			button2:SetSize(sizeX, 25)
			button2:Dock(BOTTOM)
			button2:DockMargin(0, 5, 0, 0)
			button2:SetText("")
			button2.DoClick = function()
				if not chosen then return end
				if add then return end
				removeAttachment(chosen.att)
			end

			button2.Paint = function(self, w, h)
				button2.a = Lerp(0.1,button2.a or 100,button2:IsHovered() and 255 or 150)
				draw.RoundedBox(0, 0, 0, w, h, Color(red.r,red.g,red.b,button2.a))
				draw.DrawText("Remove attachment", "DermaDefault", w / 2, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end

	local function removeFlashlights(self)
		if self.flashlight and self.flashlight:IsValid() then
			self.flashlight:Remove()
			self.flashlight = nil
		end
	end

	net.Receive("sync_atts", function(len)
		local self = net.ReadEntity()
		local tbl = net.ReadTable()
		self.attachments = tbl
		if self.modelAtt then
			for atta, model in pairs(self.modelAtt) do
				if not atta then continue end
				if IsValid(model) then model:Remove() end
				self.modelAtt[atta] = nil
			end
		end

		removeFlashlights(self)
		if not IsValid(self) or not IsValid(self:GetOwner()) then return end
		if IsValid(menuPanel) and LocalPlayer() == self:GetOwner() then
			net.Start("attachment_get")
			net.WriteBool(drop)
			net.SendToServer()
		end
	end)

	net.Receive("sync_atts_ply", function(len)
		local ply = net.ReadEntity()
		local tbl = net.ReadTable()
		ply.inventory = ply.inventory or {}
		ply.inventory.Attachments = tbl
		if IsValid(menuPanel) and ply == LocalPlayer() then
			net.Start("attachment_get")
			net.WriteBool(true)
			net.SendToServer()
		end
	end)

	net.Receive("attachment_get", function(len)
		local plyatts = net.ReadTable()
		local atts = net.ReadTable()
		drop = net.ReadBool()
		weaponAttachments = {}
		for posAtt, attData in pairs(atts) do
			if not attData[1] then continue end
			if string.find(attData[1], "empty") or string.find(attData[1], "0") or string.find(attData[1], "mount") then continue end
			weaponAttachments[#weaponAttachments + 1] = attData[1]
		end

		plyAttachments = {}
		for i, att in pairs(plyatts) do
			if string.find(att, "empty") or string.find(att, "0") or string.find(att, "mount") then continue end
			plyAttachments[i] = att
		end

		CreateMenu()
	end)

	concommand.Add("hg_get_attachments", function(ply, cmd, args)
		net.Start("attachment_get")
		net.WriteBool(args[1] and tobool(math.Round(args[1])) or false)
		net.SendToServer()
	end)
else
	util.AddNetworkString("attachment_get")
	net.Receive("attachment_get", function(len, ply)
		net.Start("attachment_get")
		net.WriteTable(ply.inventory.Attachments or {})
		net.WriteTable(ply:GetActiveWeapon().attachments or {})
		net.WriteBool(net.ReadBool())
		net.WriteEntity(ply)
		net.Send(ply)
	end)
end