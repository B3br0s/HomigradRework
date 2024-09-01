if SERVER then
    AddCSLuaFile()
end

SWEP.PrintName = "Teleport SWEP"
SWEP.Author = "GLua Pro"
SWEP.Instructions = "Right-click to enter top-down view and left-click to teleport."

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ViewModel = ""
SWEP.WorldModel = ""

local isTopDownMode = false
local topDownHeight = 3000 -- Height for the top-down camera

if CLIENT then
    local topDownViewActive = false

    -- Toggles top-down view on/off
    function SWEP:SecondaryAttack()
        if not topDownViewActive then
            -- Enter top-down mode
            topDownViewActive = true
            isTopDownMode = true
            self.Owner:SetNWBool("InTopDownMode", true)

            -- Enable mouse cursor for teleportation
            gui.EnableScreenClicker(true)

            print("[DEBUG] Top-down mode enabled.")
        else
            -- Exit top-down mode
            topDownViewActive = false
            isTopDownMode = false
            self.Owner:SetNWBool("InTopDownMode", false)

            -- Disable mouse cursor
            gui.EnableScreenClicker(false)

            print("[DEBUG] Top-down mode disabled.")
        end
    end

    -- Modify the player's view to be from above in top-down mode
    hook.Add("CalcView", "TeleportSWEP_TopDownView", function(ply, pos, angles, fov)
        if ply:GetNWBool("InTopDownMode", false) then
            local view = {}
            -- Position the camera high above the player
            view.origin = ply:GetPos() + Vector(0, 0, topDownHeight)
            view.angles = Angle(90, 0, 0) -- Look directly down
            view.fov = 90
            view.drawviewer = false -- We don't need to draw the player in this view
            return view
        end
    end)

    -- Handle left-click for teleportation
    hook.Add("GUIMousePressed", "TeleportSWEP_TeleportOnClick", function(mouseCode)
        if LocalPlayer():GetNWBool("InTopDownMode", false) then
            if mouseCode == MOUSE_LEFT then
                -- Perform a trace from the camera to the ground to get the teleport location
                local trace = util.TraceLine({
                    start = LocalPlayer():GetPos() + Vector(0, 0, topDownHeight),
                    endpos = LocalPlayer():GetPos() + gui.ScreenToVector(ScrW() / 2, ScrH() / 2) * 10000,
                    filter = LocalPlayer()
                })

                if trace.Hit then
                    print("[DEBUG] Teleporting to: " .. tostring(trace.HitPos))
                    -- Send the hit position to the server for teleportation
                    net.Start("TeleportSWEP_TeleportPlayer")
                    net.WriteVector(trace.HitPos)
                    net.SendToServer()

                    -- Exit top-down mode after teleportation
                    isTopDownMode = false
                    LocalPlayer():SetNWBool("InTopDownMode", false)
                    gui.EnableScreenClicker(false)
                else
                    print("[DEBUG] No hit detected.")
                end
            elseif mouseCode == MOUSE_RIGHT then
                -- Right-click to exit top-down mode without teleporting
                print("[DEBUG] Exiting top-down mode without teleportation.")
                isTopDownMode = false
                LocalPlayer():SetNWBool("InTopDownMode", false)
                gui.EnableScreenClicker(false)
            end
        end
    end)

    -- Draw a simple crosshair in the middle of the screen in top-down mode
    hook.Add("HUDPaint", "TeleportSWEP_DrawCrosshair", function()
        if LocalPlayer():GetNWBool("InTopDownMode", false) then
            -- Draw a red crosshair in the center of the screen
            local x, y = ScrW() / 2, ScrH() / 2
            surface.SetDrawColor(255, 0, 0, 255)
            surface.DrawLine(x - 10, y, x + 10, y)
            surface.DrawLine(x, y - 10, x, y + 10)
        end
    end)
end

-- Server-side teleportation logic
if SERVER then
    util.AddNetworkString("TeleportSWEP_TeleportPlayer")

    net.Receive("TeleportSWEP_TeleportPlayer", function(len, ply)
        local teleportPos = net.ReadVector()

        print("[DEBUG] Teleporting player to position: " .. tostring(teleportPos))

        -- Teleport the player to the specified location with a slight offset to avoid ground clipping
        if IsValid(ply) and ply:Alive() then
            ply:SetPos(teleportPos + Vector(0, 0, 10))
        end
    end)
end
