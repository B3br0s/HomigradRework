--local hg_new_run = CreateClientConVar("hg_new_run","0",true,false,"CHTOOOO?",0,1)

local TwoHandedHoldTypes = {
    ar2 = true,
    smg = true,
    rpg = true,
    physgun = true,
    crossbow = true,
    shotgun = true,
    passive = true
}

hook.Add("SetupMove", "AnimatedImmersiveSprinting_Move", function(ply, mv)
        ply:SetNWBool("ImmerseSprint", true)
        if ply:IsSprinting() and ply:IsOnGround() and ply:GetMoveType() == MOVETYPE_WALK and mv:GetMaxClientSpeed() >= ply:GetWalkSpeed() then
            mv:SetMaxClientSpeed(ply:GetWalkSpeed())
        end
end)

hook.Add("CalcMainActivity", "AnimatedImmersiveSprinting_Hook", function(ply)
    if ply:KeyDown(IN_FORWARD) and ply:KeyDown(IN_SPEED) and not ply:KeyDown(IN_DUCK) and (IsValid(activeWeapon) and activeWeapon:GetClass() == "weapon_hands" or not IsValid(activeWeapon)) then
        if ply:GetNWBool("ImmerseSprint", nil) == true then
            if IsValid(ply:GetActiveWeapon()) and not TwoHandedHoldTypes[ply:GetActiveWeapon():GetHoldType()] == true then
                return -1, ply:LookupSequence("wos_mma_sprint_all") 
            end
        end
    end
end)