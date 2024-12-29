
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
local function CreateTopbar(frame)
    local size24 = RSC.ScreenScale(24)
    local topbar = vgui.Create("Panel", frame)
    topbar:Dock(TOP)
    topbar:SetTall(RSC.ScreenScale(32))

    frame.close = vgui.Create("DButton", topbar)
    do
        local close = frame.close
        close:Dock(RIGHT)
        close:SetWide(topbar:GetTall())
        close:SetText("")
        close.icon = RSC.URLMaterial("https://i.imgur.com/aIZlJWO.png", "smooth")
        function close:Paint(w, h)
            if self.Hovered then
                surface.SetDrawColor(250, 82, 82)
                surface.DrawRect(0, 0, w, h)
            end

            surface.SetDrawColor(255, 255, 255, self.Hovered and 255 or 150)
            surface.SetMaterial(self.icon)
            surface.DrawTexturedRect((w - size24)/2, (h - size24)/2, size24, size24)
        end
        function close:DoClick()
            surface.PlaySound("UI/buttonclick.wav")
            frame:SetMouseInputEnabled(false)
            frame:AlphaTo(0, 0.1, 0, function()
                frame:Remove()
            end)
        end
    end
    frame.delete = vgui.Create("DButton", topbar)
    do
        local delete = frame.delete
        delete:Dock(RIGHT)
        delete:SetWide(topbar:GetTall())
        delete:SetText("")
        delete.icon = RSC.URLMaterial("https://i.imgur.com/2KP8vZk.png", "smooth")
        function delete:Paint(w, h)
            surface.SetDrawColor(255, 255, 255, 150)

            if self.Hovered then
                surface.SetDrawColor(255, 255, 255, 255)
            end
            if self.Depressed then
                surface.SetDrawColor(255, 255, 255, 170)
            end
            if not self:IsEnabled() then
                surface.SetDrawColor(255, 255, 255, 10)
            end

            surface.SetMaterial(self.icon)
            surface.DrawTexturedRect((w - size24)/2, (h - size24)/2, size24, size24)
        end
        function delete:DoClick()
            surface.PlaySound("UI/buttonclick.wav")

            file.Delete(self.src)
            frame:RemovePage(frame.currentPage)
            frame:ChangePage(frame.currentPage - 1)
        end
    end

    frame.pageNum = vgui.Create("DLabel", topbar)
    do
        local pageNum = frame.pageNum
        pageNum:Dock(LEFT)
        pageNum:DockMargin(RSC.ScreenScale(8), 0, RSC.ScreenScale(8), 0)
        pageNum:SetFont("RSC 24")
        pageNum:SetColor(color_white)
        pageNum:SetWide(64)
        pageNum:SetContentAlignment(5)
        pageNum:SetText("0/0")
        function pageNum:PerformLayout() self:SizeToContentsX() end
    end

    frame.title = vgui.Create("DLabel", topbar)
    do
        local title = frame.title
        title:Dock(LEFT)
        title:DockMargin(0, 0, RSC.ScreenScale(8), 0)
        title:SetFont("RSC 18")
        title:SetColor(Color(255, 255, 255, 150))
        title:SetText("Gallery")
        title:SetContentAlignment(4)
        function title:PerformLayout() self:SizeToContentsX() end
    end

    frame.description = vgui.Create("DLabel", topbar)
    do
        local description = frame.description
        description:Dock(LEFT)
        description:SetFont("RSC 16")
        description:SetColor(Color(255, 255, 255, 50))
        description:SetText("Try screengrab someone!")
        description:SetContentAlignment(4)
        function description:PerformLayout() self:SizeToContentsX() end
    end
end

local function CreateImagePanel(parent)
    local pnl = vgui.Create("Panel", parent)
    pnl:Dock(FILL)
    function pnl:SetImage(img)
        self.img = img
        if isstring(img) then self.img_src = img end
    end
    function pnl:GetImage()
        return self.img
    end
    function pnl:PerformLayout(w, h)
        if type(self.img) ~= "IMaterial" then return end
        local texW, texH = self.img:Width(), self.img:Height()
        local imgW, imgH = w, texH * w / texW

        if imgH > h then
            imgW, imgH = texW * h / texH, h
        end

        self._imgW = imgW
        self._imgH = imgH
        self._imgX = w/2 - self._imgW/2
        self._imgY = h/2 - self._imgH/2

        self.imgW = self._imgW
        self.imgH = self._imgH
        self.imgX = self._imgX
        self.imgY = self._imgY
    end
    function pnl:Paint(w, h)
        if not self.img then return end
        if isstring(self.img) then
            self.img = Material(self.img, "smooth")
            self:InvalidateLayout(true)
        end

        surface.SetMaterial(self.img)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRect(self.imgX, self.imgY, self.imgW, self.imgH)
    end
    function pnl:Think()
        if not self.img then return end
        local width, height = self:GetSize()
        if not self._imgX then return end

        if not self.pressed then
            self:SetCursor("arrow")

            if not self.zoom then
                self.imgW = self._imgW
                self.imgH = self._imgH
                self.imgY = self._imgY

                local diff = self.imgX - self._imgX
                local maxDiff = RSC.ScrW * 0.3
                if (diff < -maxDiff or diff > maxDiff) and self:OnPageChange(diff > maxDiff) then
                    self.lastClick = nil
                end

                if self.lastClick then
                    self.imgX = Lerp(SysTime() - self.lastClick, self.imgX, self._imgX)
                else
                    self.imgX = self._imgX
                end
            end
        else
            self:SetCursor("sizeall")

            local x, y = gui.MouseX() - self.pressedAt[1], gui.MouseY() - self.pressedAt[2]
            if not self.zoom then
                self.imgX = self._imgX + x
            else
                if self.imgW > width then self.imgX = math.Clamp(self._imgX + x, width - self.imgW, 0) end
                if self.imgH > height then self.imgY = math.Clamp(self._imgY + y, height - self.imgH, 0) end
            end
        end
    end
    function pnl:OnMousePressed(code)
        if code ~= MOUSE_LEFT then return end

        self:MouseCapture(true)
        self.pressed = SysTime()
        self.pressedAt = { gui.MouseX(), gui.MouseY() }
    end
    function pnl:OnMouseReleased(code)
        if code ~= MOUSE_LEFT then return end

        self:MouseCapture(false)
        self.pressed = nil

        if self.lastClick and (self.lastClick + 0.2) > SysTime() then
            self:ToggleZoom()
            self.lastClick = nil
        else
            self.lastClick = SysTime()

            if self.zoom then
                self._imgX = self.imgX
                self._imgY = self.imgY
            end
        end
    end
    function pnl:ToggleZoom()
        self.zoom = not self.zoom

        if self.zoom then
            local width, height = self:GetSize()
            local x, y = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
            if x < 0 or y < 0 then
                x = width/2
                y = height/2
            end


            self.imgW = self._imgW * 2
            self.imgH = self._imgH * 2
            self._imgX = width/2 - self.imgW/2
            self._imgY = height/2 - self.imgH/2

            local centerX, centerY = self._imgX + self.imgW/2, self._imgY + self.imgH/2
            if self.imgW > width then self._imgX = self._imgX - (x - centerX) end
            if self.imgH > height then self._imgY = self._imgY - (y - centerY) end

            self.imgX = self._imgX
            self.imgY = self._imgY
        else
            self:InvalidateLayout(true)
        end
    end
    function pnl:OnPageChange(right)
    end

    return pnl
end

local function CreatePage(frame, index)
    local page = CreateImagePanel(frame)

    if index then
        table.insert(frame.pages, index, page)
    else
        table.insert(frame.pages, page)
    end

    page:SetVisible(false)
    function page:OnPageChange(right)
        frame:ChangePage(frame.currentPage + (right and -1 or 1))
    end

    return page
end

local function CreatePageSwitchers(frame)
    local function create(parent)
        local but = vgui.Create("DButton", parent)
        but:SetText("")
        but.exited = SysTime()
        but.imgW = 0
        but.imgH = 0
        but.alpha = 0
        but._imgW = RSC.ScreenScale(48)
        but._imgH = RSC.ScreenScale(48)
        but.startDefault = SysTime()
        function but:OnCursorEntered()
            self.startHover = SysTime()
        end
        function but:OnCursorExited()
            self.startDefault = SysTime()
        end
        function but:OnDepressed()
            self.startPress = SysTime()
        end
        function but:Think()
            if self.Depressed then
                local t = (SysTime() - self.startPress) / 0.1
                self.imgW = Lerp(t, self.imgW, self._imgW * 0.8)
                self.imgH = Lerp(t, self.imgH, self._imgH * 0.8)
                self.alpha = Lerp(t, self.alpha, 200)
            elseif self.Hovered then
                local t = (SysTime() - self.startHover) / 0.1
                self.imgW = Lerp(t, self.imgW, self._imgW)
                self.imgH = Lerp(t, self.imgH, self._imgH)
                self.alpha = Lerp(t, self.alpha, 100)
            else
                local t = (SysTime() - self.startDefault) / 0.1
                self.imgW = Lerp(t, self.imgW, self._imgW * 0.6)
                self.imgH = Lerp(t, self.imgH, self._imgH * 0.6)
                self.alpha = Lerp(t, self.alpha, 20)
            end
        end
        function but:Paint(w, h)
            if not self.img then return end
            if not self:IsEnabled() then return end

            surface.SetDrawColor(255, 255, 255, self.alpha)

            local imgW, imgH = math.floor(self.imgW), math.floor(self.imgH)
            surface.SetMaterial(self.img)
            surface.DrawTexturedRect(w/2 - imgW/2, h/2 - imgH/2, imgW, imgH)
        end

        return but
    end

    frame.toLeft = create(frame)
    frame.toLeft:Dock(LEFT)
    frame.toLeft:SetWide(RSC.ScreenScale(48))
    frame.toLeft.img = RSC.URLMaterial("https://i.imgur.com/Tk6uMwW.png", "smooth")
    function frame.toLeft:DoClick()
        surface.PlaySound("UI/buttonclick.wav")
        frame:ChangePage(frame.currentPage - 1)
    end

    frame.toRight = create(frame)
    frame.toRight:Dock(RIGHT)
    frame.toRight:SetWide(RSC.ScreenScale(48))
    frame.toRight.img = RSC.URLMaterial("https://i.imgur.com/pXTVrHF.png", "smooth")
    function frame.toRight:DoClick()
        surface.PlaySound("UI/buttonclick.wav")
        frame:ChangePage(frame.currentPage + 1)
    end
end

RSC.GalleryPanel = nil
function RSC.OpenGallery()
    if IsValid(RSC.GalleryPanel) then
        RSC.GalleryPanel:Remove()
        RSC.GalleryPanel = nil
    end

    RSC.GalleryPanel = vgui.Create("EditablePanel")

    local frame = RSC.GalleryPanel
    frame:SetSize(RSC.ScrW, RSC.ScrH)
    frame:SetAlpha(0)
    frame:AlphaTo(255, 0.1, 0)
    frame:MakePopup()
    function frame:Paint(w, h)
        surface.SetDrawColor(0, 0, 0, 230)
        surface.DrawRect(0, 0, w, h)
    end
    function frame:PerformLayout() self:SetSize(RSC.ScrW, RSC.ScrH) end

    frame.pages = {}
    frame.currentPage = 1
    function frame:Update()
        self.delete:SetEnabled(false)
        self.pageNum:SetText(tostring(self.currentPage) .. "/" .. tostring(#self.pages))
        self.toLeft:SetEnabled(self.currentPage ~= 1)
        self.toRight:SetEnabled(self.currentPage ~= #self.pages)
        self.title:SetText("")
        self.description:SetText("")

        for page, pnl in ipairs(self.pages) do
            pnl:SetVisible(page == self.currentPage)

            if pnl:IsVisible() and pnl.img_src then
                self.title:SetText("File: " .. pnl.img_src)

                local path = pnl.img_src
                if file.Exists(pnl.img_src, "GAME") then
                    local time = os.date("%d/%m/%Y - %H:%M:%S", file.Time(path, "GAME"))
                    local size = math.floor(file.Size(path, "GAME") / 1000)

                    self.description:SetText(("%s | %d KB"):format(time, size))
                    self.delete:SetEnabled(true)
                    self.delete.src = path:gsub("data/", "")
                end
            end
        end
    end
    function frame:CreatePage(img, index)
        local page = CreatePage(frame, index)
        page:SetImage(img)
        frame:Update()

        return page
    end
    function frame:RemovePage(index)
        local page = table.remove(self.pages, index)
        page:Remove()
        frame:Update()
    end
    function frame:ChangePage(position)
        local totalPages = #self.pages
        local oldPage = self.currentPage

        self.currentPage = math.Clamp(position, 1, totalPages)
        local pageChanged = self.currentPage ~= oldPage

        if pageChanged then
            self:Update()
            return true
        end
    end

    CreateTopbar(frame)
    CreatePageSwitchers(frame)

    for _, img in ipairs(file.Find("rsc/*", "DATA", "datedesc")) do
        frame:CreatePage("data/rsc/" .. img)
    end

    --frame:CreatePage(nil, 1)
end

concommand.Add("rsc_gallery", RSC.OpenGallery)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801