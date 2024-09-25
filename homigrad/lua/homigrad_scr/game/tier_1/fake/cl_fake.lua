local vec = Vector(1,1,1)

hook.Add("InitPostEntity","PlyColor",function()
    matproxy.Add({
        name = "PlayerColor",
        init = function(self,mat,values)
            self.ResultTo = values.resultvar
        end,
        bind = function(self,mat,ent)
            local resultTo = self.ResultTo
            if not mat.SetVector or not IsValid(ent) then return end

            if ent.GetPlayerColor then
                mat:SetVector(resultTo,ent:GetPlayerColor() or vec)
            elseif ent.GetNW2Vector then
                mat:SetVector(resultTo,ent:GetNW2Vector("modelcolor",vec))--и чо мы ебались...?
            end
       end 
    })
end)

RightArm = 1
LeftArm = 1

net.Receive("arms",function()
    RightArm = net.ReadFloat()
    LeftArm = net.ReadFloat()
end)

local vecFull = Vector(1,1,1)

event.Add("Death","Fake",function(dmgTab)
    if dmgTab.target ~= LocalPlayer() then return end
    
    local rag = dmgTab.rag
    if not IsValid(rag) then return end

    rag:ManipulateBoneScale(rag:LookupBone("ValveBiped.Bip01_Head1"),vecFull)

end)

event.Add("Death","RemoveNPClientRagdoll",function(dmgTab)
    local ent = dmgTab.target

    if not IsValid(ent) or not ent:IsNPC() then return end

    local mdl = ent:GetModel()

    timer.Simple(0.1,function()
        for i,ent in pairs(ents.FindInSphere(ent:GetPos(),52)) do
            if ent:GetClass() == "class C_ClientRagdoll" and ent:GetModel() == mdl then
                ent:Remove()
            end
        end
    end)
end)

local math_hand1 = Material("vgui/iconright.png")
local math_hand2 = Material("vgui/iconleft.png")

local Clamp = math.Clamp

hook.Add("HUDPaint","Fake",function()
    local ply = LocalPlayer()
    if not ply:GetNWBool("fake") and not ply:GetNWBool("Otrub") then return end

    surface.SetDrawColor(255,255,255,255)

    local rag = ply:GetNWEntity("Ragdoll")
    if not IsValid(rag) then return end
    
    local w,h = ScrW(),ScrH()

    if ply:GetNWBool("LeftArm") then
        local hand = rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_L_Hand"))
        local pos = hand:ToScreen()
        pos.x = Clamp(pos.x,w / 2 - w / 4,w / 2 + w / 4)
        pos.y = Clamp(pos.y,h / 2 - h / 4,h / 2 + h / 4)

        surface.SetMaterial(math_hand2)
        surface.DrawTexturedRectRotated(pos.x,pos.y,64,64,0)
    end

    if ply:GetNWBool("RightArm") then
        local hand = rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_R_Hand"))
        local pos = hand:ToScreen()
        pos.x = Clamp(pos.x,w / 2 - w / 4,w / 2 + w / 4)
        pos.y = Clamp(pos.y,h / 2 - h / 4,h / 2 + h / 4)

        surface.SetMaterial(math_hand1)
        surface.DrawTexturedRectRotated(pos.x,pos.y,-64,-64,180)
    end

    local wep = ply:GetActiveWeapon()

    local pos = EyePos() + ply:EyeAngles():Forward() * 8000
    pos = pos:ToScreen()

    pos.x = Clamp(pos.x,w / 2 - w / 3,w / 2 + w / 3)
    pos.y = Clamp(pos.y,h / 2 - h / 3,h / 2 + h / 3)
    
    local dis = math.Distance(pos.x,pos.y,w / 2,h / 2) / (h / 2)

    local a = 25 + dis * 255

    local size = math.max(dis * 32,6)

    if IsValid(wep) and wep:GetClass() ~= "weapon_hands" then a = a * 0.35 end
end)

event.Add("Player Spawn","ARms",function(ply)
	ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
	ply:RemoveAllDecals()
    
    if ply ~= LocalPlayer() then return end

    RightArm = 1
    LeftArm = 1
end)

hook.Add("StartCommand","Fake",function(ply,cmd)
	if not ply:Alive() or not ply:GetNWBool("Otrub") then return end
	
	cmd:ClearButtons()
end)

net.Receive("fake",function()
    local ent = Entity(net.ReadInt(16))

    LocalPlayer():SetNWEntity("Ragdoll",ent)
end)

net.Receive("fake up",function()
    LocalPlayer():SetNWEntity("Ragdoll",NULL)
end)