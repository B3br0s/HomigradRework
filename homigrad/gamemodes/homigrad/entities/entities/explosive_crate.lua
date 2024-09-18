AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Ящик С Взрывчаткой"
ENT.Author = "B3bros"
ENT.Spawnable = true
ENT.AdminSpawnable = false

chumba = 0
local explosiveList = {
    {class = "ent_jack_gmod_ezsatchelcharge", model = "entities/ent_jack_gmod_ezsatchelcharge.png"},
	{class = "ent_jack_gmod_ezsticknadebundle", model = "entities/ent_jack_gmod_ezsticknadebundle.png"},
	{class = "ent_jack_gmod_eztimebomb", model = "entities/ent_jack_gmod_eztimebomb.png"},
	{class = "Empty", model = "null.vmt"},
	{class = "Empty", model = "null.vmt"},
	{class = "Empty", model = "null.vmt"},
	{class = "Empty", model = "null.vmt"},
	{class = "ent_jack_gmod_ezdynamite", model = "entities/ent_jack_gmod_ezdynamite.png"}
}
local explosiveListTranslate = {
    "Динамит",
	"Букет",
	"C4",
	"Пусто",
	"Пусто",
	"Пусто",
	"Пусто",
	"Корсар 3K"
}

if CLIENT then
    local isPanelOpen = false
    local currentExplosiveModel = ""
    local currentExplosiveName = ""
    local isLoading = false
    local loadingProgress = 0
    local modelPanel
    local animationStartTime = 0
    local isClosing = false

    local function drawLoadingCircle(x, y, radius, thickness, progress)
        local segments = 64
        local startAngle = -90
        local endAngle = startAngle + (progress * 360)

        surface.SetDrawColor(255, 255, 255, 255)

        for i = 1, segments do
            local angle1 = math.rad(startAngle + (i / segments) * (endAngle - startAngle))
            local angle2 = math.rad(startAngle + ((i - 1) / segments) * (endAngle - startAngle))

            surface.DrawLine(
                x + math.cos(angle1) * radius,
                y + math.sin(angle1) * radius,
                x + math.cos(angle2) * radius,
                y + math.sin(angle2) * radius
            )
        end
    end

    local function openVgui(ent)
        if isPanelOpen then return end
        isPanelOpen = true
        animationStartTime = CurTime()

        surface.PlaySound("homigrad/vgui/item_drop1_common.wav")

        local panel = vgui.Create("DFrame")
        panel:SetSize(0, 81)
        panel:Center()
        panel:SetVisible(true)
        panel:SetTitle(" ")
        panel:SetDraggable(false)
        panel:ShowCloseButton(false)
        panel:MakePopup()
		isClosing = false

        local fullWidth = 153
        local fullHeight = 81
        local animationDuration = 0.1

        panel.Think = function(self)
            local elapsedTime = CurTime() - animationStartTime
            local progress = math.Clamp(elapsedTime / animationDuration, 0, 1)

            if isClosing then
                local newWidth = Lerp(1 - progress, 0, fullWidth)
                self:SetSize(newWidth, fullHeight)
                self:Center()

                if progress >= 1 then
                    self:Remove()
                end
            else
                local newWidth = Lerp(progress, 0, fullWidth)
                self:SetSize(newWidth, fullHeight)
                self:Center()
            end

            local mx, my = input.GetCursorPos()
            local px, py = self:GetPos()
            local pw, ph = self:GetSize()

            if input.IsMouseDown(MOUSE_LEFT) and (mx < px or mx > (px + pw) or my < py or my > (py + ph)) then
            if isClosing then return end
            isClosing = true
            animationStartTime = CurTime()
			isPanelOpen = false
            net.Start("CloseCrate")
            net.WriteEntity(ent)
            net.SendToServer()
            surface.PlaySound("homigrad/vgui/item_drop.wav")

            timer.Remove("LoadingProgress")
            isLoading = false
            end
        end

        net.Start("ChooseExplosiveCrate")
        net.WriteEntity(ent)
        net.SendToServer()

        panel.Paint = function(self, w, h)
            local col1 = Color(15, 15, 15, 200)
            local col2 = Color(50, 50, 50, 200)

            for i = 0, h do
                local ratio = i / h
                local r = Lerp(ratio, col2.r, col1.r)
                local g = Lerp(ratio, col2.g, col1.g)
                local b = Lerp(ratio, col2.b, col1.b)
                local a = Lerp(ratio, col2.a, col1.a)

                surface.SetDrawColor(r, g, b, a)
                surface.DrawRect(0, h - i, w, 1)
            end

            surface.SetDrawColor(15, 15, 15, 255)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end

        local lootButton = vgui.Create("DButton", panel)
        lootButton:SetSize(73, 73)
        lootButton:SetPos(42, 4)
        lootButton:SetText("")

        modelPanel = vgui.Create("DImage", lootButton)
        modelPanel:SetSize(lootButton:GetWide(), lootButton:GetTall())
        modelPanel.LayoutEntity = function(ent) return end
        modelPanel:Center()

        modelPanel:SetMouseInputEnabled(false)

        lootButton.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(100, 100, 100, 50))


            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            draw.SimpleText(currentExplosiveName, "Trebuchet18", w / 2, h - 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            if isLoading then
                drawLoadingCircle(w / 2, h / 2, 30, 6, loadingProgress)
            end
        end

        lootButton.DoClick = function()
            if isLoading then return end

            isLoading = true
            loadingProgress = 0

            surface.PlaySound("eft_gear_sounds/gear_generic_use.wav")

            timer.Simple(1, function()
                surface.PlaySound("eft_gear_sounds/gear_backpack_pickup.wav")
            end)

            timer.Create("LoadingProgress", 0.01, 20, function()
                loadingProgress = loadingProgress + (1 / 20)
                if loadingProgress >= 1 then
                    isLoading = false

                    net.Start("LootExplosiveFromCrate")
                    net.WriteEntity(ent)
                    net.SendToServer()
                end
            end)
        end

        panel.OnClose = function()
            if isClosing then return end
            isClosing = true
            animationStartTime = CurTime()
        end
    end

    net.Receive("UpdateExplosiveName", function()
        currentExplosiveName = net.ReadString()
        currentExplosiveModel = net.ReadString()

		modelPanel:SetImage(currentExplosiveModel)
    end)

    net.Receive("OpenExplosiveBoxVGUI", function()
        openVgui(net.ReadEntity())
		local cratesuka = net.ReadEntity()
    end)
else
    util.AddNetworkString("UpdateExplosiveName")
    util.AddNetworkString("OpenExplosiveBoxVGUI")
    util.AddNetworkString("LootExplosiveFromCrate")
    util.AddNetworkString("CloseCrate")
    util.AddNetworkString("ChooseExplosiveCrate")
	
	   function SpawnExplosive(position,explosivesuka)
        local ent = ents.Create(explosivesuka)

        if not IsValid(ent) then return end

        ent:SetPos(position)
        ent:Spawn()

        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end

        return ent
    end
	
    function ENT:Initialize()
        self:SetModel("models/kali/props/cases/hard case a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self.BeingLooted = false
        self.DolbaebCheck = false
        self.isLooted = false
        self.ExplosiveIns = "PUSTOSUKAPUSTOOOOZAREGENTEORUZHIE"

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
    end

    function ENT:Use(ply)
        -- Only allow opening the crate if it has not been looted
        if ply:IsPlayer() then
            if not self.BeingLooted then
                self.BeingLooted = true
                self.DolbaebCheck = true
                timer.Simple(1, function() self.DolbaebCheck = false end)
                net.Start("OpenExplosiveBoxVGUI")
                net.WriteEntity(self)
                net.Send(ply)
            else
                if not self.DolbaebCheck then
                    self.DolbaebCheck = true
                    timer.Simple(3, function() self.DolbaebCheck = false end)
                    ply:ChatPrint("Этот ящик уже обыскивает другой игрок.")
                end
            end
        else
            if not self.DolbaebCheck then
                self.DolbaebCheck = true
                timer.Simple(3, function() self.DolbaebCheck = false end)
                ply:ChatPrint("Этот ящик пуст.")
            end
        end
    end

    net.Receive("CloseCrate", function(len, ply)
        local crate = net.ReadEntity()
		print(crate)
        crate.BeingLooted = false
    end)

    net.Receive("ChooseExplosiveCrate", function(len, ply)
        local crate = net.ReadEntity()
        if crate.ExplosiveIns == "PUSTOSUKAPUSTOOOOZAREGENTEORUZHIE" then
            local randomIndex = math.random(1, #explosiveList)
            crate.ExplosiveIns = explosiveList[randomIndex].class
            chumba = randomIndex
        end
		net.Start("UpdateExplosiveName")
		net.WriteString(explosiveListTranslate[chumba])
		net.WriteString(explosiveList[chumba].model)  -- Send the model path to the client
        net.Send(ply)
    end)

    -- Handle Explosive looting
net.Receive("LootExplosiveFromCrate", function(len, ply)
    local crate = net.ReadEntity()

    -- Make sure the entity is valid and the player is interacting with the correct crate
    if IsValid(crate) and crate:GetClass() == "explosive_crate" then

        -- Retrieve the stored explosive from the crate
        local Explosive = crate.ExplosiveIns
        
        -- Check if the explosive is valid and available in the list
        if Explosive ~= "Empty" and Explosive ~= "PUSTOSUKAPUSTOOOOZAREGENTEORUZHIE" then
            local explosiveData = explosiveList[chumba]  -- Use the random explosive selected earlier
            
            -- Check if the player already has the explosive (you may want to implement this logic properly)
            if ply:HasWeapon(explosiveData.class) then
                ply:ChatPrint("У тебя уже есть это оружие.")
            else
                -- **Adjust the spawn position**
                local cratePos = crate:GetPos()
                local spawnPos = cratePos + crate:GetForward() + Vector(0, 0, 70)  -- Adjusted forward and slightly upwards

                -- Spawn the explosive at the adjusted position
                SpawnExplosive(spawnPos, explosiveData.class)

                -- Mark the crate as empty after looting
                chumba = 4
                crate.ExplosiveIns = "Empty"
                
                -- Notify the player that the crate is now empty
                net.Start("UpdateExplosiveName")
                net.WriteString(explosiveListTranslate[chumba])
                net.WriteString(explosiveList[chumba].model)  -- Send the model path to the client
                net.Send(ply)
            end
        else
            -- If the crate is empty, notify the player
            net.Start("UpdateExplosiveName")
            net.WriteString(explosiveListTranslate[chumba])
            net.WriteString(explosiveList[chumba].model)  -- Send the model path to the client
            net.Send(ply)
            ply:ChatPrint("Ты еблан, тут пусто")
        end
    else
        ply:ChatPrint("Ошибка! Ящик не существует.")
    end
end)

end
