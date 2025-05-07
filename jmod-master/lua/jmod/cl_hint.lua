net.Receive("JMod_Hint", function()
	local isLangKey = net.ReadBool()
	local str = net.ReadString()
	local iconType = net.ReadInt(8)
	local tiem = net.ReadInt(8)

	if isLangKey then
		str = JMod.Lang(str)
	end

	MsgC(Color(255, 255, 255), "[JMod] ", str, "\n")
	notification.AddLegacy(str, iconType, tiem)
end)

concommand.Add("jmod_wiki", function()
	gui.OpenURL("https://github.com/Jackarunda/gmod/wiki")
end, nil, "Opens the Jmod Wiki page.")
