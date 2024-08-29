hook.Add("PreDrawHalos", "ESP_DrawPlayersHealthColor", function()
    if LocalPlayer().virusvichblya then
        for _, ply in ipairs(player.GetAll()) do
            if ply != LocalPlayer() and ply:Alive() then
                local health = math.Clamp(ply:Health(), 0, 150)
    
                local color = Color(255 * (150 - health) / 150, 255 * health / 150, 0)
    
                halo.Add({ply}, color, 1, 1, 5, true, true)
            end
        end
    end
end)
