local function ChatLogic(output, input, isChat, teamonly, text)
    if not IsValid(output) or not IsValid(input) then return false end
    
    local result, is3D = hook.Run("ChatingCanLisen", output, input, isChat, teamonly, text)
    if result ~= nil then return result, is3D end

    if output:Alive() and input:Alive() then
        if teamonly then
            return output:Team() == input:Team()
        else
            return input:GetPos():DistToSqr(output:GetPos()) < 800000, true
        end
    elseif not output:Alive() and not input:Alive() then
        return true
    else
        if not output:Alive() and input:Team() == 1002 and input:Alive() then 
            return true 
        end
        return false
    end
end

hook.Add("PlayerCanSeePlayersChat", "RealiticChar", function(text, teamOnly, listener, speaker)
    if not IsValid(speaker) then return false end
    local result = ChatLogic(listener, speaker, true, teamOnly, text)
    return result
end)

hook.Add("PlayerCanHearPlayersVoice", "RealisticVoice", function(listener, speaker)
    if not IsValid(speaker) then return false, false end
    
    local result, is3D = ChatLogic(listener, speaker, false, false)
    local speak = speaker:IsSpeaking()
    
    speaker.IsSpeak = speak
    if speaker.IsOldSpeak ~= speaker.IsSpeak then
        speaker.IsOldSpeak = speak
        if speak then 
            hook.Run("StartVoice", speaker, listener) 
        else 
            hook.Run("EndVoice", speaker, listener)  
        end
    end

    return result, is3D
end)