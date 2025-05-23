hg_vgui = hg_vgui or {}

local hg_frame = {}
local SetDrawColor,DrawRect = surface.SetDrawColor,surface.DrawRect

//hg_frame.HoverClr = Color(38, 38, 38)
hg_frame.DefaultClr = Color(25,25,25)
hg_frame.Text = ""

function hg_frame:Paint(w,h)
    //draw.RoundedBox(0, 0, 0, w, h, self.DefaultClr)

    if self.NoDraw then

        if self.SubPaint then
            self:SubPaint(w,h)
        end

        return
    end

    local mul_daun = (self.CurSize or 1)

    /*surface.SetDrawColor(self.DefaultClr.r,self.DefaultClr.g,self.DefaultClr.b,self.DefaultClr.a)
    surface.DrawRect(w/2 * (1-mul_daun),0,w * mul_daun,h)

    surface.SetDrawColor(245,245,245,15)
    surface.DrawOutlinedRect(w/2 * (1-mul_daun),0,w * mul_daun,h,1)
    surface.SetDrawColor(145,145,145,7.5)
    surface.DrawOutlinedRect(w/2 * (1-mul_daun) + 1,1,w * mul_daun,h,1)
    surface.DrawOutlinedRect(w/2 * (1-mul_daun) -1,-1,w * mul_daun,h,1)
    surface.SetDrawColor(145,145,145,5)
    surface.DrawOutlinedRect(w/2 * (1-mul_daun) + 2,2,w * mul_daun,h,1)
    surface.DrawOutlinedRect(w/2 * (1-mul_daun)-2,-2,w * mul_daun,h,1)*/

    SetDrawColor(self.DefaultClr.r,self.DefaultClr.g,self.DefaultClr.b,self.DefaultClr.a)
    DrawRect(w/2 * (1-mul_daun),0,w * mul_daun,h)

    draw.Frame(w/2 * (1-mul_daun),0,w * mul_daun,h,cframe1,cframe2)

    draw.SimpleText(self.Text, "HS.18", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if self.SubPaint then
        self:SubPaint(w,h)
    end
end

local hg_button = {}

hg_button.HoverClr = Color(38, 38, 38)
hg_button.DefaultClr = Color(32,32,32)
hg_button.Text = ""
hg_button.LowerText = ""
hg_button.ishovered = false
function hg_button:Draw(w,h)
end

function hg_button:Paint(w,h)
    //draw.RoundedBox(0, 0, 0, w, h, (self:IsHovered() and self.HoverClr or self.DefaultClr))

    /*surface.SetDrawColor(100,100,100,35)
    surface.DrawOutlinedRect(0,0,w,h,1)
    surface.SetDrawColor(100,100,100,75)
    surface.DrawOutlinedRect(1,1,w,h,1)
    surface.DrawOutlinedRect(-1,-1,w,h,1)
    surface.SetDrawColor(100,100,100,5)
    surface.DrawOutlinedRect(2,2,w,h,1)
    surface.DrawOutlinedRect(-2,-2,w,h,1)*/

    if self.Shit then
        self:Shit()
    end

    self:Draw(w,h)

    SetDrawColor(25,25,25)
    DrawRect(0,0,w,h)

    if self:IsDown() then
        SetDrawColor(20,20,20,255)
        DrawRect(0,0,w,h)
    elseif self:IsHovered() then
        SetDrawColor(255,255,255,5)
        DrawRect(0,0,w,h)
        if !self.ishovered then
            self.ishovered = true
        end
    else
        self.ishovered = false
    end

    draw.Frame(0,0,w,h,cframe1,cframe2)

    if self.SubPaint then
        self:SubPaint(w,h)
    end

    if self.GradColor then
        local clr = self.GradColor
        surface.SetDrawColor(clr.r,clr.g,clr.b,15)
        surface.SetMaterial(Material("vgui/gradient_up"))
        surface.DrawTexturedRect(0,h-h/2,w,h/2)
    end

    draw.SimpleText(self.Text, (self.TextFont or "HS.18"), w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(self.LowerText, (self.LowerFont or "HS.18"), w / 2, h / 1.2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if self.Amt then
        draw.SimpleText(self.Amt, "HS.12", w / 2, h / 1.5, Color(255, 255, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function hg_button:DoClick()
    surface.PlaySound("homigrad/vgui/csgo_ui_store_rollover.wav")
end

local hg_slot = {}
hg_slot.hovered = 0
hg_slot.Item = nil
hg_slot.ItemIcon = "null"

function hg_slot:DrawItem(w,h)
    local isDown = self:IsDown()
    local isHovered = self:IsHovered()

    surface.SetMaterial(Material(self.ItemIcon))
    if isDown then
        surface.SetDrawColor(125,125,125)
    elseif isHovered then
        surface.SetDrawColor(255,255,255)
    else
        surface.SetDrawColor(150,150,150)
    end
    surface.DrawTexturedRect(w-w/1.2,h-h/1.15,w/1.4,h/1.4)
end

function hg_slot:SubPaint(w,h)
end

function hg_slot:Paint(w,h)
    SetDrawColor(25,25,25,255)
    DrawRect(0,0,w,h)

    local isDown = self:IsDown()
    local isHovered = self:IsHovered()

    if isDown then
        SetDrawColor(0,0,0,125)
        DrawRect(0,0,w,h)
    elseif isHovered then
        SetDrawColor(255,255,255,5)
        DrawRect(0,0,w,h)
    end

    self.hovered = LerpFT(0.5,self.hovered,(isHovered or isDown) and 1 or 0)

    local cornerH = math.max(h * 0.15,6) + 1

    //print(self.Item)

    if self.Item != nil and self.Item.Rarity != nil then      
        draw.SimpleText(hg.GetPhrase(self.Item) != self.Item and hg.GetPhrase(self.Item) or (self.Item.Name) != nil and self.Item.Name or self.Item.PrintName,"InvFont",w / 2,h - cornerH / 2,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        local col = hg.Rarity[self.Item.Rarity]

        SetDrawColor(col.r,col.g,col.b,20)

        draw.GradientDown(0,0,w,h)
    end

    self:DrawItem(w,h)

    if self.Item != nil and self.Item.Rarity != nil then    
        local col = hg.Rarity[self.Item.Rarity]
        
        SetDrawColor(col.r,col.g,col.b,180)
        DrawRect(0,h - cornerH,w,cornerH)
        
        SetDrawColor(255,255,255,5)
        DrawRect(0,h - cornerH,w,1)
    end

    self:SubPaint(w,h)

    local k = 0//math.max((self.shake or 0) - CurTime(),0) / 0.5

    SetDrawColor(255,0,0,k * 255)
    DrawRect(0,0,w,h)

    SetDrawColor(255,255,255,5)
    DrawRect(0,0,w,1)
    DrawRect(0,0,1,h)

    SetDrawColor(0,0,0,255)
    DrawRect(0,h - 1,w,1)
    DrawRect(w - 1,0,1,h)
end

vgui.Register("hg_frame", hg_frame, "DFrame")
vgui.Register("hg_button", hg_button, "DButton")
vgui.Register("hg_slot", hg_slot, "DButton")

SW = ScrW()
SH = ScrH()

function ScrMul()
    return math.min(SW/1920,SH/1080)
end

hook.Add("OnScreenSizeChanged","ShitUpdate",function(ow,oh,w,h)
    SW = w
    SH = h
end)

/*local a = vgui.Create("hg_button")

a:MakePopup()
//a:SetTitle(" ")
a:SetSize(500,500)
//a:SetDraggable(false)
a.Text = "12253"*/