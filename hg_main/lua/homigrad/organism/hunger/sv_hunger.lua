util.AddNetworkString("localized_chat")

hook.Add("Player Think","Hunger_Handler",function(ply)
    if !ply:Alive() then
        return
    end
    if ply.hungerNext < CurTime() then
        ply.hungerNext = CurTime() + math.random(1,5)
        //ply:ChatPrint(tostring(ply.hunger))
        local prevhunger = ply.hunger
        ply.hunger = math.Clamp(ply.hunger - 1,0,100)

        if ply.hunger == 30 and prevhunger > ply.hunger then
            net.Start("localized_chat")
            net.WriteString("youre_hungry")
            net.Send(ply)
        end

        if ply.hunger == 0 then
            ply.KillReason = "dead_hungry"
            ply:Kill()
        end
    end
end)