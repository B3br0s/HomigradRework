AddCSLuaFile("weapons/b3bros_base/cl_worldmodel.lua")
AddCSLuaFile("weapons/b3bros_base/shared.lua")
include("weapons/b3bros_base/cl_init.lua")
AddCSLuaFile("weapons/b3bros_base/cl_attachments.lua")
AddCSLuaFile("weapons/b3bros_base/cl_scope.lua")
include("weapons/b3bros_base/shared.lua")
include("weapons/b3bros_base/init.lua")

if CLIENT then

    local function PrintViewModelBoneNames()
        local ply = LocalPlayer()
        
        if not IsValid(ply) or not IsValid(ply:GetActiveWeapon()) then return end
        
        local viewModel = ply:GetViewModel()
        
        if not IsValid(viewModel) then
            return
        end

        for i = 0, viewModel:GetBoneCount() - 1 do
            local boneName = viewModel:GetBoneName(i)
            print(string.format("Bone %d: %s", i, boneName))
        end
    end

    concommand.Add("hg_getbones", function()
        PrintViewModelBoneNames()
    end)   
end     