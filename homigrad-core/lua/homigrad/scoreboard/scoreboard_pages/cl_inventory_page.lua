local open = false
local panelka

local lply = LocalPlayer()

local weps = {}
local loot_queue = {} //куэуэ
local obrabotka_active = false
local cur = NULL

surface.CreateFont("InvFont",{
        font = "Arial",
        size = 12 * ScrMul(),
        weight = 0,
        outline = true,
        shadow = true,
        antialias = false,
        additive = true,
    })

local BlackList = {
    ["weapon_hands"] = true,
    ["weapon_physgun"] = true,
    ["gmod_tool"] = true,
    ["gmod_camera"] = true,
}

hook.Add("Think","ObrabotkaQueui",function()
    if LocalPlayer():Alive() and hg.ScoreBoard == 3 then
        if !table.IsEmpty(loot_queue) then
            obrabotka_active = true
            for _, item in ipairs(loot_queue) do
                if cur == NULL then
                    cur = item
                    table.remove(loot_queue,_)
                else
                    if IsValid(item) and item != cur then
                        item.LootIn = CurTime() + 0.3
                        if item.Item then
                            item.LootIn = CurTime() + 0.25 * (item.Item.Weight or 1)
                        end
                    end
                end
            end
        end
    end

    if cur.LootIn and cur.LootIn < CurTime() then
        cur:Loot()
        cur = NULL
    end

    if !open then
        obrabotka_active = false
        cur = NULL
    end
end)

local function CreateArmorSlot(parent,placement,posx,posy,sizex,sizey)
    
    local zalupa_konya = vgui.Create("hg_slot",parent)
    local button = zalupa_konya
    button:SetPos(posx,posy)
    button:SetSize(sizex,sizey)
    button:SetText(" ")
    button.ItemIcon = (LocalPlayer().armor[placement] != "NoArmor" and hg.Armors[LocalPlayer().armor[placement]].Icon or "null")
    button.Item = (LocalPlayer().armor[placement] != "NoArmor" and hg.Armors[LocalPlayer().armor[placement]] or nil)
    button.LootAnim = 0

    function button:SubPaint(w,h)
        self.Item = (LocalPlayer().armor[placement] != "NoArmor" and hg.Armors[LocalPlayer().armor[placement]] or nil)
        self.ItemIcon = (LocalPlayer().armor[placement] != "NoArmor" and hg.Armors[LocalPlayer().armor[placement]].Icon or "null")
        if fastloot and !self.isdropping and self.Item != nil and self:IsHovered() then
            self:Drop()
        end
        if self.isdropping and self.Item != nil then
            surface.SetDrawColor(225,225,225)
                
            self.LootAnim = LerpFT(0.2,self.LootAnim,self.LootAnim + 100)
    
            surface.SetMaterial(Material("homigrad/vgui/loading.png"))
            surface.DrawTexturedRectRotated(w/2,h/2,w/1.75,h/1.75,self.LootAnim)
            if self.dropsin < CurTime() then
                surface.PlaySound("homigrad/weapons/holster_pistol.mp3")
                self.isdropping = false
                net.Start("hg drop armor")
                net.WriteString(placement)
                net.SendToServer()
            end
        end
    end

    function button:Drop()
        button.isdropping = true
        button.dropsin = CurTime() + 0.4
        surface.PlaySound("homigrad/vgui/item_scroll_sticker_01.wav")
    end

    function button:DoClick()
        if self.Item != nil and !self.isdropping then
            self:Drop()
        end
    end

    function button:DoRightClick()
        local Menu = DermaMenu(true,self)

        Menu:SetPos(input.GetCursorPos())
        Menu:MakePopup()

        if self.Item != nil then
            Menu:AddOption(hg.GetPhrase("inv_drop"),function()
                self:Drop()
            end)
        end
    end

    return button
end

local function CreateLocalInvSlot(Parent,SlotsSize,PosI)
    local InvButton = vgui.Create("hg_slot",Parent)
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

    function InvButton:SubPaint(w, h)
        local weps = {}
        for _, wep in ipairs(LocalPlayer():GetWeapons()) do
            if not BlackList[wep:GetClass()] and !table.HasValue(weps, wep) then
                table.insert(weps, wep)
            end
        end

        if IsValid(self.Weapon) and self.Weapon:GetOwner() ~= LocalPlayer() then
            self.Weapon = nil
        end

        if self:IsHovered() and self.Weapon and fastloot then
            self:Drop()
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

        self.Item = self.Weapon

        //if IsValid(self.Weapon) and self.Weapon:GetOwner() == LocalPlayer() then
        //    self.LowerText = (self.Weapon != nil and (hg.GetPhrase(self.Weapon:GetClass()) != self.Weapon:GetClass() and hg.GetPhrase(self.Weapon:GetClass()) or weapons.Get(self.Weapon:GetClass()).PrintName) or "")
        //elseif IsValid(self.Weapon) and self.Weapon:GetOwner() != LocalPlayer() or !IsValid(self.Weapon) then
        //    self.LowerText = " "
        //end

        self:LoadPaint()

        if IsValid(self.Weapon) then
            hg.DrawWeaponSelection(weapons.Get(self.Weapon:GetClass()), 
                Parent:GetX() + SlotsSize * (PosI - 1), Parent:GetY(), 
                self:GetWide(), self:GetTall(), 0)
        end

        //draw.SimpleText(self.LowerText, self.LowerFont or "HS.18", w/2, h/1.2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    return InvButton
end

hook.Add("HUDPaint","InventoryPage",function()
    if not hg.ScoreBoard then return end
    if not IsValid(ScoreBoardPanel) then open = false if !table.IsEmpty(loot_queue) then table.Empty(loot_queue) end return end
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
            elseif hg.islooting and IsValid(hg.lootent) and hg.lootent != NULL then
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

        local SlotsSize = 75 * math.min(ScrW()/1920,ScrH()/1080)

        local InvFrame = vgui.Create("hg_frame",MainFrame)
        InvFrame:ShowCloseButton(false)
        InvFrame:SetTitle(" ")
        InvFrame:SetDraggable(false)
        InvFrame:SetSize(ScrW() / 3.2, SlotsSize)
        InvFrame:Center()
        InvFrame:SetPos(InvFrame:GetX(),ScrH()-SlotsSize)
        InvFrame:DockMargin(0,0,0,0)
        InvFrame:DockPadding(0,0,0,0)

        local ModelFrame = vgui.Create("DModelPanel",MainFrame)
        ModelFrame:SetSize(ScrW()/4.5,ScrH()/2)
        ModelFrame:SetModel(LocalPlayer():GetModel())
        ModelFrame:SetPos(ModelFrame:GetWide()/5,ModelFrame:GetTall()/2.5) 
        ModelFrame:GetEntity().GetPlayerColor = function()
            return LocalPlayer():GetPlayerColor()
        end

        local zaebal = 1
        local mdls = {
        }

        function ModelFrame:Paint( w, h )

            if GetConVar("developer"):GetBool() then
                draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
            end

            local ply = LocalPlayer()

            local armor_torso = ply.armor.torso
            local armor_head = ply.armor.head
            local armor_face = ply.armor.face
            local armor_back = ply.armor.back

        	if ( !IsValid( self.Entity ) ) then return end

        	local x, y = self:LocalToScreen( 0, 0 )

        	self:LayoutEntity( self.Entity )

        	local ang = self.aLookAngle
        	if ( !ang ) then
        		ang = ( self.vLookatPos - self.vCamPos ):Angle()
        	end

            //local xshit,yshit = self:ScreenToLocal(gui.MouseX(),gui.MouseY() - h/2)

            //print(yshit)
        
        	cam.Start3D( self.vCamPos + Vector(5,0,0), ang, self.fFOV, x, y, w, h, 5, self.FarZ )
        
        	render.SuppressEngineLighting( true )
        	render.SetLightingOrigin( self.Entity:GetPos() )
        	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
        	render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
        	render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) ) -- * surface.GetAlphaMultiplier()
        
        	for i = 0, 6 do
        		local col = self.DirectionalLight[ i ]
        		if ( col ) then
        			render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
        		end
        	end
        
        	self:DrawModel()

            local ent = self.Entity

            ent.IsIcon = true

            for placement, armor in pairs(ply.armor) do
                    local tbl = hg.Armors[armor]
                    if tbl != nil then

                        if mdls[placement] == nil then
                            mdls[placement] = ClientsideModel(tbl.Model,RENDERGROUP_OTHER)
                            mdls[placement]:SetNoDraw( true )
                            mdls[placement]:SetIK( false )
                            mdls[placement]:SetParent(ent)
                            mdls[placement]:AddEffects(EF_BONEMERGE)
                            mdls[placement].DontOptimise = true
                        end

                        if mdls[placement]:GetModel() != tbl.Model then
                            mdls[placement]:Remove()
                            mdls[placement] = nil
                        end

                        if mdls[placement] == nil then
                            continue 
                        end

                        mdls[placement]:DrawModel()

                        local pos,ang = ent:GetBonePosition(ent:LookupBone(tbl.Bone))
        
                        ang:RotateAroundAxis(ang:Forward(),tbl.Ang[1])
                        ang:RotateAroundAxis(ang:Up(),tbl.Ang[2])
                        ang:RotateAroundAxis(ang:Right(),tbl.Ang[3])

                        if !hg.IsFemale(ent) or !tbl.FemPos then
                            pos = pos + ang:Forward() * tbl.Pos[1]
                            pos = pos + ang:Right() * tbl.Pos[2]
                            pos = pos + ang:Up() * tbl.Pos[3]
                        else
                            pos = pos + ang:Forward() * tbl.FemPos[1]
                            pos = pos + ang:Right() * tbl.FemPos[2]
                            pos = pos + ang:Up() * tbl.FemPos[3]
                        end

                        //ent:SetPredictable(true)
                        //ent:SetupBones()

                        mdls[placement]:SetBodygroup(0,1)
                        mdls[placement]:SetParent(ent)

                        mdls[placement]:SetRenderOrigin(pos)
                        mdls[placement]:SetRenderAngles(ang)
                        
                        mdls[placement]:SetModelScale(((hg.IsFemale(ent) and tbl.FemScale) and tbl.FemScale or tbl.Scale) or 1,0)

                        mdls[placement]:SetPos(pos)
                        mdls[placement]:SetAngles(ang)

                        //mdls[placement]:SetPredictable(true)
                        //mdls[placement]:SetupBones()

                        //ent.armor_render[placement]:DrawModel()
                    else
                        //if ent.armor_render[placement] != nil then
                        //    ent.armor_render[placement]:Remove()
                        //    ent.armor_render[placement] = nil
                        //end
                    end
                end
        
        	render.SuppressEngineLighting( false )
        	cam.End3D()
        
        	self.LastPaint = RealTime()
        
        end

        local daun_rubat = 1.2

        function ModelFrame:LayoutEntity(ent)
            if not IsValid(ent) then return end

            ent.IsIcon = true

            local w, h = self:GetSize()
            local xshit = gui.MouseX()

            if !rot_suka then
                rot_suka = 0
            end

            if self:IsHovered() and input.IsMouseDown(MOUSE_LEFT) then
                if not isDragging then
                    isDragging = true
                    xshit_old = xshit
                end

                local delta = (xshit - xshit_old or 0) * 0.75
                rot_suka = rot_suka + delta
                xshit_old = xshit
            else
                isDragging = false
            end

            daun_rubat = LerpFT(0.2, daun_rubat or 0, self:IsHovered() and 1.2 or 0.9)

            local pos = ent:GetBonePosition(0) or ent:GetPos()
            self:SetCamPos(Vector(50 / daun_rubat * (ScrH()/1080), 0, pos.z + 6))
            self:SetLookAt(pos)

            zalupa_konya = LerpFT(0.1, zalupa_konya or 0, rot_suka)
            ent:SetAngles(Angle(0, zalupa_konya, 0))
        end

        local SlotsSize = 64 * ScrMul()

        CreateArmorSlot(ModelFrame,"head",SlotsSize*4.6,SlotsSize,SlotsSize,SlotsSize)
        CreateArmorSlot(ModelFrame,"face",SlotsSize*5.6,SlotsSize,SlotsSize,SlotsSize)
        CreateArmorSlot(ModelFrame,"torso",SlotsSize*4.6,SlotsSize*3,SlotsSize,SlotsSize)
        CreateArmorSlot(ModelFrame,"back",SlotsSize*5.6,SlotsSize*3,SlotsSize,SlotsSize)
        CreateArmorSlot(ModelFrame,"larm",SlotsSize*1.1,SlotsSize*3,SlotsSize,SlotsSize)
        CreateArmorSlot(ModelFrame,"rarm",SlotsSize*0.1,SlotsSize*3,SlotsSize,SlotsSize)
        CreateArmorSlot(ModelFrame,"lleg",SlotsSize*1.1,SlotsSize*5,SlotsSize,SlotsSize)
        CreateArmorSlot(ModelFrame,"rleg",SlotsSize*0.1,SlotsSize*5,SlotsSize,SlotsSize)

        local SlotsSize = 75 * ScrMul()

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

        local SlotsSize = 75 * ScrMul()

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
                    Slot.Item = wep
                end
            end
        end
    elseif hg.ScoreBoard != 3 then
        hg.islooting = false
        if !table.IsEmpty(loot_queue) then table.Empty(loot_queue) end
        open = false
        if IsValid(panelka) then
            panelka:Remove()
        end
    end
end)

function CreateLootSlot(Parent,SlotsSize,PosI,ent)
    local InvButton = vgui.Create("hg_slot",Parent)
    InvButton:SetSize(SlotsSize, SlotsSize)
    InvButton:SetPos(Parent:GetWide()/2,0)
    InvButton:Center()
    //InvButton:Dock(LEFT)
    //InvButton:DockMargin(SlotsSize * (1-Parent.CurSize),0,0,0)
    InvButton:SetText(" ")

    function InvButton:DoRightClick()
    end

    function InvButton:Loot_Take()
        if self.Looting and self.Item then
            return 
        end
        if !self.Item then
            return 
        end
        surface.PlaySound("homigrad/vgui/item_scroll_sticker_01.wav")
        self.Looting = true
        self.LootIn = CurTime() + 0.4 * (self.Item.Weight or 1)
        table.insert(loot_queue,self)
    end

    
    function InvButton:Loot()
        if self.Item.ishgwep then
            surface.PlaySound("homigrad/vgui/panorama/rotate_weapon_0"..math.random(1,3)..".wav")
        else
            surface.PlaySound("homigrad/vgui/panorama/inventory_new_item_scroll_01.wav")
        end
        net.Start("hg loot")
        net.WriteEntity(ent)
        net.WriteString(self.Item.ClassName)
        net.SendToServer()
        self.Item = nil
    end

    function InvButton:SubPaint(w,h)
        if self.Item then
            hg.DrawWeaponSelection(weapons.Get(self.Item.ClassName), 
                    Parent:GetX() + SlotsSize * (PosI - 1), Parent:GetY(), 
                    self:GetWide(), self:GetTall(), 0)

            if self.Looting then
                self.LootAnim = LerpFT(0.2,self.LootAnim or 0,(self.LootAnim or 0) + 100)

                surface.SetDrawColor(255,255,255)
                surface.SetMaterial(Material("homigrad/vgui/loading.png"))
                surface.DrawTexturedRectRotated(w/2,h/2,w/1.75,h/1.75,self.LootAnim)
            end
        end
    end

    function InvButton:DoClick()
        self:Loot_Take()
    end
    
    function InvButton:Think()
        local w,h = Parent:GetSize()

        if self:IsHovered() and fastloot then
            self:Loot_Take()
        end

        self:SetWide(SlotsSize * Parent.CurSize)
        self:SetX((w / 2) * (1-Parent.CurSize) + ((SlotsSize * (PosI - 1))) * Parent.CurSize)
    end

    return InvButton
end

function CreateJModEntInvSlot(Parent,SlotsSize,PosI,ent,weps)
    local InvButton = vgui.Create("hg_slot",Parent)
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
            self:Loot_Take()
        end
    end

    function InvButton:Loot()
        net.Start("hg loot jmod")
        net.WriteEntity(ent)
        net.SendToServer()
        ent = nil
        //Parent.CurSizeTarget = 0
        self.BeingLooted = false
        surface.PlaySound("homigrad/vgui/panorama/cards_draw_one_04.wav")
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
                    self:Loot_Take()
                end
            end
        end

        if !ent then
            return 
        end

        local jent = ent:GetNWEntity("JModEntInv",NULL)

        self.Item = (jent != NULL and jent or nil)
        
        if IsValid(jent) and jent != NULL then
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(Material("entities/"..jent:GetClass()..".png"))
            surface.DrawTexturedRect(w-w/1.15,h-h/1.15,w/1.3,h/1.3)
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
                self:Loot_Take()
            end
        end

        surface.SetMaterial(Material("homigrad/vgui/loading.png"))
        surface.DrawTexturedRectRotated(w/2,h/2,w/1.75,h/1.75,self.LootAnim)
    end

    function InvButton:Loot_Take()
        if self.BeingLooted then
            return
        end
        self.BeingLooted = true
        surface.PlaySound("homigrad/vgui/panorama/inventory_new_item_scroll_01.wav")
        table.insert(loot_queue,self)
        self.LootIn = CurTime() + 0.8
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
        local Slot = CreateLootSlot(LootFrame,SlotsSize,i,ent)
        LootFrame[i] = Slot

        local wep = weapons.Get(weps[i])

        Slot.Item = wep

        if !wep then
            continue 
        end
    end
end