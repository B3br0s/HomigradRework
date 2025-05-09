hook.Add("Initialize", "nigga_shit_obasralsa", function()
    timer.Simple(5, function()
        if not ULib or not ULib.sayCmds then return end
        for _, c in pairs(ULib.sayCmds) do
            c.hide = true
        end
    end)
end)