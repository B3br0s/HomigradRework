util.AddNetworkString("hg_reg")

net.Receive("hg_reg",function(len,ply)
    local tr = net.ReadTable()
    local wep = net.ReadEntity()
    //local dmg_table = net.ReadTable()
    local bullet = net.ReadTable()
    if wep:GetOwner() != ply then
        return
    end
    local tr_check = util.TraceLine({
        start = tr.StartPos,
        endpos = tr.HitPos,
        filter = {ply}
    })
    local Dir = (tr.HitPos - tr.StartPos):Angle():Forward()
    bullet.Dir = Dir
    local ent = tr.Entity
    //print("Registered hit from "..wep:GetOwner():Name().." to "..tr.Entity:GetClass())
    //if (tr.Entity:Health() or tr.Entity:IsRagdoll()) and tr_check.HitPos:Distance(tr_check.StartPos) > 1 then //Двойная проверка.

    //local dist = tr_check.HitPos:Distance(tr_check.StartPos)
    wep:FireLuaBullets(bullet)
    
    //dmginfo:SetDamage(dmg_table.Damage / math.random(2,4))// / (dist / 250))
    //ent:TakeDamageInfo(dmginfo)

    //end
end)