function CreateFakeWeapon(Class,Pos,Angles)
    local Gun = ents.Create(Class)
    Gun.CanPickup = false
    Gun:SetPos(Pos)
    Gun:SetAngles(Angles)
    Gun:Spawn()
    Gun:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    return Gun
end

local ValidWeaponBases = {
    ["weapon_m4super"] = true,
    ["weapon_870"] = true,
    ["weapon_r8"] = true,
    ["homigrad_base"] = true,
}

local ValidWeapons = {
    ["weapon_hands"] = true
}

hook.Add("Player Think","Fake Shooting",function(ply,time)
    if not ply.Fake or not ply:Alive() then ply:SetNWBool("RightArm",false) ply:SetNWBool("LeftArm",false) return end
    if ply.otrub then return end
    local rag = ply.FakeRagdoll

    if ply.CurWeapon == nil then return end

    if not IsValid(ply.FakeWep) then
        ply.FakeShooting = false
        ply.FakeWepConstraint = nil
    end

    local Pos,Ang = rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_R_Hand"))

    --print(ply.CurWeapon)

    if not ply.FakeWep and weapons.Get(ply.CurWeapon) != nil and ValidWeaponBases[weapons.Get(ply.CurWeapon).Base] == true and ply:HasWeapon(ply.CurWeapon) then
        if weapons.Get(ply.CurWeapon) != nil and ValidWeapons[ply.CurWeapon] == true and not ply.FakeWep then
            ply.FakeShooting = false
            ply.FakeWep:Remove()
            ply.FakeWep = nil
            return
        end
        ply.FakeWep = CreateFakeWeapon(ply.CurWeapon,Pos,Ang)

        local AddNigga = ply.FakeWep.RHandPos

        local Ang1337 = Ang

        Ang1337:RotateAroundAxis(Ang:Forward(),180)--ее

        ply.FakeWep:SetAngles(Ang1337)

        local Pos1337 = Pos

        Pos1337 = Pos1337 + Ang1337:Forward() * AddNigga[1] + Ang1337:Right() * AddNigga[2] + Ang1337:Up() * AddNigga[3]

        ply.FakeWep:SetPos(Pos1337)

        ply.FakeWep:GetPhysicsObject():SetMass(0)

        ply.FakeShooting = true

        ply.FakeWep:GetPhysicsObject():ApplyForceOffset(VectorRand(-2,2),ply.FakeWep:GetPos())
    else
        if not IsValid(ply.FakeWep) then
            ply.FakeShooting = false
            ply.FakeWepConstraint = nil
            return
        else
            if not IsValid(ply.FakeWepConstraint) then
                local AddNigga = ply.FakeWep.RHandPos

                local Ang1337 = Ang

                Ang1337:RotateAroundAxis(Ang:Forward(),180)--ее

                ply.FakeWep:SetAngles(Ang1337)

                local Pos1337 = Pos

                Pos1337 = Pos1337 + Ang1337:Forward() * AddNigga[1] + Ang1337:Right() * AddNigga[2] + Ang1337:Up() * AddNigga[3]

                ply.FakeWep:SetPos(Pos1337)

                if ply.FakeWep == NULL then
                    return
                end

                ply.FakeWep:GetPhysicsObject():EnableCollisions(false)

                ply.FakeWep:GetPhysicsObject():SetMass(0)
                
                ply.FakeWep:GetPhysicsObject():ApplyForceOffset(VectorRand(-2,2),ply.FakeWep:GetPos())

                ply.FakeWepConstraint = constraint.Weld(rag,ply.FakeWep,rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_R_Hand")),0,0,false,false)
            end
        end
    end

    if !ply.FakeShooting or ply.FakeShooting and !IsValid(ply.FakeWep) then return end

    local WepTBL = weapons.Get(ply.CurWeapon)

    if ply:KeyDown(IN_ATTACK) and WepTBL.Primary.Automatic and !WepTBL.CustomShoot then
        local FakeWep = ply.FakeWep

        if not ply.NextFakeShoot then
            ply.NextFakeShoot = 0
        end

        if ply.NextFakeShoot < CurTime() and ply:GetWeapon(ply.CurWeapon):Clip1() > 0 then
            ply.FakeWep:TakePrimaryAmmo(1)

            ply:GetWeapon(ply.CurWeapon):TakePrimaryAmmo(1)

            ply.NextFakeShoot = CurTime() + WepTBL.Primary.Wait

            sound.Play(WepTBL.Primary.Sound[1],FakeWep:GetPos(),75,100,1,0)

            local bullet = {}
            local vecCone = Vector(0, 0, 0)

            local primary = WepTBL.Primary

            local cone = WepTBL.Primary.Cone
	        vecCone[1] = cone
	        vecCone[2] = cone

            bullet.Src = FakeWep:GetPos() + FakeWep:GetAngles():Forward() * 0
            bullet.Dir = FakeWep:GetAngles():Forward()
            bullet.Spread = vecCone
	        bullet.Force = 5
	        bullet.Damage = primary.Damage or 25
	        bullet.Spread = primary.Spread or 0
	        bullet.AmmoType = primary.Ammo
	        bullet.Attacker = owner
	        bullet.IgnoreEntity = nil

            FakeWep:GetPhysicsObject():ApplyForceCenter(FakeWep:GetAngles():Forward()*2+FakeWep:GetAngles():Right()*VectorRand(-90,90)+FakeWep:GetAngles():Up()*200)

            FakeWep:FireBullets(bullet)
        end
    elseif ply:KeyDown(IN_ATTACK) and not WepTBL.Primary.Automatic and WepTBL.CustomShoot then
        local self = ply.FakeWep
        local FakeWep = ply.FakeWep
    
        if not self.HammerProgress then
            self.HammerProgress = 0
        end
    
        if self.LastHammerClick < CurTime() then
            if SERVER then
                sound.Play("arccw_go/revolver/revolver_prepare.wav", ply.FakeRagdoll:GetPos(), 75, 100, 1, 0)
            end
        end
    
        if SERVER and not self.Shooted then
            self.HammerProgress = math.Round(LerpFT(0.25, self.HammerProgress, 1), 2)
    
            if self.HammerProgress > 0.985 and not self.Shooted then
                self.Shooted = true
    
                ply.FakeWep:TakePrimaryAmmo(1)
                ply:GetWeapon(ply.CurWeapon):TakePrimaryAmmo(1)
    
                sound.Play(WepTBL.Primary.Sound[1], FakeWep:GetPos(), 75, 100, 1, 0)
    
                local bullet = {}
                local vecCone = Vector(0, 0, 0)
    
                local primary = WepTBL.Primary
                local cone = WepTBL.Primary.Cone
                vecCone[1] = cone
                vecCone[2] = cone
    
                bullet.Src = FakeWep:GetPos() + FakeWep:GetAngles():Forward() * 0
                bullet.Dir = FakeWep:GetAngles():Forward()
                bullet.Spread = vecCone
                bullet.Force = 5
                bullet.Damage = primary.Damage or 25
                bullet.Spread = primary.Spread or 0
                bullet.AmmoType = primary.Ammo
                bullet.Attacker = ply
                bullet.IgnoreEntity = nil
    
                FakeWep:GetPhysicsObject():ApplyForceCenter(FakeWep:GetAngles():Forward() * 2 +
                    FakeWep:GetAngles():Right() * VectorRand(-90, 90) + FakeWep:GetAngles():Up() * 200)
    
                FakeWep:FireBullets(bullet)
            end
        elseif SERVER and self.Shooted then
            self.HammerProgress = 0
        end
    
        self.LastHammerClick = CurTime() + 0.05
    
        if SERVER then
            self.HammerProgress = math.Round(LerpFT(0.25, self.HammerProgress, 0.0001), 2)
            self.Shooted = false
        end
    end
    

    if ply:KeyPressed(IN_ATTACK) and !WepTBL.Primary.Automatic and !WepTBL.CustomShoot then
        local FakeWep = ply.FakeWep

        if not ply.NextFakeShoot then
            ply.NextFakeShoot = 0
        end

        if ply.NextFakeShoot < CurTime() and ply:GetWeapon(ply.CurWeapon):Clip1() > 0 then
            ply.FakeWep:TakePrimaryAmmo(1)

            ply:GetWeapon(ply.CurWeapon):TakePrimaryAmmo(1)

            ply.NextFakeShoot = CurTime() + WepTBL.Primary.Wait

            sound.Play(WepTBL.Primary.Sound[1],FakeWep:GetPos(),75,100,1,0)

            local bullet = {}
            local vecCone = Vector(0, 0, 0)

            local primary = WepTBL.Primary

            local cone = WepTBL.Primary.Cone
	        vecCone[1] = cone
	        vecCone[2] = cone

            bullet.Src = FakeWep:GetPos() + FakeWep:GetAngles():Forward() * 0
            bullet.Dir = FakeWep:GetAngles():Forward()
            bullet.Spread = vecCone
	        bullet.Force = 5
	        bullet.Damage = primary.Damage or 25
	        bullet.Spread = primary.Spread or 0
	        bullet.AmmoType = primary.Ammo
	        bullet.Attacker = owner
	        bullet.IgnoreEntity = nil

            FakeWep:GetPhysicsObject():ApplyForceCenter(FakeWep:GetAngles():Forward()*2+FakeWep:GetAngles():Right()*VectorRand(-90,90)+FakeWep:GetAngles():Up()*200)

            FakeWep:FireBullets(bullet)
        end
    end
end)