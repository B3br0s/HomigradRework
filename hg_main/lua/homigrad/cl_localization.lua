hg.Localizations = hg.Localizations or {}
hg.CurLoc = hg.CurLoc or nil

local languageConvar = GetConVar("gmod_language")

function GetLocalization(lang)
    local Lang = lang or languageConvar:GetString()
    local Localization = hg.Localizations[Lang] or hg.Localizations["en"]
    
    if not lang then
        hg.CurLoc = Localization
    end
    
    return Localization
end

GetLocalization()

function GetPhrase(Phrase)
    if not hg.CurLoc then
        hg.CurLoc = GetLocalization()
    end
    
    return hg.CurLoc[Phrase] or Phrase
end

cvars.AddChangeCallback("gmod_language", function(convar_name, value_old, value_new)
    hg.CurLoc = GetLocalization(value_new)
    
    hook.Run("OnLanguageChanged", value_new, value_old)
end)

hg.GetPhrase = GetPhrase
hg.GetLocalization = GetLocalization