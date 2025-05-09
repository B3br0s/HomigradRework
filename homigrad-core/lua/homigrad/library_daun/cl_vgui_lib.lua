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

vgui.Register("hg_frame", hg_frame, "DFrame")
vgui.Register("hg_button", hg_button, "DButton")

/*local a = vgui.Create("hg_button")

a:MakePopup()
//a:SetTitle(" ")
a:SetSize(500,500)
//a:SetDraggable(false)
a.Text = "12253"*/