hook.Add("Player Think","Spect-HG",function(ply)
    if ply:Alive() then
        return
    end

    if not ply.spec then
        ply.spec = 1
    end
    
    if not ply.specmode then
        ply.specmode = 1
    end

    local AlivePlys = {}

    for _, ply in ipairs(player.GetAll()) do
        if !ply:Alive() then
            continue 
        end

        table.insert(AlivePlys,ply)
    end

    if IsValid(ply.spect) and !ply.spect:Alive() then
        ply.spec = 1
        ply.spect = table.Random(AlivePlys)
    end

    ply:SetNWInt("specmode",ply.specmode)

    if ply.specmode == 1 and IsValid(ply.spect) then
        ply:SetPos(((ply.spect.Fake and IsValid(ply.spect.FakeRagdoll)) and (ply.spect.FakeRagdoll:GetPos()) or ply.spect:GetPos()))
        ply:Spectate(OBS_MODE_FIXED)
        ply:SetMoveType(MOVETYPE_NONE)
        ply:SpectateEntity(ply.spect)
    elseif ply.specmode == 2 and IsValid(ply.spect) then
        ply:Spectate(OBS_MODE_CHASE)
        ply:SpectateEntity((ply.spect.Fake and (ply.spect.FakeRagdoll) or ply.spect))
        ply:SetPos(ply.spect:GetPos())
        ply:Spectate(OBS_MODE_CHASE)
    elseif ply.specmode == 3 then
        ply:UnSpectate()
        ply:SetObserverMode(OBS_MODE_ROAMING)
        ply:SetMoveType(MOVETYPE_NOCLIP)
    end

    //print(ply.specmode)

    if ply:KeyPressed(IN_RELOAD) then
        ply.specmode = ply.specmode + 1
        if ply.specmode == 4 then
            ply.specmode = 1
        end
    end

    if ply:KeyPressed(IN_ATTACK) then
        ply.spec = ply.spec + 1 
        if ply.spec > #AlivePlys then
            ply.spec = 1
        end
        ply.spect = AlivePlys[ply.spec]
        ply:SetNWEntity("SpectEnt",ply.spect)
    end

    if ply:KeyPressed(IN_ATTACK2) then
        ply.spec = ply.spec - 1 
        if ply.spec < 1 then
            ply.spec = #AlivePlys
        end
        ply.spect = AlivePlys[ply.spec]
        ply:SetNWEntity("SpectEnt",ply.spect)
    end
end)