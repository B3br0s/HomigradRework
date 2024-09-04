--[[if CLIENT then
    local WeaponInventory
    local InventoryOpen = false
    local dragPanel = nil
    local Slots = {}
    local MaxSlots = 7
    local blacklistweapon = { ["weapon_hands"] = true }
    local Weapons = {}
    local daun = false
    local PlayerModelPanel = nil
    local PlayerModelAlpha = 0 -- Variable for player model transparency
    local dragText = ""

    hook.Add("HUDShouldDraw", "HideDefaultWeaponSelection", function(name)
        if name == "CHudWeaponSelection" then return false end
    end)

    local function DrawBlur(panel, amount)
        local x, y = panel:LocalToScreen(0, 0)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(Material("pp/blurscreen"))
        for i = 1, 7 do
            Material("pp/blurscreen"):SetFloat("$blur", (i / 3) * (amount or 6))
            Material("pp/blurscreen"):Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
        end
    end

    local function CreateContextMenu(slot)
        local menu = DermaMenu()
        if slot.Weapon and not blacklistweapon[slot.Weapon:GetClass()] then
            menu:AddOption("Использовать", function()
                if IsValid(slot.Weapon) then
                    RunConsoleCommand("use", slot.Weapon:GetClass())
                end
            end):SetIcon("icon16/tick.png")

            menu:AddOption("Выкинуть", function()
                if IsValid(slot.Weapon) then
                    RunConsoleCommand("use", slot.Weapon:GetClass())
                    RunConsoleCommand("say", "*drop")
                    WeaponInventory:CloseInventory()
                    timer.Simple(0.1, function ()
                        WeaponInventory:OpenInventory() 
                    end)
                end
            end):SetIcon("icon16/delete.png")
        end
        menu:Open()
    end

    local function CreateWeaponSlot(parent, index)
        local slot = vgui.Create("DPanel", parent)
        slot:SetSize(80, 80)
        slot.index = index
        slot.Weapon = nil
        slot:SetBackgroundColor(Color(60, 60, 60, 150))

        function slot:Paint(w, h)
            draw.RoundedBox(8, 0, 0, w, h, self:GetBackgroundColor())
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawOutlinedRect(0, 0, w, h, 2)

            if self.Weapon and IsValid(self.Weapon) then
                draw.SimpleText(self.Weapon:GetPrintName(), "DermaDefaultBold", w / 2, h - 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            end
        end

        function slot:OnMousePressed(mousecode)
            if mousecode == MOUSE_LEFT then
                if self.Weapon then
                    dragPanel = self
                end
            elseif mousecode == MOUSE_RIGHT then
                CreateContextMenu(self)
            end
        end

        function slot:OnMouseReleased(mousecode)
            if mousecode == MOUSE_LEFT and dragPanel then
                if self:IsHovered() and self ~= dragPanel then
                    -- Swap weapons between the two slots
                    self.Weapon, dragPanel.Weapon = dragPanel.Weapon, self.Weapon
                    surface.PlaySound("buttons/button14.wav")
                end
                dragPanel = nil
                dragText = ""
            end
        end

        return slot
    end

    local function CreatePlayerModelPanel(parent)
        if IsValid(PlayerModelPanel) then
            PlayerModelPanel:Remove()
        end
        
        PlayerModelPanel = vgui.Create("DModelPanel", parent)
        PlayerModelPanel:SetSize(400, 500)
        PlayerModelPanel:SetPos(0, ScrH() / 2 - 300)
        PlayerModelPanel:SetModel(LocalPlayer():GetModel())
        PlayerModelPanel:SetLookAt(Vector(0, 0, 60))
        PlayerModelPanel:SetCamPos(Vector(80, 0, 60))

        local Ent = PlayerModelPanel:GetEntity()
        function PlayerModelPanel:LayoutEntity(ent)
            ent:SetAngles(Angle(0, 0, 0))
        end
            
        Ent:SetSkin(LocalPlayer():GetSkin())
        for k, v in pairs(LocalPlayer():GetBodyGroups()) do
            local cur_bgid = LocalPlayer():GetBodygroup(v.id)
            Ent:SetBodygroup(v.id, cur_bgid)
        end
            
        if LocalPlayer().EZarmor.suited and LocalPlayer().EZarmor.bodygroups then
            PlayerModelPanel:SetColor(LocalPlayer():GetColor())
            for k, v in pairs(LocalPlayer().EZarmor.bodygroups) do
                Ent:SetBodygroup(k, v)
            end
        end

        function PlayerModelPanel:PaintOver(w, h)
            if PlayerModelAlpha > 0 then
                self:SetAlpha(PlayerModelAlpha)
            else
                self:SetAlpha(0)
            end
        end

        function PlayerModelPanel:PostDrawModel(ent)
            ent.EZarmor = LocalPlayer().EZarmor
            JMod.ArmorPlayerModelDraw(ent)
        end
    end

    local PANEL = {}
    PANEL.FadeAlpha = 0

    function PANEL:Init()
        self:SetSize(ScrW(), ScrH())
        self:SetPos(0, 0)
        self:SetVisible(false)
        self:SetKeyboardInputEnabled(false)
        self:SetMouseInputEnabled(true)

        CreatePlayerModelPanel(self)

        local slotSpacing = 90
        local startX = (ScrW() / 2) - ((MaxSlots * slotSpacing) / 2)
        local startY = ScrH() - 150

        for i = 1, MaxSlots do
            local slot = CreateWeaponSlot(self, i)
            slot:SetPos(startX + (i - 1) * slotSpacing, startY)
            table.insert(Slots, slot)
        end
    end

    function PANEL:Think()
        -- Handle opening and closing animation for inventory and player model
        if InventoryOpen then
            if self.FadeAlpha < 255 then
                self.FadeAlpha = math.min(self.FadeAlpha + FrameTime() * 500, 255)
            end
            PlayerModelAlpha = self.FadeAlpha -- Match alpha with inventory panel
        else
            if self.FadeAlpha > 0 then
                self.FadeAlpha = math.max(self.FadeAlpha - FrameTime() * 500, 0)
            end
            PlayerModelAlpha = self.FadeAlpha -- Match alpha with inventory panel
        end

        if self.FadeAlpha <= 0 and not InventoryOpen then
            self:SetVisible(false)
        end
    end

    function PANEL:Paint(w, h)
        if self.FadeAlpha > 0 then
            self:SetAlpha(self.FadeAlpha)
            DrawBlur(self, 4)
            draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, self.FadeAlpha * 0.6))
        end
    end

    function PANEL:OpenInventory()
        self:SetVisible(true)
        InventoryOpen = true
        self:MakePopup()
        self:SetKeyboardInputEnabled(false)
        self:SetMouseInputEnabled(true)

        CreatePlayerModelPanel(self)

        Weapons = LocalPlayer():GetWeapons()
        for _, slot in ipairs(Slots) do
            if IsValid(slot) then
                slot.Weapon = nil
            end
        end

        local weaponIndex = 1
        for i = 1, MaxSlots do
            local slot = Slots[i]
            if IsValid(slot) then
                while weaponIndex <= #Weapons do
                    local weapon = Weapons[weaponIndex]
                    weaponIndex = weaponIndex + 1
                    if IsValid(weapon) and not blacklistweapon[weapon:GetClass()] then
                        slot.Weapon = weapon
                        break
                    end
                end
            end
        end
    end

    function PANEL:CloseInventory()
        InventoryOpen = false
        self:SetKeyboardInputEnabled(false)
        self:SetMouseInputEnabled(false)
    end

    vgui.Register("CustomWeaponInventory", PANEL, "EditablePanel")

    concommand.Add("hg_openinv", function()
        if not IsValid(WeaponInventory) then
            WeaponInventory = vgui.Create("CustomWeaponInventory")
        end

        if InventoryOpen then
            WeaponInventory:CloseInventory()
            surface.PlaySound("eft_gear_sounds/gear_backpack_pickup.wav")
        else
            if LocalPlayer():Alive() then
                WeaponInventory:OpenInventory()
                surface.PlaySound("eft_gear_sounds/gear_backpack_use.wav")
            end
        end
    end)

    hook.Add("PlayerSpawn", "UpdatePlayerModelPanel", function()
        if IsValid(WeaponInventory) then
            WeaponInventory:OpenInventory()
        end
    end)

    hook.Add("Think", "FirstSlot", function()
        if input.IsKeyDown(KEY_1) and not daun then
            daun = true
            RunConsoleCommand("use", "weapon_hands" or "weapon_handsinfected")
            timer.Simple(0.2, function() daun = false end)
        end
    end)
end]]