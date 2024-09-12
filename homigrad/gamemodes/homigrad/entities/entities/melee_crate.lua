AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Ящик С Холодным Оружием"
ENT.Author = "B3bros"
ENT.Spawnable = true
ENT.AdminSpawnable = false

numbaachub = 0
local meleeList = {
    {class = "weapon_kabar", model = "models/weapons/insurgency/w_marinebayonet.mdl"},
    {class = "weapon_hg_fireaxe", model = "models/weapons/me_axe_fire_tracer/w_me_axe_fire.mdl"},
    {class = "weapon_hg_fubar", model = "models/weapons/me_fubar/w_me_fubar.mdl"},
    {class = "weapon_gurkha", model = "models/weapons/insurgency/w_gurkha.mdl"},
    {class = "weapon_hg_crowbar", model = "models/weapons/me_spade/w_me_spade.mdl"},
    {class = "Empty", model = ""},
    {class = "Empty", model = ""},
    {class = "Empty", model = ""}
}
local meleeListTranslate = {
    "Байонет",
    "Топор",
    "Фубар",
    "Кукри",
    "Лопата",
    "Пусто",
    "Пусто",
    "Пусто"
}

if CLIENT then
    local isPanelOpen = false
    local currentmeleeModel = ""
    local currentmeleeName = ""
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

        surface.PlaySound("items/ammocrate_open.wav")

        local panel = vgui.Create("DFrame")
        panel:SetSize(0, 81)
        panel:Center()
        panel:SetVisible(true)
        panel:SetTitle(" ")
        panel:SetDraggable(false)
        panel:ShowCloseButton(false)
        panel:MakePopup()
        isClosing = false

        local fullWidth = 306
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
                net.Start("CloseCratee")
                net.WriteEntity(ent)
                net.SendToServer()
                surface.PlaySound("items/ammocrate_close.wav")

                timer.Remove("LoadingProgress")
                isLoading = false
            end
        end

        net.Start("ChoosemeleeCrate")
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
        lootButton:SetPos(115, 4)
        lootButton:SetText("")

        -- Create the model panel inside the button
        modelPanel = vgui.Create("DModelPanel", lootButton)
        modelPanel:SetSize(lootButton:GetWide(), lootButton:GetTall())
        modelPanel.LayoutEntity = function(ent) return end
        modelPanel:Center()

        modelPanel:SetMouseInputEnabled(false)

        lootButton.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(100, 100, 100, 50))

            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            draw.SimpleText(currentmeleeName, "Trebuchet18", w / 2, h - 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

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

                    net.Start("LootmeleeFromCrate")
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

    net.Receive("UpdatemeleeName", function()
        currentmeleeName = net.ReadString()
        currentmeleeModel = net.ReadString()

        if IsValid(modelPanel) then
            modelPanel:SetModel(currentmeleeModel)
        end
    end)

    net.Receive("OpenmeleeBoxVGUI", function()
        openVgui(net.ReadEntity())
        local cratesuka = net.ReadEntity()
    end)
else
    util.AddNetworkString("UpdatemeleeName")
    util.AddNetworkString("OpenmeleeBoxVGUI")
    util.AddNetworkString("LootmeleeFromCrate")
    util.AddNetworkString("CloseCratee")
    util.AddNetworkString("ChoosemeleeCrate")

    function ENT:Initialize()
        self:SetModel("models/props_crates/static_crate_40.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self.BeingLooted = false
        self.DolbaebCheck = false
        self.isLooted = false
        self.meleeIns = "PUSTOSUKAPUSTOOOOZAREGENTEORUZHIE"

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
                net.Start("OpenmeleeBoxVGUI")
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

    net.Receive("CloseCratee", function(len, ply)
        local crate = net.ReadEntity()
        crate.BeingLooted = false
    end)

    net.Receive("ChoosemeleeCrate", function(len, ply)
        local crate = net.ReadEntity()
        if crate.meleeIns == "PUSTOSUKAPUSTOOOOZAREGENTEORUZHIE" then
            local randomIndex = math.random(1, #meleeList)
            crate.meleeIns = meleeList[randomIndex].class
            numbaachub = randomIndex
        end
        net.Start("UpdatemeleeName")
        net.WriteString(meleeListTranslate[numbaachub])
        net.WriteString(meleeList[numbaachub].model)
        net.Send(ply)
    end)

    net.Receive("LootmeleeFromCrate", function(len, ply)
        local crate = net.ReadEntity()

        if IsValid(crate) and crate:GetClass() == "melee_crate" then
            local melee = crate.meleeIns

            if melee == "Empty" then
                ply:ChatPrint("Ты еблан, тут пусто")
            elseif weapons.GetStored(melee) then
                if ply:HasWeapon(melee) then
                    ply:ChatPrint("У тебя уже есть это оружие.")
                else
                    ply:Give(melee)
                    crate.meleeIns = "Empty"
                    numbaachub = 10
                    net.Start("UpdatemeleeName")
                    net.WriteString(meleeListTranslate[6])
                    net.WriteString(meleeList[6].model)
                    net.Send(ply)
                end
            else
                ply:ChatPrint("Ошибка! Оружие '" .. melee .. "' не существует.")
            end
        else
            ply:ChatPrint("Ошибка! Ящик не существует.")
        end
    end)
end
