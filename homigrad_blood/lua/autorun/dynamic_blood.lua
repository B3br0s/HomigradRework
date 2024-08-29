//BLOODMOD XL
if SERVER then
	util.AddNetworkString("BM_DebugLine")
	util.AddNetworkString("BM_DebugBone")
	if !ConVarExists( "dynamicblood_enabled" ) then CreateConVar("dynamicblood_enabled", "1", FCVAR_ARCHIVE, "Enables/Disables the blood particle effects") end
	cvars.AddChangeCallback("dynamicblood_enabled", function(cvar, old, new)
		if new == "1" then
			hook.Add("EntityTakeDamage", "BMEntDamaged", BMEntityDamaged)
			return
		end
		hook.Remove("EntityTakeDamage", "BMEntDamaged")
	end)
end

BM_Density = 1
BM_Enabled = true
BM_DebugLines = {}
BM_DebugBone = {}
BM_EnabledMaterials = {MAT_BLOODYFLESH, MAT_FLESH}

function BMEntityDamaged(ent, dmginfo)
	local mat = ent:GetMaterialType()
	if (!ent:GetMaterialType() or (!table.HasValue(BM_EnabledMaterials, mat) and !(mat == 67 and ent:IsNPC()))) and !ent:IsPlayer() then return end
	
	local effectdata = EffectData()
	effectdata:SetOrigin( dmginfo:GetDamagePosition( ) )
	effectdata:SetNormal( dmginfo:GetDamageForce():Angle():Forward() )
	effectdata:SetEntity(ent)
	effectdata:SetMagnitude(dmginfo:GetDamage())
	
	
	util.Effect( "hotline_bloodspray", effectdata )
	
	local len = dmginfo:GetDamageForce():Length()/1
	for i = 0, math.random(0,3) do
		util.Decal( "blood", dmginfo:GetDamagePosition( )-dmginfo:GetDamageForce():Angle():Forward()*8, dmginfo:GetDamagePosition( )+Vector(math.random(-len,len),math.random(-len,len),math.random(-len,len)))
	end
	
	
	
	if math.random(0,3) ==3 then 
		local tr = {}
		tr.start = dmginfo:GetDamagePosition( )
		tr.endpos = dmginfo:GetDamagePosition( )+dmginfo:GetDamageForce():Angle():Forward()*16
		tr.filter = function(e) return e == ent end
		tr.ignoreworld = true
		tr = util.TraceLine(tr)
		if !IsValid(tr.Entity) then return end
		effectdata:SetAttachment(tr.Entity:TranslatePhysBoneToBone(tr.PhysicsBone))
		util.Effect( "BloodDrip", effectdata ) 
	end
end
hook.Add("EntityTakeDamage", "BMEntDamaged", BMEntityDamaged)





-- function BM_DrawLines()
	-- for k, v in pairs(BM_DebugLines) do
		-- render.DrawLine(v[1], v[2], Color(255, 0, 0))
	-- end
-- end
-- hook.Add("PostDrawOpaqueRenderables", "BMDrawLines", BM_DrawLines)

-- function BM_AddLine(v1, v2)
	-- local t = CurTime()+math.random(1,96)
	-- table.insert(BM_DebugLines, t, {v1,v2})
	-- //timer.Simple(2, function() table.remove(BM_DebugLines, t) end)
-- end

-- function BM_AddBoneLine(bone, ent)
	-- local t = CurTime()
	-- table.insert(BM_DebugBone, t, {bone,ent})
	-- //timer.Simple(2, function() table.remove(BM_DebugBone, t) end)
-- end

-- net.Receive( "BM_DebugLine", function()
	-- local t = net.ReadTable()
	-- BM_AddLine(t[1], t[2])
-- end)