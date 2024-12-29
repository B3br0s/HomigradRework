--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801

CreateClientConVar("rsc_transfer", RSC.RECOMMENDED_SERVICE)
if not RSC.Service.Get( cvars.String("rsc_transfer") ) then GetConVar("rsc_transfer"):SetString( RSC.RECOMMENDED_SERVICE ) end

CreateClientConVar("rsc_quality", "1")
CreateClientConVar("rsc_save", "1")

local function PrepareImagePage()
    if not IsValid(RSC.GalleryPanel) then
        RSC.OpenGallery()
    end

    local page = RSC.GalleryPanel:CreatePage(nil, 1)

    page.overlay = vgui.Create("Panel", page)
    page.overlay:Dock(FILL)

    page.overlay.icon = vgui.Create("Panel", page.overlay)
    do
        local icon = page.overlay.icon
        icon:Dock(TOP)
        icon:DockMargin(0, 8, 0, 0)
        icon:SetTall(RSC.ScreenScale(48))
        icon.img = RSC.URLMaterial("https://i.imgur.com/9oEOdpJ.png", "smooth")
        icon.rotation = 0
        function icon:PerformLayout() self:DockMargin(0, self:GetParent():GetTall()/2 - self:GetTall() - RSC.ScreenScale(128), 0, 0) end
        function icon:AnimationThink()
            if not self.img or not self:IsEnabled() then return end
            if not self.rotationStart then
                self.rotationStart = SysTime()
                self.oldRotation = self.rotation
                if self.oldRotation == 360 then self.oldRotation = 0 end
            end

            local t = (SysTime() - self.rotationStart) / 0.5
            local e = math.ease.InOutQuint( math.min(t, 1) )

            self.rotation = self.oldRotation + 60 * e

            if t >= 1.5 then self.rotationStart = nil end
        end
        function icon:Paint(w, h)
            if not self.img or not self:IsEnabled() then return end

            surface.SetDrawColor( ColorAlpha(HSVToColor(self.rotation, 0.7, 0.7), 255) )
            surface.SetMaterial(self.img)
            surface.DrawTexturedRectRotated(w/2, h/2, h, h, self.rotation)
        end
    end

    page.overlay.title = vgui.Create("DLabel", page.overlay)
    do
        local title = page.overlay.title
        title:Dock(TOP)
        title:SetFont("RSC 48")
        title:SetText("#rsc.ui.in_progress")
        title:SetColor(color_white)
        title:SetContentAlignment(2)
        title:DockMargin(0, RSC.ScreenScale(8), 0, 0)
        function title:PerformLayout() self:SizeToContentsY() end
    end

    page.overlay.status = vgui.Create("Panel", page.overlay)
    do
        local status = page.overlay.status
        status:Dock(FILL)
        status:DockMargin(0, 8, 0, 0)
        function status:Append(message)
            local text = vgui.Create("DLabel", self)
            text:Dock(TOP)
            text:SetZPos(1)
            text:SetFont("RSC 18 Bold")
            text:SetText(message)
            text:SetColor(color_white)
            text:SetContentAlignment(5)
            text:SetAlpha(0)
            --text:SizeTo(0, , 0.2, 0, 5)
            text:AlphaTo(200, 0.1, 0)
            function text:PerformLayout() self:SizeToContentsY() end

            local children = self:GetChildren()
            if children[2] then
                children[2]:SetFont("RSC 18")
                children[2]:AlphaTo(100, 0.1)
            end

            return text
        end
        function status:AddNotify(from, message)
            return self:Append(("[%s] %s"):format(from, language.GetPhrase(message)))
        end
    end

    return page
end

local CaptureRequest = promise.Async(function(victim, serviceName, quality)
    local request = RSC.CaptureRequest.New()
    local page = PrepareImagePage()
    assert(IsValid(page), "couldn't create a gallery")

    function RSC.GalleryPanel:OnRemove()
        request:Remove()
    end

    local function notify(type, message, source)
        if not IsValid(page) then return end

        source = source == RSC.MESSAGE_SOURCE_VICTIM and "VICTIM" or
                 source == RSC.MESSAGE_SOURCE_SERVER and "SERVER" or
                 "USER"

        local label = page.overlay.status:AddNotify(source, message)
        if type == RSC.MESSAGE_TYPE_ERROR then
            page.overlay.icon:SetEnabled(false)
            page.overlay.title:SetText("#rsc.errors.error_happened")
            label:SetColor(Color(250, 82, 82))
        elseif type == RSC.MESSAGE_TYPE_SUCCESS then
            label:SetColor(Color(83, 198, 104))
        end
    end

    local onResult = promise.Async(function(request, ok, result)
        if not IsValid(page) then return end

        RSC.Log("info", ("Received result from server: %s - %q."):format(tostring(ok), tostring(result)))
        if not ok then return end

        notify(RSC.MESSAGE_TYPE_INFO, "#rsc.notify.downloading")
        local ok, captureData = request:GetService():Download(result, request:GetQuality(), request:GetPrepareData()):SafeAwait()
        if not ok then
            notify(RSC.MESSAGE_TYPE_ERROR, RSC.GetPhrase("rsc.errors.download_failed"):format(tostring(captureData)))
        return end

        page.overlay:Remove()
        page.overlay = nil

        local imageFormat = RSC.ParseQuality( request:GetQuality() )
        local path = cvars.Bool("rsc_save") and "rsc/" or "rsc/temp/"
        path = path .. os.date("%m-%d-%Y-%H-%M-%S-") .. util.CRC(captureData) .. "." .. (imageFormat == "jpeg" and "jpg" or imageFormat)

        file.CreateDir("rsc/temp")
        file.Write(path, captureData)

        RSC.Log("info", "Successfully received screengrab. Saved at data/" .. path)

        page:SetImage("data/" .. path)
        RSC.GalleryPanel:Update()

        for index, _page in ipairs(RSC.GalleryPanel.pages) do
            if page == _page then continue end
            if _page.img_src == page.img_src then
                RSC.GalleryPanel:RemovePage(index)
                break
            end
        end
    end)

    request.onMessage:On(function(request, type, message, source) notify(type, message, source) end)
    request.onResult:On(onResult)

    local ok, err = request:Capture(victim, serviceName, quality):SafeAwait()
    if not ok then notify(RSC.MESSAGE_TYPE_ERROR, err) end
end)

local function CreateButton(parent)
    local btn = vgui.Create("DButton", parent)
    btn:SetFont("RSC 16")
    btn.color = Color(64, 64, 64)
    btn.hoverColor = Color(77, 77, 77)
    btn.pressColor = Color(72, 72, 72)
    btn.disabledColor = Color(46, 46, 46)
    btn.textColor = Color(225, 225, 225)
    btn.disabledTextColor = Color(255, 255, 255, 20)
    btn:SetColor(btn.textColor)
    function btn:SetEnabled(val)
        DButton.SetEnabled(self, val)

        if self:IsEnabled() then
            self:SetColor(self.textColor)
        else
            self:SetColor(self.disabledTextColor)
        end
    end
    function btn:Paint(w, h)
        surface.SetDrawColor(self.color:Unpack())

        if self.Hovered then surface.SetDrawColor(self.hoverColor:Unpack()) end
        if self.Depressed then surface.SetDrawColor(self.pressColor:Unpack()) end
        if not self:IsEnabled() then surface.SetDrawColor(self.disabledColor:Unpack()) end

        if self.Depressed then
            surface.DrawRect(1, 0, w-2, h-1)
        else
            surface.DrawRect(0, 0, w, h)
        end
    end
    function btn:DoClick()
        surface.PlaySound("UI/buttonclick.wav")
    end

    return btn
end

local function CreateScrollPanel(parent)
    local pnl = vgui.Create("DScrollPanel", parent)
    pnl.color = Color(38, 38, 38)
    function pnl:Paint(w, h)
        surface.SetDrawColor(self.color:Unpack())
        surface.DrawRect(0, 0, w, h)
    end

    local vbar = pnl:GetVBar()
    vbar:SetHideButtons(true)
    function vbar:Paint(w, h) end
    function vbar.btnGrip:Paint(w, h)
        surface.SetDrawColor(64, 64, 64)
        surface.DrawRect(0, 0, w, h)
    end

    return pnl
end

local function CreateSeperator(parent)
    local seperator = vgui.Create("Panel", parent)
    local size = RSC.ScreenScale(1)
    seperator:SetSize(size, size)
    function seperator:Paint(w, h)
        surface.SetDrawColor(255, 255, 255, 5)
        surface.DrawRect(0, 0, w, h)
    end

    return seperator
end

local function CreateTopbar(frame)
    local topbar = vgui.Create("Panel", frame)
    topbar:Dock(TOP)
    topbar:SetTall(RSC.ScreenScale(24))
    function topbar:Think()
        local mousex = math.Clamp( gui.MouseX(), 1, RSC.ScrW - 1 )
        local mousey = math.Clamp( gui.MouseY(), 1, RSC.ScrH - 1 )
        if self.dragging then
            local x, y = mousex - self.dragging[1], mousey - self.dragging[2]

            x = math.Clamp(x, 0, RSC.ScrW - frame:GetWide())
            y = math.Clamp(y, 0, RSC.ScrH - frame:GetTall())

            frame:SetPos(x, y)
        end

        if self.Hovered then
            self:SetCursor("sizeall")
        end
    end
    function topbar:OnMousePressed()
        self.dragging = { gui.MouseX() - frame:GetX(), gui.MouseY() - frame:GetY() }
        self:MouseCapture(true)
    end
    function topbar:OnMouseReleased()
        self.dragging = nil
        self:MouseCapture(false)
    end

    do
        local seperator = CreateSeperator(frame)
        seperator:Dock(TOP)
    end

    frame.close = vgui.Create("DButton", topbar)
    do
        local close = frame.close
        close:Dock(RIGHT)
        close:SetText("")
        close:SetWide(RSC.ScreenScale(48))
        close.icon = RSC.URLMaterial("https://i.imgur.com/aIZlJWO.png", "smooth")
        local icon_size = RSC.ScreenScale(24)
        function close:Paint(w, h)
            surface.SetDrawColor(225, 225, 225)

            if self.Hovered then
                surface.SetDrawColor(250, 82, 82)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(255, 255, 255)
            end

            surface.SetMaterial(self.icon)
            surface.DrawTexturedRect(w/2 - icon_size/2, h/2 - icon_size/2, icon_size, icon_size)
        end
        function close:DoClick()
            surface.PlaySound("UI/buttonclick.wav")
            frame:SetMouseInputEnabled(false)
            frame:AlphaTo(0, 0.1, 0, function()
                frame:Remove()
            end)
        end
    end

    frame.title = vgui.Create("DLabel", topbar)
    do
        local title = frame.title
        title:Dock(FILL)
        title:DockMargin(RSC.ScreenScale(8), 0, 8, 0)
        title:SetText("Retro's Screencap")
        title:SetFont("RSC 18 Bold")
        title:SetColor(Color(250, 176, 5))
    end
end

local function CreatePlayer(ply)
    local pnl = vgui.Create("DButton")
    pnl:Dock(TOP)
    pnl:DockMargin(0, 0, 0, RSC.ScreenScale(4))
    pnl:DockPadding(RSC.ScreenScale(16), RSC.ScreenScale(6), RSC.ScreenScale(16), RSC.ScreenScale(6))
    pnl:SetTall(RSC.ScreenScale(48))
    pnl:SetText("")
    pnl.player = ply
    function pnl:Paint(w, h)
        if self.selected then
            surface.SetDrawColor(250, 176, 5)
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            surface.SetDrawColor(255, 255, 255, 5)
            surface.DrawRect(0, 0, w, h)
        end
        if self.Hovered then
            surface.SetDrawColor(255, 255, 255, 2)
            surface.DrawRect(0, 0, w, h)
        end
    end
    function pnl:DoClick()
        self.selected = true

        local players = self:GetParent():GetParent():GetParent()
        players:SetPlayer(self.player)
    end

    pnl.avatar = vgui.Create("AvatarImage", pnl)
    do
        local avatar = pnl.avatar
        avatar:Dock(LEFT)
        avatar:DockMargin(0, 0, RSC.ScreenScale(8), 0)
        avatar:SetPlayer(ply, 64)
        function avatar:PerformLayout() self:SetWide( self:GetTall() ) end
    end

    local function GetPlayerField(ply, field)
        if field == "name" then
            return ply:GetName()
        elseif field == "steamname" then
            if DarkRP then return ply:SteamName() else return ply:GetName() end
        elseif field == "steamid" then
            return ply:SteamID()
        elseif field == "steamid64" then
            return ply:SteamID64()
        elseif field == "usergroup" then
            return ply:GetUserGroup()
        end
    end

    pnl.topfield = vgui.Create("DLabel", pnl)
    do
        local topfield = pnl.topfield
        topfield:Dock(TOP)
        topfield:SetText(GetPlayerField(ply, RSC.Config.PlayerTopField) or GetPlayerField(ply, "name"))
        topfield:SetFont("RSC 16")
        topfield:SetColor(Color(233, 236, 239))
        topfield:SetContentAlignment(1)
        function topfield:PerformLayout() self:SetTall( pnl:GetTall() / 2 - 6 ) end
    end

    pnl.bottomfield = vgui.Create("DLabel", pnl)
    do
        local bottomfield = pnl.bottomfield
        bottomfield:Dock(FILL)
        bottomfield:SetText(GetPlayerField(ply, RSC.Config.PlayerBottomField) or GetPlayerField(ply, "steamid"))
        bottomfield:SetFont("RSC 16 Bold")
        bottomfield:SetColor(Color(255, 255, 255, 20))
        bottomfield:SetContentAlignment(1)
    end

    return pnl
end

local function CreatePlayerSearchBar(frame)
    frame.players.search = vgui.Create("Panel", frame.players)
    do
        local search = frame.players.search
        search:Dock(BOTTOM)
        search:SetTall( RSC.ScreenScale(36) )
        search.color = Color(38, 38, 38)
        function search:Paint(w, h)
            surface.SetDrawColor(self.color:Unpack())
            surface.DrawRect(0, 0, w, h)
        end

        local sep = CreateSeperator(frame.players)
        sep:Dock(BOTTOM)
    end

    frame.players.search.icon = vgui.Create("DImage", frame.players.search)
    frame.players.search.icon:Dock(LEFT)
    frame.players.search.icon:DockMargin( RSC.ScreenScale(8), RSC.ScreenScale(4), RSC.ScreenScale(8), RSC.ScreenScale(4) )
    frame.players.search.icon:SetMaterial( RSC.URLMaterial("https://i.imgur.com/1qAtYCG.png", "smooth") )
    frame.players.search.icon:SetKeepAspect(true)
    frame.players.search.icon.PerformLayout = function(self, w, h) self:SetWide(h) end

    frame.players.search.input = vgui.Create("DTextEntry", frame.players.search)
    frame.players.search.input:Dock(FILL)
    frame.players.search.input:SetFont("RSC 18")
    frame.players.search.input:SetPaintBackground(false)
    frame.players.search.input:SetCursorColor( Color(255, 255, 255, 150) )
    frame.players.search.input:SetPlaceholderColor( Color(255, 255, 255, 25) )
    frame.players.search.input:SetPlaceholderText("#rsc.ui.search_placeholder")
    frame.players.search.input:SetUpdateOnType(true)
    function frame.players.search.input:OnGetFocus()
        self:SetTextColor( self:GetCursorColor() )
        frame.players.search.icon:SetImageColor( self:GetCursorColor() )
    end
    function frame.players.search.input:OnLoseFocus()
        self:SetTextColor( self:GetPlaceholderColor() )
        frame.players.search.icon:SetImageColor( self:GetPlaceholderColor() )
    end
    function frame.players.search.input:OnValueChange(str)
        frame.players.filter = str:Trim() ~= "" and str:lower()
        frame.players:UpdatePlayers()
    end

    frame.players.search.input:OnLoseFocus()
end

local function CreatePlayerList(frame)
    frame.players = vgui.Create("Panel", frame)
    frame.players:Dock(LEFT)
    frame.players:DockMargin(RSC.ScreenScale(32), RSC.ScreenScale(16), RSC.ScreenScale(15), RSC.ScreenScale(8))
    function frame.players:PerformLayout()
        local ml, _, mr = self:GetDockMargin()
        self:SetWide(frame:GetWide() / 2 - ml - mr)
    end
    function frame.players:AddPlayer(ply)
        if not IsValid(ply) then return end

        local pnl = CreatePlayer(ply)
        self.inner:AddItem(pnl)
    end
    function frame.players:SetPlayer(ply)
        self.player = IsValid(ply) and ply or nil

        for _, pnl in ipairs( self.inner:GetCanvas():GetChildren() ) do
            pnl.selected = pnl.player == ply
        end

        frame.screengrab:SetEnabled( ply ~= nil )
    end
    function frame.players:GetPlayer()
        return self.player
    end
    function frame.players:FilterPlayer(ply)
        if not IsValid(ply) then return end
        if not self.filter then return true end

        if ply:GetName():lower():match(self.filter) then return true end
        if ply:SteamID():lower():match(self.filter) then return true end
        if ply:SteamID64() and ply:SteamID64():lower():match(self.filter) then return true end
        if ply:GetUserGroup():lower():match(self.filter) then return true end
    end
    frame.players.UpdatePlayers = promise.Async(function(self)
        local localPlayer = LocalPlayer()

        -- Checking everyone
        local players = {}
        for _, ply in ipairs(player.GetAll()) do
            players[#players + 1] = RSC.AsyncCanScreengrab(localPlayer, ply):Then(function(can)
                if can then return ply end
            end)
        end

        -- Transforming array of promises to array of players
        players = promise.All(players):Await()

        if not IsValid(self) then return end -- frame.players can become invalid
        self.inner:Clear()

        -- Adding players
        for _, ply in ipairs(players) do
            if self:FilterPlayer(ply) then
                self:AddPlayer(ply)
                if self:GetPlayer() == ply then self:SetPlayer(ply) end
            end
        end
    end)

    frame.players.inner = CreateScrollPanel(frame.players)
    frame.players.inner:Dock(FILL)


    frame.players:UpdatePlayers()
    -- Update players when they join or disconnect?

    CreatePlayerSearchBar(frame)
end

local function CreateButtons(frame)
    local bottom = vgui.Create("Panel", frame)
    bottom:Dock(BOTTOM)
    bottom:DockMargin(RSC.ScreenScale(36), 0, RSC.ScreenScale(32), RSC.ScreenScale(16))
    bottom:SetTall(RSC.ScreenScale(36))

    local left = vgui.Create("Panel", bottom)
    left:Dock(LEFT)
    function left:PerformLayout() self:SetWide( bottom:GetWide()/2 ) end

    frame.open_gallery = CreateButton(left)
    frame.open_gallery:Dock(FILL)
    frame.open_gallery:DockMargin(RSC.ScreenScale(32), 0, RSC.ScreenScale(48), 0)
    frame.open_gallery:SetText("#rsc.ui.open_gallery")
    function frame.open_gallery:DoClick()
        surface.PlaySound("UI/buttonclick.wav")

        RSC.OpenGallery()
        --frame:Remove()
    end

    frame.screengrab = CreateButton(bottom)
    frame.screengrab:Dock(FILL)
    frame.screengrab:DockMargin(RSC.ScreenScale(48), 0, RSC.ScreenScale(32), 0)
    frame.screengrab:SetText("#rsc.ui.screengrab")
    frame.screengrab:SetFont("RSC 16 Bold")
    frame.screengrab.color = Color(250, 176, 5)
    frame.screengrab.hoverColor = Color(252, 196, 25)
    frame.screengrab.pressColor = Color(245, 159, 0)
    frame.screengrab.textColor = Color(0, 0, 0)
    frame.screengrab:SetEnabled(false)
    function frame.screengrab:DoClick()
        surface.PlaySound("UI/buttonclick.wav")
        CaptureRequest(frame.players:GetPlayer(), cvars.String("rsc_transfer"), cvars.Number("rsc_quality"))
    end
end

local function CreateOptionCategory(parent, text)
    local label = vgui.Create("DLabel", parent)
    label:Dock(TOP)
    label:DockMargin(0, RSC.ScreenScale(8), 0, RSC.ScreenScale(4))
    label:SetFont("RSC 18 Bold")
    label:SetText(text)
    label:SetColor(Color(225, 225, 225))
    function label:PerformLayout() self:SetTall( select(2, self:GetContentSize()) ) end

    return label
end

local function CreateCheckbox(parent)
    local check = vgui.Create("DCheckBoxLabel", parent)
    local size16 = RSC.ScreenScale(16)
    local size1 = RSC.ScreenScale(1)

    check:SetSize(size16, size16)
    check:SetFont("RSC 16")
    check.Label:SetMouseInputEnabled(false)
    function check:PerformLayout()
        self.Button:SetPos(size1, size1)
        self.Button:SetSize(size16 - size1, size16 - size1)

        self.Label:SizeToContents()
        self.Label:SetPos(size16 + RSC.ScreenScale(9), (size16 - self.Label:GetTall()) / 2)
    end

    return check
end

local function CreateOptionForm(parent)
    local form = vgui.Create("DSizeToContents", parent)
    form:Dock(TOP)
    form:DockMargin(RSC.ScreenScale(16), 0, 0, RSC.ScreenScale(4))
    function form:OnChange()
        if self.changing then return end
        self.changing = true

        for _, check in ipairs( self:GetChildren() ) do
            if not check:IsEnabled() then continue end
            check:SetValue( check.convar:GetString() == check.value )
        end

        self.changing = false
    end

    function form:Checkbox(label, convar, value)
        local check = CreateCheckbox(self)
        check:Dock(TOP)
        check:DockMargin(0, 0, 0, RSC.ScreenScale(4))
        check:SetText(label)
        check.value = value
        check.convar = GetConVar(convar)
        function check:OnChange(val)
            if val then
                self.convar:SetString(self.value)
            end

            self:GetParent():OnChange()
        end
        local _SetText = check.SetText
        function check:SetText(label)
            _SetText(self, label)
            self:InvalidateLayout()
        end

        self:OnChange()
        return check
    end

    return form
end

local function CreateOptions(frame)
    frame.options = CreateScrollPanel(frame)
    frame.options:Dock(FILL)
    frame.options:DockMargin(16, 16, 32, 8)
    frame.options.color = color_transparent

    local title = CreateOptionCategory(frame.options, "#rsc.ui.options")
    title:DockMargin(0, 0, 0, 0)
    title:SetContentAlignment(5)

    CreateOptionCategory(frame.options, "#rsc.ui.transfer_service")
    do
        local transfer = CreateOptionForm(frame.options)
        for _, service in pairs(RSC.Service.Services) do
            local name = service:GetName()

            local check = transfer:Checkbox(name, "rsc_transfer", name)
            --check:SetTooltip(api.Description)

            local ping = vgui.Create("DImage", check)
            ping:SetSize(RSC.ScreenScale(16), RSC.ScreenScale(16))
            ping:SetImage("icon16/error.png")
            ping:SetTooltip("#rsc.ui.checking_status")
            ping:SetMouseInputEnabled(true)
            function ping:PerformLayout()
                local label = self:GetParent().Label
                self:SetX(label:GetX() + label:GetContentSize() + 8)
            end

            coroutine.wrap(function()
                local ok, status = promise.Resolve( service:Ping() ):SafeAwait()
                ok = ok and status
                if not IsValid(ping) then return end
                ping:SetImage(ok and "icon16/accept.png" or "icon16/exclamation.png")
                ping:SetTooltip(ok and "#rsc.ui.online" or "#rsc.ui.offline")
            end)()
        end

        local moreLater = transfer:Checkbox("#rsc.ui.more_later", "rsc_transfer")
        moreLater:SetEnabled(false)
    end

    CreateOptionCategory(frame.options, "#rsc.ui.image_quality")
    do
        local quality = CreateOptionForm(frame.options)
        quality:Checkbox("#rsc.ui.quality_best", "rsc_quality", "2")
        quality:Checkbox("#rsc.ui.quality_good", "rsc_quality", "1")
        quality:Checkbox("#rsc.ui.quality_low", "rsc_quality", "0")
    end

    CreateOptionCategory(frame.options, "#rsc.ui.other")
    do
        local save_images = CreateCheckbox(frame.options)
        save_images:Dock(TOP)
        save_images:DockMargin(RSC.ScreenScale(16), 0, 0, RSC.ScreenScale(4))
        save_images:SetText("#rsc.ui.save_screengrabs")
        save_images:SetFont("RSC 16")
        save_images:SetConVar("rsc_save")
    end
end

RSC.AdminMenu = nil
function RSC.OpenMenu()
    if IsValid(RSC.AdminMenu) then
        RSC.AdminMenu:Remove()
        RSC.AdminMenu = nil
    end

    local ply = LocalPlayer()
    RSC.HasAccess(ply, function(can)
        if not can then
            chat.AddText(Color(255, 0, 0), "[RSC] ", Color(255, 255, 255), "#rsc.errors.no_rights")
            return
        end

        RSC.AdminMenu = vgui.Create("EditablePanel")

        local frame = RSC.AdminMenu
        frame:SetSize(math.min(RSC.ScreenScale(768), RSC.ScrW), math.min(RSC.ScreenScale(500), RSC.ScrH))
        frame:Center()
        frame:SetAlpha(0)
        frame:AlphaTo(255, 0.1)
        frame:MakePopup()

        function frame:Paint(w, h)
            surface.SetDrawColor(51, 51, 51)
            surface.DrawRect(0, 0, w, h)
        end

        CreateTopbar(frame)
        CreateButtons(frame)

        CreatePlayerList(frame)

        do
            local seperator = CreateSeperator(frame)
            seperator:Dock(LEFT)
        end

        CreateOptions(frame)
    end)
end

concommand.Add("rsc_menu", RSC.OpenMenu)

-- Do not overwrite screengrab concommand if it is already exists
if not concommand.GetTable()["screengrab"] then
    concommand.Add("screengrab", RSC.OpenMenu)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801