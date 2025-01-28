--[[
    Periodically check the screen resolution and update fonts when necessary.
]]

local fontList = {
    ["GlideSelectedWeapon"] = {
        sizeMultiplier = 0.018,
        font = "Roboto",
        extended = false,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true
    },
    ["GlideNotification"] = {
        sizeMultiplier = 0.022,
        font = "Roboto",
        extended = false,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true
    },
    ["GlideHUD"] = {
        sizeMultiplier = 0.022,
        font = "Roboto",
        extended = false,
        weight = 400,
        blursize = 0,
        scanlines = 0,
        antialias = true
    }
}

local lastW, lastH = 0, 0

function Glide.UpdateFonts()
    lastW, lastH = ScrW(), ScrH()

    Glide.Print( "Updating fonts to match new resolution: %dx%d", lastW, lastH )

    for name, data in pairs( fontList ) do
        data.size = math.floor( lastH * data.sizeMultiplier )
        surface.CreateFont( name, data )
    end
end

Glide.UpdateFonts()

local ScrW, ScrH = ScrW, ScrH

timer.Create( "Glide.UpdateFonts", 3, 0, function()
    if ScrW() ~= lastW or ScrH() ~= lastH then
        Glide.UpdateFonts()
    end
end )
