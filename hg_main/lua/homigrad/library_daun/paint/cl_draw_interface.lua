hook.Add("Initialize","ScrWscrH",function()
    scrw = ScrW()
    scrh = ScrH()
end)

scrw = ScrW()
scrh = ScrH()

ScreenR = ScrW() / ScrH()

hook.Add("OnScreenSizeChanged","Fuck",function(oldw,oldh,w,h)
    scrw = ScrW()
    scrh = ScrH()

    ScreenR = ScrW() / ScrH()
end)

concommand.Add("hg_fakescreenwh",function(ply,cmd,args)
    scrw = tonumber(args[1] or ScrW()) or ScrW()
    scrh = tonumber(args[2] or ScrH()) or ScrH()
end)

FindMetaTable("Vector").ToScreen2 = function(self)
    local pos = self:ToScreen()

    pos.x = pos.x * (ScrW() / scrw)
    pos.y = pos.y * (ScrH() / scrh)

    return pos
end

local oldX,oldY = gui.MouseX(),gui.MouseY()
local oldFocus = false
local delay = 0

mousedx = 0
mousedy = 0

mousex = 0
mousey = 0

wheel = 0

hook.Add("Think","!!!!SHLib Interface",function()
    IsWindow = not system.HasFocus()

    local x,y = gui.MouseX(),gui.MouseY()
    local focus = system.HasFocus()
    local time = CurTime()

    if oldFocus ~= focus then
        if focus then delay = time + 0.25 end

        InWindowTime = time
        InWindow = focus
        
        hook.Run("Window",focus)

        oldFocus = focus
    end

    if focus and delay < time then
        mousedx = oldX - x
        mousedy = oldY - y

        mousex = x
        mousey = y
    end

    oldX = x
    oldY = y

    wheel = 0
end,-2)

hook.Add("StartCommand","Wheel",function(ply,cmd)
    local _wheel = cmd:GetMouseWheel()
    
    if wheel == 0 then wheel = _wheel end
end)

EntityIconChache = EntityIconChache or {}

function EntityIcon(name)
    local mat = EntityIconChache[name]

	if not mat then
        mat = Material("entities/" .. tostring(name) .. ".png","GAME")

        EntityIconChache[name] = mat
	end

	return mat
end