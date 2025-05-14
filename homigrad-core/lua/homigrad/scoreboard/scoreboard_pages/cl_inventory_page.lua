local open = false
local panelka

local lply = LocalPlayer()

local weps = {}

local armorSlots = {
    "head", "eyes", "mouthnose", "ears", "rightshoulder", "rightforearm", 
    "rightthigh", "rightcalf", "chest", "pelvis", "leftshoulder", "leftforearm", 
    "leftthigh", "leftcalf", "acc_head", "acc_eyes", "acc_neck", "acc_ears", 
    "acc_lshoulder", "acc_rshoulder", "acc_backpack", "back", "acc_chestrig", "armband"
}

local BlackList = {
    ["weapon_hands"] = true,
    ["weapon_physgun"] = true,
    ["gmod_tool"] = true,
    ["gmod_camera"] = true,
}

function PopulateArmorSlots()
    local playerArmor = LocalPlayer().EZarmor
    if not playerArmor then
        return
    end

    for _, slotName in ipairs(armorSlots) do
        local itemID, itemData, armorInfo = GetItemInSlot(playerArmor, slotName)
        if itemID then
            armorSlots[slotName] = {
                id = itemID,
                data = itemData,
                specs = armorInfo
            }
        else
            armorSlots[slotName] = nil
        end
    end
end

hook.Add("HUDPaint","InventoryPage",function()
    if not hg.ScoreBoard then return end
    if not IsValid(ScoreBoardPanel) then open = false return end
    if !LocalPlayer():Alive() and hg.ScoreBoard == 3 then
        hg.ScoreBoard = 1
        if IsValid(ScoreBoardPanel) then
            ScoreBoardPanel:Remove()
        end
    end
    if open and hg.islooting then
        if input.IsKeyDown(KEY_W) or input.IsKeyDown(KEY_D) or input.IsKeyDown(KEY_S) or input.IsKeyDown(KEY_A) then
            ScoreBoardPanel:Remove()
            hg.islooting = false
            hg.lootent = nil
        end
    end
    if hg.ScoreBoard == 3 and not open then

        table.Empty(weps)

        open = true
        
        local MainFrame = vgui.Create("hg_frame",ScoreBoardPanel)
        panelka = MainFrame
        MainFrame:ShowCloseButton(false)
        MainFrame:SetTitle(" ")
        MainFrame:SetDraggable(false)
        MainFrame:SetSize(ScrW(), ScrH())
        //MainFrame:SetMouseInputEnabled(false)
        MainFrame.NoDraw = true

        local CenterX = ScoreBoardPanel:GetWide() / 2
        //MainFrame:Center()

        local daun1 = 0

        local lootent = NULL

        function MainFrame:SubPaint(w,h)
            daun1 = LerpFT(0.3,daun1,(hg.islooting and 1 or 0))

            /*draw.SimpleText("WORK IN PROGRESS.","HS.45",ScrW()/1.995,ScrH()/2.095,Color(204,0,255,15),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            draw.SimpleText("WORK IN PROGRESS.","HS.45",ScrW()/2,ScrH()/2.1,Color(255,255,255,15),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

            draw.SimpleText("COME BACK SOON!","HS.45",ScrW()/1.995,ScrH()/1.895,Color(204,0,255,15),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            draw.SimpleText("COME BACK SOON!","HS.45",ScrW()/2,ScrH()/1.9,Color(255,255,255,15),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)*/

            if hg.islooting and lootent:IsRagdoll() then
                lootent = hg.lootent
                draw.SimpleText(lootent:GetNWString("PlayerName"),"HS.18",w/2,h/1.85,Color(255,255,255,255 * daun1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            elseif hg.islooting then
                lootent = hg.lootent
                draw.SimpleText(hg.GetPhrase(lootent:GetClass()),"HS.18",w/2,h/1.85,Color(255,255,255,255 * daun1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            elseif !hg.islooting and lootent != NULL then
                if !lootent:IsRagdoll() then
                    draw.SimpleText(hg.GetPhrase(lootent:GetClass()),"HS.18",w/2,h/1.85,Color(255,255,255,255 * daun1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(lootent:GetNWString("PlayerName"),"HS.18",w/2,h/1.85,Color(255,255,255,255 * daun1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end
            end    
        end

        local SlotsSize = 75

        local InvFrame = vgui.Create("hg_frame",MainFrame)
        InvFrame:ShowCloseButton(false)
        InvFrame:SetTitle(" ")
        InvFrame:SetDraggable(false)
        InvFrame:SetSize(ScrW() / 3.2, SlotsSize)
        InvFrame:Center()
        InvFrame:SetPos(InvFrame:GetX(),ScrH()-SlotsSize)
        InvFrame:DockMargin(0,0,0,0)
        InvFrame:DockPadding(0,0,0,0)

        //SlotsSize = 75 * 1.1

        local JModFrame = vgui.Create("hg_frame",MainFrame)
        JModFrame:ShowCloseButton(false)
        JModFrame:SetTitle(" ")
        JModFrame:SetDraggable(false)
        JModFrame:SetSize(SlotsSize, SlotsSize)
        JModFrame:Center()
        JModFrame:SetPos(JModFrame:GetX() - SlotsSize * 6.5,ScrH()-SlotsSize)
        JModFrame:DockMargin(0,0,0,0)
        JModFrame:DockPadding(0,0,0,0)
        JModFrame.NoDraw = true

        SlotsSize = 75

        //CreateLootFrame({[1] = "weapon_ak47"})
        for _, wep in ipairs(LocalPlayer():GetWeapons()) do
            if !BlackList[wep:GetClass()] and !table.HasValue(weps,wep) then
                table.insert(weps,wep)
            end
        end

        local slotjmod = CreateJModEntInvSlot(JModFrame,SlotsSize,1,LocalPlayer())

        function slotjmod:LoadPaint()
            local w,h = self:GetSize()
            if LocalPlayer():GetNWEntity("JModEntInv") and self.DropIn then
                if self.DropIn < CurTime() then
                    self.IsDropping = false
                    self.DropIn = nil
                    net.Start("hg drop jmod")
                    net.SendToServer()
                end
            end
            if self.IsDropping then
                surface.SetDrawColor(225,225,225)
                self.LootAnim = LerpFT(0.2,self.LootAnim,self.LootAnim + 100)
        
                surface.SetMaterial(Material("homigrad/vgui/loading.png"))
                surface.DrawTexturedRectRotated(w/2,h/2,w/1.75,h/1.75,self.LootAnim)
            end
        end

        for i = 1, 8 do
            local Slot = CreateLocalInvSlot(InvFrame,SlotsSize,i)
            InvFrame[i] = Slot
            Slot.LootAnim = 0

            function Slot:DoRightClick()
                if self.Weapon then
                    local Menu = DermaMenu(true,self)

                    Menu:SetPos(input.GetCursorPos())
                    Menu:MakePopup()

                        Menu:AddOption(hg.GetPhrase("inv_drop"),function()
                            self:Drop()
                        end)

                        if self.Weapon.Roll and self.Weapon == LocalPlayer():GetActiveWeapon() then
                            Menu:AddOption(hg.GetPhrase("inv_roll"),function()
                                RunConsoleCommand("hg_roll")
                            end)
                        end
                    end
            end

            function Slot:LoadPaint()
                local w,h = self:GetSize()
                if self.Weapon and self.DropIn then
                    if self.DropIn < CurTime() then
                        self.IsDropping = false
                        self.DropIn = nil
                        net.Start("DropItemInv")
                        net.WriteString(self.Weapon:GetClass())
                        net.SendToServer()
                    end
                end
                if self.IsDropping then
                    surface.SetDrawColor(225,225,225)
                    
                    self.LootAnim = LerpFT(0.2,self.LootAnim,self.LootAnim + 100)
            
                    surface.SetMaterial(Material("homigrad/vgui/loading.png"))
                    surface.DrawTexturedRectRotated(w/2,h/2,w/1.75,h/1.75,self.LootAnim)
                end
            end

            for _, wep in ipairs(weps) do
                if i == _ then
                    Slot.Weapon = wep
                end
            end
        end
    elseif hg.ScoreBoard != 3 then
        hg.islooting = false
        open = false
        if IsValid(panelka) then
            panelka:Remove()
        end
    end
end)

function CreateLootSlot(Parent,SlotsSize,PosI)
    local InvButton = vgui.Create("hg_button",Parent)
    InvButton:SetSize(SlotsSize, SlotsSize)
    InvButton:SetPos(Parent:GetWide()/2,0)
    InvButton:Center()
    //InvButton:Dock(LEFT)
    //InvButton:DockMargin(SlotsSize * (1-Parent.CurSize),0,0,0)
    InvButton:SetText(" ")
    InvButton.LowerText = ""
    InvButton.LowerFont = "HS.10"

    function InvButton:DoRightClick()

    end
    
    function InvButton:Think()
        local w,h = Parent:GetSize()

        self:SetWide(SlotsSize * Parent.CurSize)
        self:SetX((w / 2) * (1-Parent.CurSize) + ((SlotsSize * (PosI - 1))) * Parent.CurSize)
    end

    return InvButton
end

function CreateJModEntInvSlot(Parent,SlotsSize,PosI,ent,weps)
    local InvButton = vgui.Create("hg_button",Parent)
    InvButton:SetSize(SlotsSize, SlotsSize)
    InvButton:SetPos(SlotsSize * (PosI - 1),0)
    //InvButton:Dock(LEFT)
    InvButton:SetText(" ")
    InvButton.LowerText = ""
    InvButton.LowerFont = "HS.10"
    InvButton.LootAnim = 0

    function InvButton:Drop()
        if self.IsDropping then
            return
        end
        if ent:GetNWEntity("JModEntInv") == NULL then
            return
        end
        surface.PlaySound("homigrad/vgui/item_scroll_sticker_01.wav")
        self.DropIn = CurTime() + 0.2
        self.IsDropping = true
    end

    if ent == LocalPlayer() then
        function InvButton:DoRightClick()
            if ent:GetNWEntity("JModEntInv") != NULL then
                local Menu = DermaMenu(true,self)

                Menu:SetPos(input.GetCursorPos())
                Menu:MakePopup()

                    Menu:AddOption(hg.GetPhrase("inv_drop"),function()
                        self:Drop()
                    end)
                end
        end
    else
        function InvButton:DoClick()
            self:Loot()
        end
    end

    function InvButton:SubPaint(w,h)
        if Parent.CurSize then
            local w,h = Parent:GetSize()
            if !table.IsEmpty(weps) then
                self:SetX((w / 2) * (1 - Parent.CurSize) + SlotsSize * Parent.CurSize)
            end
            self:SetWide(SlotsSize * Parent.CurSize)
            self:Center()
        end

        if ent == LocalPlayer() then
            if self:IsHovered() then
                if fastloot then  
                    self:Drop()
                end
            end
        end

        if ent == nil then
            self.LowerText = " "
            return
        end

        if ent != LocalPlayer() then
            if self:IsHovered() then
                if fastloot then  
                    self:Loot()
                end
            end
        end

        local jent = ent:GetNWEntity("JModEntInv",NULL)
        
        if IsValid(jent) and jent != NULL then
            self.LowerText = jent.PrintName
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(Material("entities/"..jent:GetClass()..".png"))
            surface.DrawTexturedRect(w-w/1.15,h-h/1.15,w/1.3,h/1.3)
        else
            self.LowerText = " "
        end

        if self.LoadPaint then
            self:LoadPaint()
        end

        if self.BeingLooted then
            surface.SetDrawColor(225,225,225)
            self.LootAnim = LerpFT(0.2,self.LootAnim,self.LootAnim + 100)
        else
            surface.SetDrawColor(0,0,0,0)
        end

        if ent != nil and self.LootIn then
            if self.LootIn < CurTime() then
                net.Start("hg loot jmod")
                net.WriteEntity(ent)
                net.SendToServer()
                ent = nil
                //Parent.CurSizeTarget = 0
                self.BeingLooted = false
                surface.PlaySound("homigrad/vgui/panorama/cards_draw_one_04.wav")
            end
        end

        surface.SetMaterial(Material("homigrad/vgui/loading.png"))
        surface.DrawTexturedRectRotated(w/2,h/2,w/1.75,h/1.75,self.LootAnim)

        draw.SimpleText(self.LowerText, (self.LowerFont or "HS.18"), w / 2, h / 1.2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    function InvButton:Loot()
        if self.BeingLooted then
            return
        end
        self.BeingLooted = true
        surface.PlaySound("homigrad/vgui/panorama/inventory_new_item_scroll_01.wav")
        self.LootIn = CurTime() + 0.8
    end

    return InvButton
end

function CreateLocalInvSlot(Parent,SlotsSize,PosI)
    local InvButton = vgui.Create("hg_button",Parent)
    InvButton:SetSize(SlotsSize, SlotsSize)
    InvButton:SetPos(SlotsSize * (PosI - 1),0)
    InvButton:Dock(LEFT)
    InvButton:SetText(" ")
    InvButton.LowerText = ""
    InvButton.LowerFont = "HS.10"

    function InvButton:Drop()
        if self.IsDropping then
            return
        end
        surface.PlaySound("homigrad/vgui/item_scroll_sticker_01.wav")
        self.DropIn = CurTime() + 0.2
        self.IsDropping = true
    end

    function InvButton:SubPaint(w,h)
        local weps = {}
        for _, wep in ipairs(LocalPlayer():GetWeapons()) do
            if not BlackList[wep:GetClass()] and !table.HasValue(weps, wep) then
                table.insert(weps, wep)
            end
        end
        
        for i = #weps, 1, -1 do
            local wep = weps[i]
            if not IsValid(wep) or wep:GetOwner() != LocalPlayer() then
                table.remove(weps, i)
            end
        end
        
        if IsValid(self.Weapon) and self.Weapon:GetOwner() != LocalPlayer() then
            self.Weapon = nil
        end

        if self:IsHovered() and self.Weapon then
            if fastloot then  
                self:Drop()
            end
        end
        
        for i, w in ipairs(weps) do
            if PosI == i and (not IsValid(self.Weapon) or (IsValid(self.Weapon) and self.Weapon:GetOwner() != LocalPlayer())) then
                if w == NULL then
                    continue 
                end
                if Parent[PosI] and Parent[PosI].Weapon == nil or Parent[PosI] and Parent[PosI].Weapon != nil and Parent[PosI].Weapon:GetOwner() != LocalPlayer() then
                    Parent[PosI].Weapon = w
                    
                    if Parent[PosI + 1] and Parent[PosI + 1].Weapon == w or IsValid(Parent[PosI + 1].Weapon) and Parent[PosI + 1].Weapon:GetOwner() != LocalPlayer() then
                        Parent[PosI + 1].Weapon = nil
                    end
                    
                    if Parent[PosI - 1] then
                        local prevWeapon = Parent[PosI - 1].Weapon
                        if prevWeapon == nil or (IsValid(prevWeapon) and prevWeapon:GetOwner() != LocalPlayer()) then
                            Parent[PosI - 1].Weapon = w
                        end
                    end
                end
            end
        end
        if IsValid(self.Weapon) and self.Weapon:GetOwner() == LocalPlayer() then
            self.LowerText = (self.Weapon != nil and (hg.GetPhrase(self.Weapon:GetClass()) != self.Weapon:GetClass() and hg.GetPhrase(self.Weapon:GetClass()) or weapons.Get(self.Weapon:GetClass()).PrintName) or "")
        elseif IsValid(self.Weapon) and self.Weapon:GetOwner() != LocalPlayer() or !IsValid(self.Weapon) then
            self.LowerText = " "
        end

        self:LoadPaint()

        if self.Weapon then
            hg.DrawWeaponSelection(weapons.Get((isstring(self.Weapon) and self.Weapon or self.Weapon:GetClass())),Parent:GetX() + SlotsSize * (PosI - 1),Parent:GetY(),self:GetWide(),self:GetTall(),0)
        end

        draw.SimpleText(self.LowerText, (self.LowerFont or "HS.18"), w / 2, h / 1.2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    return InvButton
end

function CreateJModFrame(weps,ent1,ent)
    local MainFrame = panelka
    local SlotsSize = 75

    if !IsValid(ScoreBoardPanel) then
        return
    end

    local CenterX = ScoreBoardPanel:GetWide() / 2

    hg.islooting = true

    local LootFrame = vgui.Create("hg_frame",MainFrame)
    LootFrame:ShowCloseButton(false)
    LootFrame:SetTitle(" ")
    LootFrame:SetDraggable(false)
    LootFrame:SetSize(SlotsSize, SlotsSize)
    LootFrame:Center()
    LootFrame:SetX(LootFrame:GetX() - SlotsSize * (table.IsEmpty(weps) and 0 or 5))
    //LootFrame:SetPos(CenterX - ScrW()/6.4,ScrH()/2.14)
    LootFrame:DockMargin(0,0,0,0)
    LootFrame:DockPadding(0,0,0,0)
    LootFrame.NoDraw = true
    LootFrame.CurSize = 0.3
    LootFrame.CurSizeTarget = 1

    function LootFrame:Think()
        local targetsize = LootFrame.CurSizeTarget

        if !hg.islooting then
            LootFrame.CurSizeTarget = 0
            if self.CurSize <= 0.01 then
                self:Remove()
            end
        end
        self.CurSize = LerpFT((hg.islooting and 0.15 or 0.3),self.CurSize,targetsize)
        //self:Center()
        //self:SetWide(SlotsSize * slotsamt * self.CurSize)
    end

    CreateJModEntInvSlot(LootFrame,SlotsSize,1,ent1,weps)
end

function CreateLootFrame(weps,slotsamt,ent)
    local MainFrame = panelka
    local SlotsSize = 75

    if table.IsEmpty(weps) and ent:GetNWEntity("JModEntInv") != NULL then
        return
    end

    if !IsValid(ScoreBoardPanel) then
        return
    end

    local CenterX = ScoreBoardPanel:GetWide() / 2

    hg.islooting = true

    local LootFrame = vgui.Create("hg_frame",MainFrame)
    LootFrame:ShowCloseButton(false)
    LootFrame:SetTitle(" ")
    LootFrame:SetDraggable(false)
    LootFrame:SetSize(SlotsSize * slotsamt, SlotsSize)
    LootFrame:Center()
    //LootFrame:SetX(ScrW()/2)
    //LootFrame:SetPos(CenterX - ScrW()/6.4,ScrH()/2.14)
    LootFrame:DockMargin(0,0,0,0)
    LootFrame:DockPadding(0,0,0,0)
    LootFrame.NoDefault = true
    LootFrame.CurSize = 0

    local targetsize = 1

    function LootFrame:Think()
        local w,h = self:GetSize()
        if hg.islooting then
            targetsize = 1
        else
            targetsize = 0
            if self.CurSize <= 0.01 then
                self:Remove()
            end
        end
        self.CurSize = LerpFT((hg.islooting and 0.15 or 0.3),self.CurSize,targetsize)
        self:Center()
        //self:SetWide(SlotsSize * slotsamt * self.CurSize)
    end

    for i = 1, slotsamt do
        local Slot = CreateLootSlot(LootFrame,SlotsSize,i)
        LootFrame[i] = Slot
        Slot.BeingLooted = false
        Slot.LootAnim = 0 

        if weps[i] != nil then
            Slot.Weapon = (isstring(weps[i]) and weps[i] or weps[i]:GetClass())
        end

        function Slot:DoClick()
            self:Loot()
        end

        function Slot:SubPaint(w,h)
            if self:IsHovered() then
                if fastloot then  
                    self:Loot()
                end
            end
    
            self.LowerText = (self.Weapon != nil and weapons.Get(self.Weapon) and (hg.GetPhrase(self.Weapon) != self.Weapon and hg.GetPhrase(self.Weapon) or weapons.Get(self.Weapon).PrintName) or "")

            if self.BeingLooted then
                surface.SetDrawColor(225,225,225)
                self.LootAnim = LerpFT(0.2,self.LootAnim,self.LootAnim + 100)
            else
                surface.SetDrawColor(0,0,0,0)
            end
    
            surface.SetMaterial(Material("homigrad/vgui/loading.png"))
            surface.DrawTexturedRectRotated(w/2,h/2,w/1.75,h/1.75,self.LootAnim)
    
            local fixed_x,fixed_y = self:LocalToScreen(self:GetX(),self:GetY())
    
            if self.Weapon != nil and self.LootIn then
                if self.LootIn < CurTime() then
                    net.Start("hg loot")
                    net.WriteEntity(ent)
                    net.WriteString(self.Weapon)
                    net.SendToServer()
                    self.Weapon = nil
                    self.BeingLooted = false
                    surface.PlaySound("homigrad/vgui/panorama/cards_draw_one_04.wav")
                end
            end
    
            if self.Weapon and weapons.Get(self.Weapon) then
                hg.DrawWeaponSelection(weapons.Get(self.Weapon),(fixed_x - (SlotsSize * (i - 1))) - (SlotsSize) * (1 - LootFrame.CurSize),fixed_y,self:GetWide(),self:GetTall(),0)
            end
        end

        function Slot:Loot()
            if self.BeingLooted or self.Weapon == nil then
                return
            end
            self.BeingLooted = true
            surface.PlaySound("homigrad/vgui/panorama/inventory_new_item_scroll_01.wav")
            self.LootIn = CurTime() + 0.8
        end
    end
end