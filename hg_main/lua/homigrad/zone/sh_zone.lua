if SERVER then
    util.AddNetworkString("UpdateZone")
    
    zoneActive = false
    local zoneCenter = Vector(0, 0, 0) 
    local defaultRadius = 5000 
    local zoneRadius = defaultRadius
    local shrinkRate = 100 
    local minRadius = 100 
    
    hook.Add("Think", "ShrinkZone", function()
        if not zoneActive then
            zoneRadius = defaultRadius 
            net.Start("UpdateZone")
            net.WriteVector(Vector(0,0,0))
            net.WriteFloat(99999999999999999999)
            net.Broadcast()
            return
        end

        if zoneRadius > minRadius then
            zoneRadius = math.max(zoneRadius - shrinkRate * FrameTime(), minRadius)
        end
        
        net.Start("UpdateZone")
        net.WriteVector(zoneCenter)
        net.WriteFloat(zoneRadius)
        net.Broadcast()
        
        for _, ply in ipairs(player.GetAll()) do
            if ply:Alive() and ply:GetPos():Distance(zoneCenter) > zoneRadius then
                net.Start("blood particle explode")
                net.WriteVector(ply:GetPos())
                net.WriteVector(Vector(0,0,0))
                net.Broadcast()
                if ply.Fake then
                ply.FakeRagdoll:Remove()
                end
                ply:KillSilent()
            end
        end
    end)

    hook.Add("PostDrawTranslucentRenderables", "DrawZone", function()
        if zoneRadius >= 99999999999999999999 then return end 
        
        render.SetMaterial(Material("particle/warp1_warp"))
        for i = 1, 5 do
            render.DrawSphere(zoneCenter, zoneRadius - (i * 20), 30, 30, Color(255, 0, 0, 150 - (i * 25)))
        end
        
        render.SetMaterial(Material("sprites/blueglow2"))
        render.DrawSphere(zoneCenter, zoneRadius, 30, 30, Color(0, 100, 255, 100))
    end)
else
    local zoneCenter = Vector(0, 0, 0)
    local zoneRadius = 0
    
    net.Receive("UpdateZone", function()
        zoneCenter = net.ReadVector()
        zoneRadius = net.ReadFloat()
    end)
    
    hook.Add("PostDrawTranslucentRenderables", "DrawZone", function()
        if zoneRadius <= 100 then return end -- Скрыть зону, если она отключена
        
        render.SetMaterial(Material("particle/warp1_warp"))
        for i = 1, 5 do
            render.DrawSphere(zoneCenter, zoneRadius - (i * 20), 30, 30, Color(255, 0, 0, 150 - (i * 25)))
        end
        
        render.SetMaterial(Material("sprites/blueglow2"))
        render.DrawSphere(zoneCenter, zoneRadius, 30, 30, Color(0, 100, 255, 100))
    end)
end
