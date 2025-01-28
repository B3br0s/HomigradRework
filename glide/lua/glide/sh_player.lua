local PlayerMeta = FindMetaTable( "Player" )

local EntityMeta = FindMetaTable( "Entity" )
local getTable = EntityMeta.GetTable
local getNWEntity = EntityMeta.GetNWEntity
local eyeAngles = EntityMeta.EyeAngles
local eyePos = EntityMeta.EyePos

function PlayerMeta:GlideGetVehicle()
    return getNWEntity( self, "GlideVehicle", NULL )
end

function PlayerMeta:GlideGetSeatIndex()
    return getNWEntity( self, "GlideSeatIndex", -1 )
end

if SERVER then
    --- Get the player's Glide camera position.
    function PlayerMeta:GlideGetCameraPos()
        local selfTbl = getTable( self )
        return selfTbl.GlideCam and selfTbl.GlideCam.origin or eyePos( self )
    end

    --- Get the player's Glide camera angles.
    function PlayerMeta:GlideGetCameraAngles()
        local selfTbl = getTable( self )
        return selfTbl.GlideCam and selfTbl.GlideCam.angle or eyeAngles( self )
    end

    local TraceLine = util.TraceLine

    function PlayerMeta:GlideGetAimPos()
        local origin = self:GlideGetCameraPos()

        return TraceLine( {
            start = origin,
            endpos = origin + self:GlideGetCameraAngles():Forward() * 50000,
            filter = { self, self:GlideGetVehicle() }
        } ).HitPos
    end
end
