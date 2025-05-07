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

hook.Add("Player Think","LocalizeWeps",function(ply)
    for _, ent in ipairs(ply:GetWeapons()) do
        if !ent:IsWeapon() then
            continue 
        end

        if hg.GetPhrase(ent:GetClass().."_desc") != ent:GetClass().."_desc" then
            ent.Instructions = hg.GetPhrase(ent:GetClass().."_desc")
            weapons.Get(ent:GetClass()).Instructions = hg.GetPhrase(ent:GetClass().."_desc")
        end

        if ent.ishgwep then
            local self = weapons.Get(ent:GetClass())
            ent.Purpose = (string.format(hg.GetPhrase("wep_dmg"),self.Primary.Damage).."\n"..string.format(hg.GetPhrase("wep_delay"),self.Primary.Wait).."\n"..string.format(hg.GetPhrase("wep_force"),self.Primary.Force))
            weapons.Get(ent:GetClass()).Purpose = (string.format(hg.GetPhrase("wep_dmg"),self.Primary.Damage).."\n"..string.format(hg.GetPhrase("wep_delay"),self.Primary.Wait).."\n"..string.format(hg.GetPhrase("wep_force"),self.Primary.Force))
        end

        if hg.GetPhrase(ent:GetClass()) == ent:GetClass() then
            continue 
        end

        if ent.isMelee then
            local self = weapons.Get(ent:GetClass())
            ent.Purpose = (string.format(hg.GetPhrase("wep_dmg"),self.Primary.Damage).."\n"..string.format(hg.GetPhrase("wep_delay"),self.Primary.Delay))
            weapons.Get(ent:GetClass()).Purpose = (string.format(hg.GetPhrase("wep_dmg"),self.Primary.Damage).."\n"..string.format(hg.GetPhrase("wep_delay"),self.Primary.Delay))
        end

        weapons.Get(ent:GetClass()).PrintName = hg.GetPhrase(ent:GetClass())
        ent.PrintName = hg.GetPhrase(ent:GetClass())
    end
end)

hook.Add("Think","LocalizeWeapons",function()
    for _, ent in ipairs(ents.GetAll()) do
        if !ent:IsWeapon() then
            continue 
        end

        if hg.GetPhrase(ent:GetClass().."_desc") != ent:GetClass().."_desc" then
            ent.Instructions = hg.GetPhrase(ent:GetClass().."_desc")
            weapons.Get(ent:GetClass()).Instructions = hg.GetPhrase(ent:GetClass().."_desc")
        end

        if ent.ishgwep then
            local self = weapons.Get(ent:GetClass())
            ent.Purpose = (string.format(hg.GetPhrase("wep_dmg"),self.Primary.Damage).."\n"..string.format(hg.GetPhrase("wep_delay"),self.Primary.Wait).."\n"..string.format(hg.GetPhrase("wep_force"),self.Primary.Force))
            weapons.Get(ent:GetClass()).Purpose = (string.format(hg.GetPhrase("wep_dmg"),self.Primary.Damage).."\n"..string.format(hg.GetPhrase("wep_delay"),self.Primary.Wait).."\n"..string.format(hg.GetPhrase("wep_force"),self.Primary.Force))
        end

        if hg.GetPhrase(ent:GetClass()) == ent:GetClass() then
            continue 
        end

        if ent.isMelee then
            local self = weapons.Get(ent:GetClass())
            ent.Purpose = (string.format(hg.GetPhrase("wep_dmg"),self.Primary.Damage).."\n"..string.format(hg.GetPhrase("wep_delay"),self.Primary.Delay))
            weapons.Get(ent:GetClass()).Purpose = (string.format(hg.GetPhrase("wep_dmg"),self.Primary.Damage).."\n"..string.format(hg.GetPhrase("wep_delay"),self.Primary.Delay))
        end

        weapons.Get(ent:GetClass()).PrintName = hg.GetPhrase(ent:GetClass())
        ent.PrintName = hg.GetPhrase(ent:GetClass())
    end
end)