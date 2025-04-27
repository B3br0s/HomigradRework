util.AddNetworkString("hg_reg")

net.Receive("hg_reg",function(len,ply)
    local tr = net.ReadTable()
    local wep = net.ReadEntity()
    local dmg_table = net.ReadTable()
    local dmginfo = DamageInfo()
    dmginfo:SetDamageType(dmg_table.DamageType)
    dmginfo:SetDamagePosition(dmg_table.DamagePosition)
    dmginfo:SetDamageForce(dmg_table.DamageForce)
    dmginfo:SetInflictor(wep)
    dmginfo:SetAttacker(ply)
    if wep:GetOwner() != ply then
        return
    end
    local tr_check = util.TraceLine({
        start = tr.StartPos,
        endpos = tr.HitPos,
        filter = {ply}
    })
    local ent = tr.Entity
    if (tr.Entity:Health() or tr.Entity:IsRagdoll()) and tr_check.HitPos:Distance(tr_check.StartPos) > 2 then //Двойная проверка.
        local dist = tr_check.HitPos:Distance(tr_check.StartPos)
        
        dmginfo:SetDamage(dmg_table.Damage / math.random(2,4))// / (dist / 250))
        ent:TakeDamageInfo(dmginfo)
    end
end)