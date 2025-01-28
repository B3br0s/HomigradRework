-- \lua\\homigrad\\sh_comunication.lua"

local function ChatLogic(output,input,isChat,teamonly,text)
	local result,is3D = hook.Run("ChatingCanLisen",output,input,isChat,teamonly,text)
	if result ~= nil then return result,is3D end

	if output:Alive() and input:Alive() then
		if input:GetPos():DistToSqr(output:GetPos()) < 800000 and not teamonly then
			return true,true
		else
			return false
		end
	elseif not output:Alive() and not input:Alive() then
		return true
	else
		if not input:Alive() and output:Alive() then return true,true end
		if not output:Alive() and input:Team() == 1002 and input:Alive() then return true end

		return false
	end
end

hook.Add("PlayerCanSeePlayersChat", "RealiticChar", function(text, teamOnly, listener, speaker)
    if not IsValid(speaker) then return end
    local result = ChatLogic(speaker,listener,true,false,text)

    if not IsValid(speaker) then speaker = Entity(0) end

    return result
end)

hook.Add("PlayerCanHearPlayersVoice", "RealisticVoice", function(listener,speaker)
	local result,is3D = ChatLogic(speaker,listener,false,false)
	local speak = speaker:IsSpeaking()
	speaker.IsSpeak = speak

	if speaker.IsOldSpeak ~= speaker.IsSpeak then
		speaker.IsOldSpeak = speak
		--print("huy")
		if speak then hook.Run( "StartVoice", speaker, listener ) else hook.Run( "EndVoice", speaker, listener )  end
	end

	return result,is3D
end)
