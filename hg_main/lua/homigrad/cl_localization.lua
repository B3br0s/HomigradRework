hg.Localizations = hg.Localizations or {}

hg.CurLoc = hg.CurLoc or nil

function GetLocalization()
    
    local Lang = GetConVar("gmod_language"):GetString()

    local Localization = hg.Localizations[Lang]

    if Localization == nil then
        Localization = hg.Localizations["en"]
    end

    --print(Localization)

    return Localization
end

GetLocalization()

function GetPhrase(Phrase)
    if hg.CurLoc == nil then
        hg.CurLoc = GetLocalization()
    end

    if hg.CurLoc != nil and hg.CurLoc[Phrase] then
        return hg.CurLoc[Phrase]
    else
        return Phrase
    end
end

hg.GetPhrase = GetPhrase
hg.GetLocalization = GetLocalization