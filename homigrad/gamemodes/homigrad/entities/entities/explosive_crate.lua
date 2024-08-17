AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Ящик С Взрывчаткой"
ENT.Author = "B3bros"
ENT.Spawnable = true
ENT.AdminSpawnable = false

chumba = 0
-- List of possible Explosives in the crate and their respective models
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

        net.Start("ChooseExplosiveCrate")
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
        modelPanel = vgui.Create("DImage", lootButton)
        modelPanel:SetSize(lootButton:GetWide(), lootButton:GetTall()) -- Fit model to button
        modelPanel.LayoutEntity = function(ent) return end  -- Stop the model from rotating
        modelPanel:Center()  -- Center the model panel within the button

        -- **Important**: Disable mouse input on the model panel so it doesn't block the button click
        modelPanel:SetMouseInputEnabled(false)

        -- Add the Explosive name at the bottom of the button
        lootButton.Paint = function(self, w, h)
            -- Draw button background
            draw.RoundedBox(8, 0, 0, w, h, Color(100, 100, 100, 50))

            -- Draw the border
            surface.SetDrawColor(255, 255, 255, 255)  -- White border color
            surface.DrawOutlinedRect(0, 0, w, h, 1)  -- Border thickness of 1px

            -- Draw Explosive name at the bottom of the button
            draw.SimpleText(currentExplosiveName, "Trebuchet18", w / 2, h - 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

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

                    -- Request Explosive loot from server after the delay
                    net.Start("LootExplosiveFromCrate")
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

    -- Update the button with the Explosive 3D model when the Explosive is received
    net.Receive("UpdateExplosiveName", function()
        currentExplosiveName = net.ReadString()  -- Receive the Explosive name
        currentExplosiveModel = net.ReadString()  -- Also read the Explosive model path

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
        local ent = ents.Create(explosivesuka) -- Create the satchel charge entity

        if not IsValid(ent) then return end -- Ensure the entity is valid

        ent:SetPos(position) -- Set the position of the entity
        ent:Spawn() -- Spawn the entity into the world

        -- Optional: Activate physics (if needed)
        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake() -- Wake up the physics object so it can be interacted with
        end

        return ent -- Return the created entity in case you need to manipulate it further
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
