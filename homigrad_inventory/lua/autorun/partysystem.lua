    if SERVER then
        util.AddNetworkString("InvitePlayer")
        util.AddNetworkString("InviteDecline")
        util.AddNetworkString("InviteAccept")
        util.AddNetworkString("SyncParty")
        util.AddNetworkString("ClearParty")
        util.AddNetworkString("LeaveParty")

        local partyTable = {}

        local function SyncParty(ply)
            if partyTable[ply] then
                for _, member in ipairs(partyTable[ply]) do
                    net.Start("SyncParty")
                    net.WriteTable(partyTable[ply])
                    net.Send(member)
                end
            end
        end

        local function ClearPlayerFromParties(ply)
            for inviter, party in pairs(partyTable) do
                for i = #party, 1, -1 do
                    if party[i] == ply then
                        table.remove(party, i)
                    end
                end
        
                -- If the party is now empty, remove it from the partyTable
                if #party == 0 then
                    partyTable[inviter] = nil
                else
                    -- Sync the party to all remaining members
                    SyncParty(inviter)
                end
            end
        
            -- Notify the player who is leaving
            net.Start("ClearParty")
            net.Send(ply)
        end
        
        net.Receive("LeaveParty", function()
            local ply = net.ReadEntity()
            if IsValid(ply) then
                ClearPlayerFromParties(ply)
                ply:SetNWBool("InTeam", false)
            end
        end)        

        net.Receive("InvitePlayer", function()
            local plya = net.ReadEntity() -- Inviter
            local plyb = net.ReadEntity() -- Invited

            if IsValid(plya) and IsValid(plyb) then
                plyb.InviterToTeam = plya
                net.Start("InvitePlayer")
                net.WriteEntity(plya)
                net.Send(plyb)
            end
        end)

        net.Receive("InviteAccept", function()
            local plya = net.ReadEntity() -- Inviter
            local plyb = net.ReadEntity() -- Invited

            if IsValid(plya) and IsValid(plyb) then
                if not partyTable[plya] then
                    partyTable[plya] = {plya}
                end

                if not table.HasValue(partyTable[plya], plyb) then
                    table.insert(partyTable[plya], plyb)
                end

                plya:SetNWBool("InTeam", true)
                plyb:SetNWBool("InTeam", true)

                plyb.InviterToTeam = NULL
                plyb:SetNWEntity("InviterToTeam", NULL)

                SyncParty(plya)

                net.Start("InviteAccept")
                net.WriteEntity(plyb)
                net.Send(plya)
            end
        end)

        net.Receive("InviteDecline", function()
            local plya = net.ReadEntity() -- Inviter
            local plyb = net.ReadEntity() -- Invited

            if IsValid(plya) and IsValid(plyb) then
                plya:ChatPrint(plyb:Name() .. " отклонил ваше приглашение в команду.")
                plyb:SetNWEntity("InviterToTeam", NULL)
                plyb.InviterToTeam = NULL
            end
        end)
        
        net.Receive("LeaveParty", function()
            local ply = net.ReadEntity()
            if IsValid(ply) then
                ClearPlayerFromParties(ply)
                ply:SetNWBool("InTeam", false)
        
                net.Start("ClearParty")
                net.Send(ply)
            end
        end)
        

        hook.Add("PlayerDisconnected", "ClearPartyOnDisconnect", function(ply)
            ClearPlayerFromParties(ply)
        end)

        hook.Add("PlayerDeath", "ClearPartyOnDeath", function(ply)
            ClearPlayerFromParties(ply)
        end)

    else -- CLIENT SIDE
        local someshit = {LocalPlayer()}
        hook.Add("HUDPaint","Zelenkaguru",function ()
            if LocalPlayer():GetNWEntity("InTeam") and LocalPlayer():Alive() then
                for i = 1,#someshit do
                draw.SimpleText(someshit[i]:Name(), "HomigradFont", ScrW() / 17, ScrH() / 1.14 + 15 * i, Color(0, 255, 0), TEXT_ALIGN_LEFT)
                surface.SetDrawColor( 255, 255, 255, 255 )
                surface.SetMaterial(Material("icon16/bullet_green.png"))
                surface.DrawTexturedRect( ScrW() / 20, ScrH() / 1.1365 + 15 * i, 15,15)
            end
            end
        end)
        
        local function InitPartySystem()
            local partyMembers = {LocalPlayer()}
            local firstAlive = false

            local function CheckPartyMembersAlive()
                someshit = partyMembers
                if #partyMembers > 1 then
                    for i = #partyMembers, 1, -1 do
                        local ply = partyMembers[i]
                        if IsValid(ply) and ply ~= LocalPlayer() then
                            if not ply:Alive() then
                                table.remove(partyMembers, i)
                            end
                        end
                    end
                end
            end

            local function ResetPartyOnDeathOrRespawn()
                local ply = LocalPlayer()
                if not ply:Alive() then
                    table.Empty(partyMembers)
                    table.insert(partyMembers, ply)
                    firstAlive = false
                elseif not firstAlive then
                    firstAlive = true
                    table.Empty(partyMembers)
                    table.insert(partyMembers, ply)
                end
            end

            local function OnReceiveInvite()
                local inviter = net.ReadEntity()
                local ply = LocalPlayer()

                if ply:GetNWBool("InTeam") then return end
                if IsValid(inviter) then
                    ply:ChatPrint("Вы получили приглашение в команду от " .. inviter:Name())
                end
            end

            local function OnSyncParty()
                local updatedParty = net.ReadTable()

                table.Empty(partyMembers)
                for _, ply in ipairs(updatedParty) do
                    if IsValid(ply) then
                        table.insert(partyMembers, ply)
                    end
                end
            end

            local function ClearParty()
                table.Empty(partyMembers)
                table.insert(partyMembers, LocalPlayer())
                
                LocalPlayer():SetNWBool("InTeam", false)
            end
            

            local function OnInviteAccept()
                local ply = net.ReadEntity()
                if IsValid(ply) then
                    ply:ChatPrint(ply:Nick() .. " Принял ваше приглашение в команду")
                end
            end

            local function OnPlayerDeath(victim)
                if victim == LocalPlayer() then
                    table.Empty(partyMembers)
                end
            end

            local function OnPlayerSpawn(ply)
                if ply == LocalPlayer() then
                    table.Empty(partyMembers)
                    table.insert(partyMembers, ply)
                end
            end

            local function DrawPartyPlayerBoundingBoxes()
                if not LocalPlayer():Alive() then return end

                for _, ply in ipairs(partyMembers) do
                    if IsValid(ply) and ply:Alive() and ply ~= LocalPlayer() then
                        local mins, maxs = ply:OBBMins(), ply:OBBMaxs()
                        local corners = {
                            Vector(mins.x, mins.y, mins.z),
                            Vector(mins.x, maxs.y, mins.z),
                            Vector(maxs.x, maxs.y, mins.z),
                            Vector(maxs.x, mins.y, mins.z),
                            Vector(mins.x, mins.y, maxs.z),
                            Vector(mins.x, maxs.y, maxs.z),
                            Vector(maxs.x, maxs.y, maxs.z),
                            Vector(maxs.x, mins.y, maxs.z)
                        }

                        local scrCorners = {}

                        for _, corner in ipairs(corners) do
                            local worldPos = ply:LocalToWorld(corner)
                            local screenPos = worldPos:ToScreen()
                            table.insert(scrCorners, {x = screenPos.x, y = screenPos.y})
                        end

                        local minX, minY = scrCorners[1].x, scrCorners[1].y
                        local maxX, maxY = scrCorners[1].x, scrCorners[1].y

                        for _, scrPos in ipairs(scrCorners) do
                            minX = math.min(minX, scrPos.x)
                            minY = math.min(minY, scrPos.y)
                            maxX = math.max(maxX, scrPos.x)
                            maxY = math.max(maxY, scrPos.y)
                        end

                        surface.SetDrawColor(0, 255, 0, 255)
                        surface.DrawOutlinedRect(minX, minY, maxX - minX, maxY - minY)

                        local nickX = (minX + maxX) / 2
                        local nickY = minY - 20

                        draw.SimpleText(ply:Nick(), "HomigradFontBig", nickX, nickY, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    end
                end
            end

            hook.Add("Think", "CheckPartyMembersAlive", CheckPartyMembersAlive)
            hook.Add("Think", "ResetPartyOnDeathOrRespawn", ResetPartyOnDeathOrRespawn)
            net.Receive("InvitePlayer", OnReceiveInvite)
            net.Receive("SyncParty", OnSyncParty)
            net.Receive("ClearParty", ClearParty)
            net.Receive("InviteAccept", OnInviteAccept)
            hook.Add("PlayerDeath", "ClearTeamOnDeath", OnPlayerDeath)
            hook.Add("PlayerSpawn", "ClearTeamOnSpawn", OnPlayerSpawn)
            hook.Add("HUDPaint", "DrawPartyPlayerBoundingBoxes", DrawPartyPlayerBoundingBoxes)
        end
    
        InitPartySystem()

    end
