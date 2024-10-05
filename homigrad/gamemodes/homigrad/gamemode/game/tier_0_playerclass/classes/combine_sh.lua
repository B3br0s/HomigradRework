local CLASS = player.RegClass("combine")

function CLASS.Off(self)
    if CLIENT then return end

    self.isCombine = nil
    self.cantUsePer4ik = nil
end

function CLASS.PlayerDeath(self)
    --sound.Play(Sound("npc/metropolice/die" .. math.random(1,4) .. ".wav"), self:GetPos())

    for i, ply in RandomPairs(getList(self)) do
    --    ply:EmitSound(Sound("npc/overwatch/radiovoice/unitdownat.wav"))
        break
    end

    self:SetPlayerClass()
end

function CLASS.On(self)
    if CLIENT then return end

    self:SetModel("models/player/combine_soldier.mdl")
    self:SetWalkSpeed(250)
    self:SetRunSpeed(350)

    self:SetHealth(100)
    self:SetMaxHealth(100)

    self:Give("weapon_hands")
    self:Give("weapon_hg_hl2")

    self.isCombine = true
    self.cantUsePer4ik = true

    self:EmitSound("npc/combine_soldier/vo/movein.wav")
end

function CLASS.Think(self)
end

function CLASS.PlayerStartVoice(self)
    if not self:Alive() then return end

    for i, ply in pairs(player.GetAll()) do
        if ply.isCombine and ply:Alive() then
            ply:EmitSound("npc/combine_soldier/vo/on" .. math.random(1,3) .. ".wav")
        end
    end
end

function CLASS.PlayerEndVoice(self)
    if not self:Alive() then return end

    for i, ply in pairs(player.GetAll()) do
        if ply.isCombine and ply:Alive() then
            ply:EmitSound("npc/combine_soldier/vo/off" .. math.random(1,3) .. ".wav")
        end
    end
end

function CLASS.CanLisenOutput(output, input, isChat)
    if input.isCombine and output:Alive() then return true end
end

function CLASS.CanLisenInput(input, output, isChat)
    if output.isCombine and output:Alive() then return true end
end

function CLASS.HomigradDamage(self, hitGroup, dmgInfo, rag)
    if dmgInfo:GetDamage() > 15 and self:Alive() then
    local randomphrase = math.random(1,5)
    if self:GetNWEntity("Ragdoll") != NULL then
        self:GetNWEntity("Ragdoll"):EmitSound("npc/combine_soldier/pain" .. math.random(1,3) .. ".wav")
    else
        self:EmitSound("npc/combine_soldier/pain" .. math.random(1,3) .. ".wav")
        if math.random(1,2) == 2 then
            if randomphrase == 1 then
                timer.Simple(0.3,function ()
                    self:EmitSound("npc/combine_soldier/vo/on2.wav")
                end)
                timer.Simple(0.35,function ()
                    self:EmitSound("npc/combine_soldier/vo/outbreak.wav", 75, 100, 1, CHAN_AUTO )
                end)
                timer.Simple(0.75,function ()
                    self:EmitSound("npc/combine_soldier/vo/outbreak.wav", 75, 105, 1, CHAN_AUTO )
                end)
                timer.Simple(1.1,function ()
                    self:EmitSound("npc/combine_soldier/vo/outbreak.wav", 75, 110, 1, CHAN_AUTO )
                end)
                timer.Simple(1.65,function ()
                    self:EmitSound("npc/combine_soldier/vo/off2.wav")
                end)
            elseif randomphrase == 2 then
                timer.Simple(0.3,function ()
                    self:EmitSound("npc/combine_soldier/vo/on2.wav")
                end)
                timer.Simple(0.45,function ()
                    self:EmitSound("npc/combine_soldier/vo/overwatchrequestskyshield.wav")
                end)
                timer.Simple(1.7,function ()
                    self:EmitSound("npc/combine_soldier/vo/off2.wav")
                end)
            elseif randomphrase == 3 then
                timer.Simple(0.3,function ()
                    self:EmitSound("npc/combine_soldier/vo/on2.wav")
                end)
                timer.Simple(0.45,function ()
                    self:EmitSound("npc/combine_soldier/vo/overwatchrequestreinforcement.wav")
                end)
                timer.Simple(1.6,function ()
                    self:EmitSound("npc/combine_soldier/vo/off2.wav")
                end)
            elseif randomphrase == 4 then
                timer.Simple(0.3,function ()
                    self:EmitSound("npc/combine_soldier/vo/on2.wav")
                end)
                timer.Simple(0.45,function ()
                    self:EmitSound("npc/combine_soldier/vo/requestmedical.wav")
                end)
                timer.Simple(1.2,function ()
                    self:EmitSound("npc/combine_soldier/vo/off2.wav")
                end)
            elseif randomphrase == 5 then
                timer.Simple(0.3,function ()
                    self:EmitSound("npc/combine_soldier/vo/on2.wav")
                end)
                timer.Simple(0.45,function ()
                    self:EmitSound("npc/combine_soldier/vo/sectorisnotsecure.wav")
                end)
                timer.Simple(1.3,function ()
                    self:EmitSound("npc/combine_soldier/vo/off2.wav")
                end)
            end
        end
    end
end
end

function CLASS.GuiltLogic(self, ply)
    return false
end