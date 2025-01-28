-- Class to manage the quads for skid marks/tire roll marks
local SkidHandler = Glide.SkidHandler or {}

Glide.SkidHandler = SkidHandler
SkidHandler.__index = SkidHandler

function SkidHandler.Instantiate( maxPieces, materialPath )
    return setmetatable( {
        material = Material( materialPath ),
        maxPieces = maxPieces,
        lastQuadIndex = 0,
        quadCount = 0,
        quads = {}
    }, SkidHandler )
end

function SkidHandler:Destroy()
    self.pieces = nil
    self.material = nil
    setmetatable( self, nil )
end

local Color = Color
local Vector = Vector
local TraceLine = util.TraceLine

local traceData = {
    mask = 131083 -- MASK_NPCWORLDSTATIC
}

function SkidHandler:AddPiece( lastQuadId, pos, dir, normal, width, strength )
    traceData.start = pos + normal * 10
    traceData.endpos = pos - normal * 10

    local tr = TraceLine( traceData )
    if not tr.Hit then return end

    pos = tr.HitPos + normal * 1

    local quads = self.quads
    local i = self.lastQuadIndex + 1

    if i > self.maxPieces then i = 1 end
    if i > self.quadCount then self.quadCount = i end

    self.lastQuadIndex = i

    local v1 = Vector( 0, width, 0.2 )
    local v2 = Vector( 0, -width, 0.2 )

    dir:Normalize()

    local ang = dir:Angle()
    v1:Rotate( ang )
    v2:Rotate( ang )

    v1 = pos + v1
    v2 = pos + v2

    local lastQuad = quads[lastQuadId]

    quads[i] = {
        v1,
        v2,
        lastQuad and lastQuad[2] or pos,
        lastQuad and lastQuad[1] or pos,
        Color( 255, 255, 255, 55 + 200 * strength )
    }

    return i
end

local SetMaterial = render.SetMaterial
local DrawQuad = render.DrawQuad

function SkidHandler:Draw()
    SetMaterial( self.material )

    local quads = self.quads
    local q

    for i = 1, self.quadCount do
        q = quads[i]
        DrawQuad( q[1], q[2], q[3], q[4], q[5] )
    end
end

-----

local skidMarkHandler = Glide.skidMarkHandler
local tireRollHandler = Glide.tireRollHandler

function Glide.AddSkidMarkPiece( lastQuadId, pos, dir, normal, width, strength )
    if skidMarkHandler then
        return skidMarkHandler:AddPiece( lastQuadId, pos, dir, normal, width, strength )
    end
end

function Glide.AddTireRollPiece( lastQuadId, pos, dir, normal, width, strength )
    if tireRollHandler then
        return tireRollHandler:AddPiece( lastQuadId, pos, dir, normal, width, strength )
    end
end

function Glide.DestroySkidMarkMeshes()
    if Glide.skidMarkHandler then
        Glide.skidMarkHandler:Destroy()
        Glide.Print( "Skid mark mesh has been destroyed." )
    end

    if Glide.tireRollHandler then
        Glide.tireRollHandler:Destroy()
        Glide.Print( "Tire roll mesh has been destroyed." )
    end

    Glide.tireRollHandler = nil
    Glide.skidMarkHandler = nil

    skidMarkHandler = nil
    tireRollHandler = nil
end

function Glide.SetupSkidMarkMeshes()
    Glide.DestroySkidMarkMeshes()

    local Config = Glide.Config

    -- Mesh handler for skid marks
    if Config.maxSkidMarkPieces > 0 then
        skidMarkHandler = SkidHandler.Instantiate( Config.maxSkidMarkPieces, "glide/skidmarks/skid_asphalt" )

        Glide.skidMarkHandler = skidMarkHandler
        Glide.Print( "Initialized skid mark mesh with %d max. quads.", skidMarkHandler.maxPieces )
    end

    -- Mesh handler for tire roll marks
    if Config.maxTireRollPieces > 0 then
        tireRollHandler = SkidHandler.Instantiate( Config.maxTireRollPieces, "glide/skidmarks/roll_dirt" )

        Glide.tireRollHandler = tireRollHandler
        Glide.Print( "Initialized tire roll mesh with %d max. quads.", tireRollHandler.maxPieces )
    end
end

hook.Add( "InitPostEntity", "Glide.CreateSkidMarkMeshes", Glide.SetupSkidMarkMeshes )
hook.Add( "PreCleanupMap", "Glide.RemoveSkidMarkMeshes", Glide.DestroySkidMarkMeshes )
hook.Add( "PostCleanupMap", "Glide.RecreateSkidMarkMeshes", Glide.SetupSkidMarkMeshes )

local SetBlend = render.SetBlend
local SetColorModulation = render.SetColorModulation

hook.Add( "PreDrawTranslucentRenderables", "Glide.RenderSkidMarks", function( _, isDrawSkybox, isDraw3DSkybox )
    if isDrawSkybox or isDraw3DSkybox then return end

    SetBlend( 1 )
    SetColorModulation( 1, 1, 1 )

    if skidMarkHandler then
        skidMarkHandler:Draw()
    end

    if tireRollHandler then
        tireRollHandler:Draw()
    end
end )
