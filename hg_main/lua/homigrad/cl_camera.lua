local veczero = Vector(0.001, 0.001, 0.001)
local vecfull = Vector(1, 1, 1)
local vecVel = Vector(0, 0, 0)
local limit = 4
local view = render.GetViewSetup()
local lply = LocalPlayer()
local hg_fov = ConVarExists("hg_fov") and GetConVar("hg_fov") or CreateClientConVar("hg_fov", "90", true, false, "changes fov to value", 75, 120)
local diffvec3 = Vector(0, 0, 0)
local offsetView = offsetView or Angle(0, 0, 0)
local traceBuilder = {
    filter = lply,
    mins = Vector(-4, -4, -4),
    maxs = Vector(4, 4, 4),
    mask = MASK_SOLID,
    collisiongroup = COLLISION_GROUP_DEBRIS
}

local function clamp(vecOrAng, val)
    vecOrAng[1] = math.Clamp(vecOrAng[1], -val, val)
    vecOrAng[2] = math.Clamp(vecOrAng[2], -val, val)
    vecOrAng[3] = math.Clamp(vecOrAng[3], -val, val)
end

local whitelist = {
    ["weapon_physgun"] = true,
    ["gmod_tool"] = true,
    ["gmod_camera"] = true,
    ["weapon_crowbar"] = true,
    ["weapon_pistol"] = true,
    ["weapon_crossbow"] = true,
    ["glide_homing_launcher"] = true
}

local ValidWeaponBases = {
    ["weapon_m4super"] = true,
    ["weapon_870"] = true,
    ["weapon_r8"] = true,
    ["homigrad_base"] = true,
}

hook.Add("InputMouseApply", "Homigrad_Saltuxa", function(cmd, x, y, angle)
    local attang = LocalPlayer():EyeAngles()
    local view = render.GetViewSetup(true)
    local anglea = view.angles

    if not lply:Alive() then
        if angle[3] < -89 then
            angle[3] = -89
            angle.pitch = -89
            anglea[3] = -89
        elseif angle[3] > 89 then
            angle[3] = 89
            angle.pitch = 89
            anglea[3] = 89
        end
        cmd:SetViewAngles(angle)
    return
    end

    if lply.Fake then
        local angRad = math.rad(angle[3])
        local newX = x * math.cos(angRad) - y * math.sin(angRad)
        local newY = x * math.sin(angRad) + y * math.cos(angRad)

        angle.pitch = math.Clamp(angle.pitch + newY / 50, -180, 180)
        angle.yaw = angle.yaw - newX / 50
        if math.abs(angle.pitch) > 89 then
            angle.roll = angle.roll + 180
            angle.yaw = angle.yaw + 180
            angle.pitch = 89 * (angle.pitch / math.abs(angle.pitch))
        end

        cmd:SetViewAngles(angle)
        return true
    else
        Recoil = LerpFT(0.2,(Recoil or 0),0)
        RecoilVert = LerpFT(0.2,(RecoilVert or 0),0)
        RecoilHor = LerpFT(0.1,(RecoilHor or 0),0)
        angle[1] = angle[1] + -RecoilVert * 0.4
        angle[2] = angle[2] + RecoilHor * 0.1
        angle[3] = math.random(-3,3) * Recoil
        if angle[3] < -89 then
            angle[3] = -89
            angle.pitch = -89
            anglea[3] = -89
        elseif angle[3] > 89 then
            angle[3] = 89
            angle.pitch = 89
            anglea[3] = 89
        end
    end
    cmd:SetViewAngles(angle)
end)

function GetFakeCamera(ply, origin, angles, fov, znear, zfar)
    local rag = ply:GetNWEntity("FakeRagdoll", ply.FakeRagdoll or NULL)

    if not IsValid(rag) then return end

    local att = rag:GetAttachment(rag:LookupAttachment("eyes"))
    local AddPos = angles:Forward() * -0

    view.drawviewer = false
    view.origin = att.Pos + AddPos
    view.angles = ((!ply:Alive() and IsValid(rag)) and att.Ang or angles)
    view.fov = fov + 15

    rag:ManipulateBoneScale(6, Vector(0.0001, 0.0001, 0.0001))

    return view
end

hook.Add("CalcView", "Main_Camera", function(ply, origin, angles, fov, znear, zfar)
    if not IsValid(ply) or not ply:Alive() then return end

    local headBone = ply:LookupBone("ValveBiped.Bip01_Head1")
    if not headBone then return end

    local firstPerson = GetViewEntity() == ply
    ply:ManipulateBoneScale(headBone, firstPerson and veczero or vecfull)

    if !firstPerson then return end

    local eye = ply:GetAttachment(ply:LookupAttachment("eyes"))
    if not eye then return end

    if ply:InVehicle() then return end

    if ply.Fake then
        return GetFakeCamera(ply, origin, angles, fov, znear, zfar)
    end

    local eyePos, eyeAng = eye.Pos, eye.Ang
    eyePos = eyePos + eyeAng:Forward() * -1 + vector_up * -2
    local vel = -ply:GetVelocity() / 200
    local velLen = vel:Length()
    eyePos:Add(VectorRand() * (velLen > 2 and (velLen - 2) / 10 or 0))

    clamp(vel, limit)
    vecVel = LerpFT(0.1, vecVel, vel)

    traceBuilder.start = origin
    traceBuilder.endpos = eyePos
    local trace = util.TraceHull(traceBuilder)
    local pos = origin - trace.HitPos

    view.znear = 1
    view.zfar = zfar
    view.fov = hg_fov:GetInt()
    view.drawviewer = true
    view.origin = origin
    view.angles = angles

    view.origin = origin - pos
    view.angles = angles

    local wep = ply:GetActiveWeapon()
    if IsValid(wep) and whitelist[wep:GetClass()] then return end
    if IsValid(wep) and weapons.Get(wep:GetClass()) and ValidWeaponBases[weapons.Get(wep:GetClass()).Base] and wep.Camera then
        local pos,ang = wep:Camera(origin - pos,angles)
        view.origin = pos
        view.angles = ang
        view.znear = 2
    end
    return view
end)

local function HGAddView(ply, origin, angles)
    if ply:Alive() then
        local organism = ply or {}
        local adrenaline = organism.adrenaline or 0
        local brain = organism.brain or 0
        local disorientation = organism.disorientation or 0
        local pulse = organism.pulse or 70

        breathingMul = LerpFT(0.01, breathingMul, math.min(math.max((pulse) / 100, 1) - 1, 3))
        
        local speedMul = breathingMul * 2 + 0.05 + brain * 5 + disorientation / 10
        curTime = curTime + (speedMul / 100 + 0.01) * FrameTime() / TickInterval()
        
        swayAng[3] = math.sin(curTime / 2) * speedMul + math.Rand(0, math.min(adrenaline, 0.5)) / 10
        swayAng[2] = math.cos(curTime / 2) * speedMul * math.sin(RealTime())
        swayAng[1] = math.sin(curTime * 2) * speedMul * math.cos(CurTime())
        
        suppressionVec = LerpVectorFT(0.01, suppressionVec, veczero)
        suppressionDistAdd = suppressionDistAdd * 0.8
        suppressionDist = suppressionDist + suppressionDistAdd
        suppressionDist = LerpFT(0.01, suppressionDist, 0)
        origin:Add(suppressionVec * suppressionDist * 3)
        
        local dot = suppressionVec:GetNormalized():Dot(angles:Right())
        angles[3] = angles[3] + dot * suppressionDist * 60
        angles:Add(swayAng * 3)
        swayAng[3] = 0
        huyAng = AngleRand(-0.1, 0.1) * math.Rand(0, math.min(adrenaline, 2))
        huyAng[3] = 0
        ply:SetEyeAngles(ply:EyeAngles() + swayAng / 60 + huyAng)
        
        origin[3] = origin[3] + math.sin(curTime * 2) / 5 * speedMul
        origin[2] = origin[2] + math.cos(curTime / 4) / 10 * speedMul
        origin[1] = origin[1] + math.cos(curTime / 2) / 10 * speedMul
        
        local kachka = not IsValid(ply.FakeRagdoll) and math.min(diffvec:Length() / 6, 0.5) or 0
        kachka = kachka * ((organism.lleg or 0) + (organism.rleg or 0) + 2) * 0.5
        curTime2 = curTime2 + kachka / 20 * smooth_frameTime * (ply:OnGround() and 1 or 0.2)
        kachka = kachka * ((organism.lleg or 0) * 2 + (organism.rleg or 0) * 2 + 2) / 2
        
        swayAng[3] = 0
        swayAng[2] = math.cos(curTime2 * 4) * 2
        swayAng[1] = math.sin(curTime2 * 8) * 2
        
        origin[3] = origin[3] + math.cos(curTime2 * 8) / 8 * kachka
        origin[2] = origin[2] + math.cos(curTime2 * 4) / 6 * kachka
        origin[1] = origin[1] + math.cos(curTime2 * 4) / 8 * kachka
        
        if hg.weapons[ply:GetActiveWeapon()] then ply:SetEyeAngles(ply:EyeAngles() + swayAng / 60 * 2 * kachka) end
    end
    return origin, angles
end

local hook_Run = hook.Run
local render_RenderView = render.RenderView
local renderView = {
    x = 0,
    y = 0,
    drawhud = true,
    drawviewmodel = true,
    dopostprocess = true,
    drawmonitors = true,
    fov = 100
}