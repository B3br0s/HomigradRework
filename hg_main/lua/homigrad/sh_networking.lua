hg = hg or {}--ну я спиздил,вопросы?

if (CLIENT) then
    local entityMeta = FindMetaTable("Entity")
    local playerMeta = FindMetaTable("Player")

    hg.net = hg.net or {}
    hg.net.globals = hg.net.globals or {}

    net.Receive("hgGlobalVarSet", function()
        local key, var = net.ReadString(), net.ReadType()

		if not hg.net.globals then
			hg.net.globals = {}
		end

    	hg.net.globals[key] = var
		
        hook.Run("OnGlobalVarSet", key, var)
    end)

    net.Receive("hgNetVarSet", function()
        local index = net.ReadUInt(16)

		local key = net.ReadString()
    	local var = net.ReadType()

		if not hg.net then
			hg.net = {}
		end
		
        hg.net[index] = hg.net[index] or {}
        hg.net[index][key] = var
		
		if IsValid(Entity(index)) then
			hook.Run("OnNetVarSet", index, key, var)
		else
			hg.net[index].waiting = true
		end
    end)
	
    net.Receive("hgNetVarDelete", function()
    	hg.net[net.ReadUInt(16)] = nil
    end)

    net.Receive("hgLocalVarSet", function()
    	local key = net.ReadString()
    	local var = net.ReadType()

    	hg.net[LocalPlayer():EntIndex()] = hg.net[LocalPlayer():EntIndex()] or {}
    	hg.net[LocalPlayer():EntIndex()][key] = var

    	hook.Run("OnLocalVarSet", key, var)
    end)

    function GetNetVar(key, default) -- luacheck: globals GetNetVar
    	local value = hg.net.globals[key]

    	return value != nil and value or default
    end

    function entityMeta:GetNetVar(key, default)
    	local index = self:EntIndex()

		if not hg.net then
			hg.net = {}
		end

    	if (hg.net[index] and hg.net[index][key] != nil) then
    		return hg.net[index][key]
    	end

    	return default
    end

    playerMeta.GetLocalVar = entityMeta.GetNetVar

	hook.Add("InitPostEntity", "OnRequestFullUpdate_hg", function()
		LocalPlayer():SyncVars()
	end)

	function playerMeta:SyncVars()
		net.Start("hg_request_fullupdate")
		net.SendToServer()
	end
else
	util.AddNetworkString("hg_request_fullupdate")

	net.Receive("hg_request_fullupdate",function(len,ply)
		ply.cooldown_sendnet = ply.cooldown_sendnet or 0
		if ply.cooldown_sendnet < CurTime() then
			ply.cooldown_sendnet = CurTime() + 1

			ply:SyncVars()
		end
	end)

	gameevent.Listen( "OnRequestFullUpdate" )
	hook.Add("OnRequestFullUpdate", "OnRequestFullUpdate_hg", function(data)
		local id = data.userid
		local ply = Player(id)
		
		ply:SyncVars()
	end)
	
	
    local entityMeta = FindMetaTable("Entity")
    local playerMeta = FindMetaTable("Player")

    hg.net = hg.net or {}
    hg.net.list = hg.net.list or {}
    hg.net.locals = hg.net.locals or {}
    hg.net.globals = hg.net.globals or {}

    util.AddNetworkString("hgGlobalVarSet")
    util.AddNetworkString("hgLocalVarSet")
    util.AddNetworkString("hgNetVarSet")
    util.AddNetworkString("hgNetVarDelete")

    local function CheckBadType(name, object)
    	if (isfunction(object)) then
    		ErrorNoHalt("Net var '" .. name .. "' contains a bad object type!")

    		return true
    	elseif (istable(object)) then
    		for k, v in pairs(object) do
    			if (CheckBadType(name, k) or CheckBadType(name, v)) then
    				return true
    			end
    		end
    	end
    end

    function GetNetVar(key, default)
    	local value = hg.net.globals[key]

    	return value != nil and value or default
    end

    function SetNetVar(key, value, receiver)
    	if (CheckBadType(key, value)) then return end
    	--if (GetNetVar(key) == value) then return end
		
    	hg.net.globals[key] = value

    	net.Start("hgGlobalVarSet")
    	net.WriteString(key)
    	net.WriteType(value)

    	if (receiver == nil) then
    		net.Broadcast()
    	else
    		net.Send(receiver)
    	end
    end

    function playerMeta:SyncVars()
    	for k, v in pairs(hg.net.globals) do
    		net.Start("hgGlobalVarSet")
    			net.WriteString(k)
    			net.WriteType(v)
    		net.Send(self)
    	end

    	for k, v in pairs(hg.net.locals[self] or {}) do
    		net.Start("hgLocalVarSet")
    			net.WriteString(k)
    			net.WriteType(v)
    		net.Send(self)
    	end

    	for entity, data in pairs(hg.net.list) do
    		if (IsValid(entity)) then
    			local index = entity:EntIndex()

    			for k, v in pairs(data) do
    				net.Start("hgNetVarSet")
    					net.WriteUInt(index, 16)
    					net.WriteString(k)
    					net.WriteType(v)
    				net.Send(self)
    			end
    		end
    	end
    end
	
    function playerMeta:GetLocalVar(key, default)
    	if (hg.net.locals[self] and hg.net.locals[self][key] != nil) then
    		return hg.net.locals[self][key]
    	end

    	return default
    end

    function playerMeta:SetLocalVar(key, value)
    	if (CheckBadType(key, value)) then return end

    	hg.net.locals[self] = hg.net.locals[self] or {}
    	hg.net.locals[self][key] = value

    	net.Start("hgLocalVarSet")
    		net.WriteString(key)
    		net.WriteType(value)
    	net.Send(self)
    end

    function entityMeta:GetNetVar(key, default)
    	if (hg.net.list[self] and hg.net.list[self][key] != nil) then
    		return hg.net.list[self][key]
    	end

    	return default
    end

    function entityMeta:SetNetVar(key, value, receiver)
    	if (CheckBadType(key, value)) then return end
		
    	hg.net.list[self] = hg.net.list[self] or {}

    	if (hg.net.list[self][key] != value) then
    		hg.net.list[self][key] = value
    	end

    	self:SendNetVar(key, receiver)
    end

    function entityMeta:SendNetVar(key, receiver)
    	net.Start("hgNetVarSet")
    	net.WriteUInt(self:EntIndex(), 16)
    	net.WriteString(key)
    	net.WriteType(hg.net.list[self] and hg.net.list[self][key])

    	if (receiver == nil) then
    		net.Broadcast()
    	else
    		net.Send(receiver)
    	end
    end

    function entityMeta:ClearNetVars(receiver)
    	hg.net.list[self] = nil
    	hg.net.locals[self] = nil

    	net.Start("hgNetVarDelete")
    	net.WriteUInt(self:EntIndex(), 16)

    	if (receiver == nil) then
    		net.Broadcast()
    	else
    		net.Send(receiver)
    	end
    end
	
	hook.Add("EntityRemoved","hg_clear_net",function(ent,fullUpdate)
		ent:ClearNetVars()
	end)

	hook.Add("PlayerDisconnected","hg_clear_net",function(ply)
		ply:ClearNetVars()
	end)
end