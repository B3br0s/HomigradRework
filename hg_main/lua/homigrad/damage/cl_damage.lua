net.Receive("LobotomySFX", function()
    sound.PlayFile("sound/homigrad/lobotomy.wav", "noplay", function(station)
        if IsValid(station) then
            station:SetVolume(0.3)
            station:Play()
        end
    end)
end)