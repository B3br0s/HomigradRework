if SERVER then
    if !game.SinglePlayer() then
        util.AddNetworkString("RealisticBlood_DoEffect")
    end

    local function next_soak_mat()
        if REALISTIC_BLOOD_SOAK_MAT_IDX >= #REALISTIC_BLOOD_SOAK_MATERIALS then
            REALISTIC_BLOOD_SOAK_MAT_IDX = 1
        else
            REALISTIC_BLOOD_SOAK_MAT_IDX = REALISTIC_BLOOD_SOAK_MAT_IDX+1
        end
    end

    local function make_soak_ent( pos, normal, own )
        local bonefollower = own:RealisticBlood_MakeBoneFollower( pos, normal, false, false, 5.25, true )
        if !bonefollower then return end
        bonefollower:SetMaterial(REALISTIC_BLOOD_SOAK_MATERIALS[REALISTIC_BLOOD_SOAK_MAT_IDX]["str"])
    end

    function RealisticBlood_DoEffect( name, effectdata, ent )
        if game.SinglePlayer() then
            if name == "realisticblood_soak" then
                make_soak_ent( effectdata:GetStart(), effectdata:GetNormal(), ent )
                effectdata:SetFlags(REALISTIC_BLOOD_SOAK_MAT_IDX)
            end

            if ent then effectdata:SetEntity( ent ) end
            util.Effect(name, effectdata)

            if name == "realisticblood_soak" then next_soak_mat() end
        else
            if ent then effectdata:SetEntity( ent ) end

            local flags = effectdata:GetFlags()
            local normal = effectdata:GetNormal()
            local pos = effectdata:GetStart()
            local radius = effectdata:GetRadius()
            local magnitude = effectdata:GetMagnitude()

            timer.Simple(0, function()
                if name == "realisticblood_soak" then make_soak_ent( effectdata:GetStart(), effectdata:GetNormal(), ent ) end 

                net.Start("RealisticBlood_DoEffect")
                net.WriteEntity( ent )
                net.WriteInt( name == "realisticblood_soak" && REALISTIC_BLOOD_SOAK_MAT_IDX or flags, 9 )
                net.WriteFloat( magnitude )
                net.WriteVector( normal )
                net.WriteFloat( radius )
                net.WriteVector( pos )
                net.WriteString( name )
                net.SendPVS( effectdata:GetStart())

                if name == "realisticblood_soak" then next_soak_mat() end
            end)
        end
    end
end

if !game.SinglePlayer() && CLIENT then
    net.Receive("RealisticBlood_DoEffect", function()
        local effectdata = EffectData()
        effectdata:SetEntity( net.ReadEntity() )
        effectdata:SetFlags( net.ReadInt(9) )
        effectdata:SetMagnitude( net.ReadFloat() )
        effectdata:SetNormal( net.ReadVector() )
        effectdata:SetRadius( net.ReadFloat() )
        effectdata:SetStart( net.ReadVector())

        local effect = net.ReadString()
        util.Effect(effect, effectdata)
    end)
end