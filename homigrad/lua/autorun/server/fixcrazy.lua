if SERVER then
local function SafeSetCollisionGroup(ent, group)
    timer.Simple(0, function()
        if IsValid(ent) then
            if ent:GetVelocity():Length() > 1200 then
            ent:SetCollisionGroup(group)
            end
        end
    end)
end
    
hook.Add("OnEntityCreated", "SafeCollisionChange", function(ent)
    if IsValid(ent) then
        SafeSetCollisionGroup(ent, COLLISION_GROUP_DEBRIS)
    end
end)
end