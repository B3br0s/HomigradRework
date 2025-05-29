function hg.HasAnimation(self,seq, lq)
    if self.Animations[seq] or self.IKAnimationProxy[seq] then
        return true
    end

    if lq then return false end

    local vm = hg.Zaebal_Day_VM(self)

    if !IsValid(vm) then return true end
    seq = vm:LookupSequence(seq)

    return seq != -1
end

function hg.GetAnimationEntry(self,seq)
    if hg.HasAnimation(self,seq) then
        if self.IKAnimationProxy[seq] then
            return self.IKAnimationProxy[seq]
        else
            if self.Animations[seq] then
                return self.Animations[seq]
            elseif !self:GetProcessedValue("SuppressDefaultAnimations", true) then
                return {
                    Source = seq,
                    Time = self:GetSequenceTime(seq)
                }
            end
        end
    else
        return {}
    end
end

if CLIENT then
    net.Receive("hg playanim",function()
        local tbl = net.ReadTable()

        hg.PlayAnim(tbl[1],tbl[2], tbl[3], tbl[4], tbl[5], tbl[6], tbl[7], tbl[8])
    end)
else
    util.AddNetworkString("hg playanim")
end

function hg.PlayAnim(self,anim, mult, lock, delayidle, noproxy, notranslate, noidle)
    if !self.TPIK_Anims then
        return
    end
    if SERVER then
        local anim_tbl = {
            self,
            anim,
            mult,
            lock,
            delayidle,
            noproxy,
            notranslate,
            noidle
        }

        net.Start("hg playanim")
        net.WriteTable(anim_tbl)
        net.SendOmit(self:GetOwner())
    end
    mult = mult or 1
    lock = lock or false
    local untranslatedanim = anim
    //mult = self:RunHook("Hook_TranslateAnimSpeed", {mult = mult, anim = anim}).Mult or mult
    local omult = mult

    if !IsValid(self) then
        return
    end

    if !IsValid(self:GetOwner()) then
        return
    end

    local mdl = (CLIENT and (self:GetOwner() == LocalPlayer() and hg.Zaebal_Day_VM(self) or self:GetWM()) or hg.Zaebal_Day_VM(self))

    if !IsValid(mdl) then return 0, 1 end

    local animation = hg.GetAnimationEntry(self,anim)

    local source = animation.Source

    local tsource = source

    if mdl:LookupSequence(tsource) != -1 then
        source = tsource
    end

    local seq = 0

    if animation.ProxyAnimation and !noproxy then
        if CLIENT then
            mdl = animation.Model

            if !mdl then
                mdl = self:LocateSlotFromAddress(animation.Address).GunDriverModel
            end
        else
            mdl = ents.Create("prop_physics")
            mdl:SetModel(animation.ModelName)
        end

        self:SetSequenceProxy(animation.Address or 0)

        if IsValid(mdl) then

            seq = mdl:LookupSequence(source)

            if seq == -1 then return 0, 1 end

            if animation.AlsoPlayBase then
                self:PlayAnim(anim, mult, lock, delayidle, true)
            end

        end
    else
        seq = mdl:LookupSequence(source)

        if seq == -1 then return 0, 1 end

        self:SetSequenceProxy(0)
    end

    local time = 0.1
    local minprogress = 1

    if IsValid(mdl) then
        time = animation.Time or mdl:SequenceDuration(seq)

        mult = mult * (animation.Mult or 1)

        if animation.Reverse then
            mult = mult * -1
        end

        local tmult = 1

        tmult = (mdl:SequenceDuration(seq) / time) / mult

        if animation.ProxyAnimation then
            mdl:SetSequence(seq)
            mdl:SetCycle(0)
        else
            mdl:SendViewModelMatchingSequence(seq)
            mdl:SetPlaybackRate(math.Clamp(tmult, -12, 12)) -- It doesn't like it if you go higher
        end

        self:GetOwner().SequenceIndex = seq or 0
        self:SetSequenceSpeed((1 / time) / mult)

        local ply = self:GetOwner()

        ply.SequenceCycle = 0

        if !IsValid(ply) then
            return
        end

        if ply.SequenceCycle > 1 then
            ply.SequenceCycle = 0
        end

        if mult < 0 then
            ply.SequenceCycle = 1
        else
            ply.SequenceCycle = 0
        end

        mult = math.abs(mult)

        minprogress = animation.MinProgress or 0.8
        minprogress = math.min(minprogress, 1)

        if animation.RestoreAmmo then
            self:SetTimer(time * mult * minprogress, function()
                self:RestoreClip(animation.RestoreAmmo)
            end)
        end

        if animation.IKTimeLine then
            self:SetIKAnimation(anim)
            self:SetIKTimeLineStart(CurTime())
            self:SetIKTime(time * mult)
        end
    end

    if animation.PoseParamChanges then
        for i, k in pairs(animation.PoseParamChanges) do
            self.PoseParamState[i] = k
        end
    end

    return time * mult, minprogress
end

function hg.AnimHandle(self)
    if not self.SupportTPIK then return end

    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    local mult = self:GetSequenceSpeed()
    if SERVER then
        ply.SequenceCycle = (ply.SequenceCycle or 0) + (FrameTime() * mult)
    else
        ply.SequenceCycle = (ply.SequenceCycle or 0) + (FrameTime() * mult)
    end

    local seqprox = self:GetSequenceProxy()
    if seqprox ~= 0 then
        for _, wm in ipairs({true, false}) do
            local mdl = self:GetAnimationProxyModel(wm)
            if not IsValid(mdl) then continue end

            mdl:SetSequence(ply.SequenceIndex)
            mdl:SetCycle(ply.SequenceCycle)

            if seqprox == self.LHIKModelAddress then
                local lhik_mdl = wm and self.LHIKModelWM or self.LHIKModel
                if not IsValid(lhik_mdl) then return end
                lhik_mdl:SetSequence(ply.SequenceIndex)
                lhik_mdl:SetCycle(ply.SequenceCycle)
            end

            if seqprox == self.RHIKModelAddress then
                local rhik_mdl = wm and self.RHIKModelWM or self.RHIKModel
                if not IsValid(rhik_mdl) then return end
                rhik_mdl:SetSequence(ply.SequenceIndex)
                rhik_mdl:SetCycle(ply.SequenceCycle)
            end

            local anim_mdl = self:GetAnimationProxyGunDriver()
            if IsValid(anim_mdl) then
                anim_mdl:SetSequence(ply.SequenceIndex)
                anim_mdl:SetCycle(ply.SequenceCycle)
            end
        end
    end
end

hook.Add("Player Think","TPIK",function(ply)
	if CLIENT then
        if ply == LocalPlayer() then
            return
        end
    end

    hg.AnimHandle(ply:GetActiveWeapon())
end)

hook.Add("Think","TPIK_LOCAL",function()
    if CLIENT then
        local ply = LocalPlayer()

        hg.AnimHandle(ply:GetActiveWeapon())
    end
end)