AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Ящик С Оружием"
ENT.Author = "B3bros"
ENT.Spawnable = true
ENT.AdminSpawnable = false

numba = 0
local weaponList = {
    {class = "food_litenergy", model = "vgui/wep_jack_hmcd_fooddrink", rarity = "common"},
    {class = "Empty", model = "", rarity = "nullxiety"}
}
local weaponListTranslate = {
    "Lit-Energy",
    "Пусто"
}

if CLIENT then
    local isPanelOpen = false
    local currentWeaponModel = ""
    local currentWeaponName = ""
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

        local fullWidth = 73
        local fullHeight = 73
        local animationDuration = 0.05

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

        net.Start("ChooseWeaponCrate")
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
            surface.DrawOutlinedRect(0, 0, w, h, 1) 
        end

        local lootButton = vgui.Create("DButton", panel)
        lootButton:SetSize(73, 73)
        lootButton:SetPos(0, 0)
        lootButton:SetText("")

        modelPanel = vgui.Create("DImage", lootButton)
        modelPanel:SetSize(lootButton:GetWide() / 1.5, lootButton:GetTall() / 1.5)
        modelPanel:Center()

        modelPanel:SetMouseInputEnabled(false)

        lootButton.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 255))
            
            surface.SetDrawColor(255, 255, 255, 255)

            draw.SimpleText(currentWeaponName, "Trebuchet18", w / 2, h - 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            if isLoading then
                drawLoadingCircle(w / 2, h / 2, 30, 6, loadingProgress)
            end
        end

        modelPanel.Think = function(self)
            local elapsedTime = CurTime() - animationStartTime
            local progress = math.Clamp(elapsedTime / animationDuration, 0, 1)

            if isClosing then
                local newWidth = Lerp(1 - progress, 0, fullWidth / 1.5)
                self:SetSize(newWidth, fullHeight / 1.5)
                self:Center()
                if progress >= 1 then
                    self:Remove()
                end
            else
                local newWidth = Lerp(progress, 0, fullWidth / 1.5)
                self:SetSize(newWidth, fullHeight / 1.5)
                self:Center()
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

                    net.Start("LootWeaponFromCrate")
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

    net.Receive("UpdateWeaponName", function()
        currentWeaponName = net.ReadString()
        currentWeaponModel = net.ReadString()

        if IsValid(modelPanel) then
            modelPanel:SetImage(currentWeaponModel)
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
        self:SetModel("models/props_crates/supply_crate01_static.mdl")
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
                    timer.Simple(1, function() self.DolbaebCheck = false end)
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
        net.WriteString(weaponList[numba].model)
        net.Send(ply)
    end)

    net.Receive("LootWeaponFromCrate", function(len, ply)
        local crate = net.ReadEntity()
        if IsValid(crate) and crate:GetClass() == "weapon_crate" then

            local weapon = crate.WeaponIns
            if weapons.GetStored(weapon) then
                if ply:HasWeapon(weapon) then
                    ply:ChatPrint("У тебя уже есть это.")
                else
                    ply:Give(weapon)
                    crate.WeaponIns = "Empty"
                    numba = 2
                    net.Start("UpdateWeaponName")
                    net.WriteString(weaponListTranslate[numba])
                    net.WriteString(weaponList[numba].model)
                    net.Send(ply)
                end
            else
                if not crate.WeaponIns == "Empty" then
                    ply:ChatPrint("Ошибка! Оружие '" .. weapon .. "' не существует.")
                else
                    net.Start("UpdateWeaponName")
                    net.WriteString(weaponListTranslate[numba])
                    net.WriteString(weaponList[numba].model)
                    net.Send(ply)
                end
            end
        else
            ply:ChatPrint("Ошибка! Ящик не существует.")
        end
    end)
end
