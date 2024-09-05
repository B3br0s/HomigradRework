hook.Add("PreDrawHalos", "ESP_DrawPlayersHealthColor", function()
    if LocalPlayer() then
        for _, ply in ipairs(player.GetAll()) do
            if ply != LocalPlayer() and ply:Alive() and LocalPlayer():GetNWBool("slendermanblya",false) == true then
                local health = math.Clamp(ply:Health(), 0, 100)
    
                local color = Color(255 * (100 - health) / 100, 255 * health / 100, 0)
    
                halo.Add({ply}, color, 1, 1, 5, true, true)
            end
        end
    end
end)
