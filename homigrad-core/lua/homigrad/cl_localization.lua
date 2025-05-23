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

hook.Add("InitPostEntity","Localization_Setup",function()
    hook.Run("OnLanguageChanged",GetConVar("gmod_language"):GetString())
end)

hg.GetPhrase = GetPhrase
hg.GetLocalization = GetLocalization

/*hook.Add("Player Think","LocalizeWeps",function(ply)
    do return end
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

hook.Add("OnEntityCreated","123",function(ent)
    do return end
    if ent:IsWeapon() then

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
            return
        end

        if ent.isMelee then
            local self = weapons.Get(ent:GetClass())
            ent.Purpose = (string.format(hg.GetPhrase("wep_dmg"),self.Primary.Damage).."\n"..string.format(hg.GetPhrase("wep_delay"),self.Primary.Delay))
            weapons.Get(ent:GetClass()).Purpose = (string.format(hg.GetPhrase("wep_dmg"),self.Primary.Damage).."\n"..string.format(hg.GetPhrase("wep_delay"),self.Primary.Delay))
        end

        weapons.Get(ent:GetClass()).PrintName = hg.GetPhrase(ent:GetClass())
        ent.PrintName = hg.GetPhrase(ent:GetClass())
    end
end)*/

function GetCurrentName()
    local str = debug.getinfo(2, "S").source
    local filename = string.match(str, "([^/\\]+)$") or "unknown"
    local a = filename:gsub("%.lua$", "")
    return a
end

hook.Add("OnEntityCreated","LocalizeWep",function(ent)
    if IsValid(ent) and isentity(ent) and ent:IsWeapon() then
        local wep = ent

        wep.PrintName = (hg.GetPhrase(wep.ClassName) != (wep.ClassName) and hg.GetPhrase(wep.ClassName) or wep.PrintName)
    end
end)

hook.Add("OnLanguageChanged","Localization_Wep",function()
    for _, wep in pairs(weapons.GetList()) do   
        wep.PrintName = (hg.GetPhrase(wep.ClassName) != (wep.ClassName) and hg.GetPhrase(wep.ClassName) or wep.PrintName)
    end
    for _, wep in pairs(ents.GetAll()) do
        if isentity(wep) and wep:IsWeapon() then
            wep.PrintName = (hg.GetPhrase(wep.ClassName) != (wep.ClassName) and hg.GetPhrase(wep.ClassName) or wep.PrintName)
        end
    end
end)

hook.Run("OnLanguageChanged")

hook.Add("InitPostEntity","Localize",function()
    hook.Run("OnLanguageChanged")
end)

hook.Add("OnReloaded","Localize",function()
    hook.Run("OnLanguageChanged")
end)