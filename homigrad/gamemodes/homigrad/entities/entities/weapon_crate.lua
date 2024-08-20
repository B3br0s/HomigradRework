AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Ящик С Оружием"
ENT.Author = "B3bros"
ENT.Spawnable = true
ENT.AdminSpawnable = false

numba = 0
-- List of possible weapons in the crate and their respective models
local weaponList = {
    {class = "weapon_deagle", model = "models/pwb2/weapons/w_matebahomeprotection.mdl"},
    {class = "weapon_m14", model = "models/pwb/weapons/w_tmp.mdl"},
    {class = "weapon_akm", model = "models/pwb/weapons/w_akm.mdl"},
    {class = "weapon_mp5", model = "models/pwb2/weapons/w_mp5a3.mdl"},
    {class = "weapon_minu14", model = "models/pwb/weapons/w_m590a1.mdl"},
    {class = "weapon_hk_usps", model = "models/weapons/w_bean_beansmusp.mdl"},
    {class = "weapon_civil_famas", model = "models/pwb2/weapons/w_famasg2.mdl"},
    {class = "weapon_ak74u", model = "models/pwb/weapons/w_aks74u.mdl"},
    {class = "weapon_glock18", model = "models/pwb2/weapons/w_fiveseven.mdl"},
	{class = "Empty", model = ""},
	{class = "Empty", model = ""},
	{class = "Empty", model = ""},
	{class = "Empty", model = ""},
	{class = "Empty", model = ""}	
}
local weaponListTranslate = {
    "Mateba",
    "TMP",
    "AKM",
    "HK MP5a3",
    "M590",
    "HK USP-S",
    "FAMAS-Civil",
    "АКС-74У",
    "Five-Seven",
	"Пусто",
	"Пусто",
	"Пусто",
	"Пусто",
	"Пусто"
}

if CLIENT then
    local isPanelOpen = false
    local currentWeaponModel = ""
    local currentWeaponName = ""
    local isLoading = false -- To track if the loading circle is active
    local loadingProgress = 0 -- Progress of the loading circle
    local modelPanel -- Define the model panel at a higher scope to reuse
    local animationStartTime = 0 -- To track the time when the animation starts
    local isClosing = false -- To check if the panel is in the closing animation state

    -- Function to draw the loading circle
    local function drawLoadingCircle(x, y, radius, thickness, progress)
        local segments = 64
        local startAngle = -90 -- Start at the top
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

    -- Function to open the VGUI
    local function openVgui(ent)
        if isPanelOpen then return end
        isPanelOpen = true
        animationStartTime = CurTime() -- Set animation start time

        -- Play the sound when the VGUI opens
        surface.PlaySound("items/ammocrate_open.wav")

        -- Create the panel with an initial size of 0,81
        local panel = vgui.Create("DFrame")
        panel:SetSize(0, 81)
        panel:Center()
        panel:SetVisible(true)
        panel:SetTitle(" ")
        panel:SetDraggable(false)
        panel:ShowCloseButton(false)
        panel:MakePopup()
		isClosing = false

        -- Set the full target size for the panel
        local fullWidth = 306
        local fullHeight = 81
        local animationDuration = 0.1 -- Faster animation duration (0.1 seconds)

        -- Panel's Think function to handle the animation
        panel.Think = function(self)
            local elapsedTime = CurTime() - animationStartTime
            local progress = math.Clamp(elapsedTime / animationDuration, 0, 1)

            if isClosing then
                -- Reverse the size from full size to 0 (closing animation)
                local newWidth = Lerp(1 - progress, 0, fullWidth)
                self:SetSize(newWidth, fullHeight)
                self:Center() -- Keep the panel centered

                -- When the animation completes, actually close the panel
                if progress >= 1 then
                    self:Remove()
                end
            else
                -- Opening animation: Lerp the size from 0 to full size
                local newWidth = Lerp(progress, 0, fullWidth)
                self:SetSize(newWidth, fullHeight)
                self:Center() -- Keep the panel centered
            end

            -- Close the panel if clicked outside
            local mx, my = input.GetCursorPos()
            local px, py = self:GetPos()
            local pw, ph = self:GetSize()

            if input.IsMouseDown(MOUSE_LEFT) and (mx < px or mx > (px + pw) or my < py or my > (py + ph)) then
            if isClosing then return end -- Prevent multiple closures
            isClosing = true -- Set the flag to initiate the closing animation
            animationStartTime = CurTime() -- Reset the animation start time
			isPanelOpen = false
            net.Start("CloseCrate")
            net.WriteEntity(ent)
            net.SendToServer()
			-- Play the close sound when the VGUI is closed
            surface.PlaySound("items/ammocrate_close.wav")

            -- Stop the loading progress timer if the panel is closed early
            timer.Remove("LoadingProgress")
            isLoading = false
            end
        end

        net.Start("ChooseWeaponCrate")
        net.WriteEntity(ent)
        net.SendToServer()

        -- Add a gradient to the background of the panel with 60% transparency
        panel.Paint = function(self, w, h)
            local col1 = Color(15, 15, 15, 200)  -- 60% transparent
            local col2 = Color(50, 50, 50, 200)  -- 60% transparent

            -- Gradient from bottom to top
            for i = 0, h do
                local ratio = i / h
                local r = Lerp(ratio, col2.r, col1.r)
                local g = Lerp(ratio, col2.g, col1.g)
                local b = Lerp(ratio, col2.b, col1.b)
                local a = Lerp(ratio, col2.a, col1.a)

                surface.SetDrawColor(r, g, b, a)
                surface.DrawRect(0, h - i, w, 1)  -- Move from bottom to top
            end

            -- Draw a white border around the panel
            surface.SetDrawColor(15, 15, 15, 255)  -- White border color
            surface.DrawOutlinedRect(0, 0, w, h, 2)  -- Border thickness of 2px
        end

        -- Loot button to allow interaction
        local lootButton = vgui.Create("DButton", panel)
        lootButton:SetSize(73, 73)
        lootButton:SetPos(115, 4) -- Adjust position to avoid overlapping edges
        lootButton:SetText("")  -- No text needed since the model will be shown

        -- Create the model panel inside the button
        modelPanel = vgui.Create("DModelPanel", lootButton)
        modelPanel:SetSize(lootButton:GetWide(), lootButton:GetTall()) -- Fit model to button
        modelPanel.LayoutEntity = function(ent) return end  -- Stop the model from rotating
        modelPanel:Center()  -- Center the model panel within the button

        -- **Important**: Disable mouse input on the model panel so it doesn't block the button click
        modelPanel:SetMouseInputEnabled(false)

        -- Add the weapon name at the bottom of the button
        lootButton.Paint = function(self, w, h)
            -- Draw button background
            draw.RoundedBox(8, 0, 0, w, h, Color(100, 100, 100, 50))

            -- Draw the border
            surface.SetDrawColor(255, 255, 255, 255)  -- White border color
            surface.DrawOutlinedRect(0, 0, w, h, 1)  -- Border thickness of 1px

            -- Draw weapon name at the bottom of the button
            draw.SimpleText(currentWeaponName, "Trebuchet18", w / 2, h - 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            -- If loading is active, draw the loading circle
            if isLoading then
                drawLoadingCircle(w / 2, h / 2, 30, 6, loadingProgress)
            end
        end

        -- When the button is clicked, start the loading process
        lootButton.DoClick = function()
            if isLoading then return end -- Prevent multiple clicks

            isLoading = true
            loadingProgress = 0

            surface.PlaySound("eft_gear_sounds/gear_generic_use.wav")

            timer.Simple(1, function()
                surface.PlaySound("eft_gear_sounds/gear_backpack_pickup.wav")
            end)

            -- Start a timer to simulate the delay (3 seconds in this example)
            timer.Create("LoadingProgress", 0.01, 20, function()
                loadingProgress = loadingProgress + (1 / 20) -- Update the progress
                if loadingProgress >= 1 then
                    isLoading = false -- Loading complete

                    -- Request weapon loot from server after the delay
                    net.Start("LootWeaponFromCrate")
                    net.WriteEntity(ent)
                    net.SendToServer()
                end
            end)
        end

        -- Ensure the flag is reset when the panel is closed
        panel.OnClose = function()
            if isClosing then return end -- Prevent multiple closures
            isClosing = true -- Set the flag to initiate the closing animation
            animationStartTime = CurTime() -- Reset the animation start time
        end
    end

    -- Update the button with the weapon 3D model when the weapon is received
    net.Receive("UpdateWeaponName", function()
        currentWeaponName = net.ReadString()  -- Receive the weapon name
        currentWeaponModel = net.ReadString()  -- Also read the weapon model path

        -- Ensure the model panel exists before updating
        if IsValid(modelPanel) then
            modelPanel:SetModel(currentWeaponModel)

            -- Adjust camera angles for specific models
            if currentWeaponName == "Mateba" then
                modelPanel:SetCamPos(Vector(7, 30, 2))
                modelPanel:SetLookAng(Vector(0, -90, 0))
                modelPanel:SetLookAt(Vector(0, 0, 0))
            elseif currentWeaponName == "TMP" then
                modelPanel:SetCamPos(Vector(-10, 50, 3))
                modelPanel:SetLookAng(Vector(0, -90, 0))
                modelPanel:SetLookAt(Vector(0, 0, 0))
            elseif currentWeaponName == "AKM" then
                modelPanel:SetCamPos(Vector(-3, 60, 4))
                modelPanel:SetLookAng(Vector(0, -90, 0))
                modelPanel:SetLookAt(Vector(0, 0, 0))
            elseif currentWeaponName == "HK MP5a3" then
                modelPanel:SetCamPos(Vector(5, 45, 0))
                modelPanel:SetLookAng(Vector(0, -90, 0))
                modelPanel:SetLookAt(Vector(0, 0, 0))
            elseif currentWeaponName == "M590" then
                modelPanel:SetCamPos(Vector(-1.5, 60, 5))
                modelPanel:SetLookAng(Vector(0, -90, 0))
                modelPanel:SetLookAt(Vector(0, 0, 0))
            elseif currentWeaponName == "HK USP-S" then
                modelPanel:SetCamPos(Vector(10, 1, 35))
                modelPanel:SetLookAng(Vector(90, 90, 0))
                modelPanel:SetLookAt(Vector(0, 0, 0))
            elseif currentWeaponName == "FAMAS-Civil" then
                modelPanel:SetCamPos(Vector(5.5, 50, 1))
                modelPanel:SetLookAng(Vector(0, -90, 0))
                modelPanel:SetLookAt(Vector(0, 0, 0))
            elseif currentWeaponName == "Шокер" then
                modelPanel:SetCamPos(Vector(2.5, 40, 0.2))
                modelPanel:SetLookAng(Vector(0, -90, 0))
                modelPanel:SetLookAt(Vector(0, 0, 0))
            elseif currentWeaponName == "Перцовка" then
                modelPanel:SetCamPos(Vector(25, -0.5, -0.2))
                modelPanel:SetLookAng(Vector(0, 180, 0))
                modelPanel:SetLookAt(Vector(0, 0, 0))
            elseif currentWeaponName == "АКС-74У" then
                modelPanel:SetCamPos(Vector(-5, 50, 4))
                modelPanel:SetLookAng(Vector(0, -90, 0))
                modelPanel:SetLookAt(Vector(0, 0, 0))
            elseif currentWeaponName == "Five-Seven" then
                modelPanel:SetCamPos(Vector(5, 30, 1.6))
                modelPanel:SetLookAng(Vector(0, -90, 0))
                modelPanel:SetLookAt(Vector(0, 0, 0))
            end
        end
    end)

    net.Receive("OpenWeaponBoxVGUI", function()
        openVgui(net.ReadEntity())
		local cratesuka = net.ReadEntity()
    end)
else
    util.AddNetworkString("UpdateWeaponName")
    util.AddNetworkString("OpenWeaponBoxVGUI")
    util.AddNetworkString("LootWeaponFromCrate")
    util.AddNetworkString("CloseCrate")
    util.AddNetworkString("ChooseWeaponCrate")

    function ENT:Initialize()
        self:SetModel("models/n7/props/cases/rifle_case_a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self.BeingLooted = false
        self.DolbaebCheck = false
        self.isLooted = false
        self.WeaponIns = "PUSTOSUKAPUSTOOOOZAREGENTEORUZHIE"

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
                net.Start("OpenWeaponBoxVGUI")
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

    net.Receive("ChooseWeaponCrate", function(len, ply)
        local crate = net.ReadEntity()
        if crate.WeaponIns == "PUSTOSUKAPUSTOOOOZAREGENTEORUZHIE" then
            local randomIndex = math.random(1, #weaponList)
            crate.WeaponIns = weaponList[randomIndex].class
            numba = randomIndex
        end
		net.Start("UpdateWeaponName")
		net.WriteString(weaponListTranslate[numba])
		net.WriteString(weaponList[numba].model)  -- Send the model path to the client
        net.Send(ply)
    end)

    -- Handle weapon looting
    net.Receive("LootWeaponFromCrate", function(len, ply)
        local crate = net.ReadEntity()

        -- Make sure the entity is valid and the player is interacting with the correct crate
        if IsValid(crate) and crate:GetClass() == "weapon_crate" then

            local weapon = crate.WeaponIns
            if weapons.GetStored(weapon) then
                -- Give the weapon to the player
                if ply:HasWeapon(weapon) then
                    ply:ChatPrint("У тебя уже есть это оружие.")
                else
                    ply:Give(weapon)
                    crate.WeaponIns = "Empty"
					numba = 10
					net.Start("UpdateWeaponName")
					net.WriteString(weaponListTranslate[numba])
					net.WriteString(weaponList[numba].model)  -- Send the model path to the client
					net.Send(ply)
                end
            else
				if not crate.WeaponIns == "Empty" then
					ply:ChatPrint("Ошибка! Оружие '" .. weapon .. "' не существует.")
				else
					net.Start("UpdateWeaponName")
					net.WriteString(weaponListTranslate[numba])
					net.WriteString(weaponList[numba].model)  -- Send the model path to the client
					net.Send(ply)
					ply:ChatPrint("Ты еблан, тут пусто")
				end
            end
        else
            ply:ChatPrint("Ошибка! Ящик не существует.")
        end
    end)
end
