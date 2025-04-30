--шейред парт.
hg.Appearance = hg.Appearance or {}
local SubMaterials = {
    -- Male
    ["models/player/group01/male_01.mdl"] = 3,
    ["models/player/group01/male_02.mdl"] = 2,
    ["models/player/group01/male_03.mdl"] = 4,
    ["models/player/group01/male_04.mdl"] = 4,
    ["models/player/group01/male_05.mdl"] = 4,
    ["models/player/group01/male_06.mdl"] = 0,
    ["models/player/group01/male_07.mdl"] = 4,
    ["models/player/group01/male_08.mdl"] = 0,
    ["models/player/group01/male_09.mdl"] = 2,
    -- Female
    ["models/player/group01/female_01.mdl"] = 2,
    ["models/player/group01/female_02.mdl"] = 3,
    ["models/player/group01/female_03.mdl"] = 3,
    ["models/player/group01/female_04.mdl"] = 1,
    ["models/player/group01/female_05.mdl"] = 2,
    ["models/player/group01/female_06.mdl"] = 4
}

hg.Appearance.SubMaterials = SubMaterials

local Clothes = {--еее русификатор
    ["Нормальный"] = { [1] = "models/humans/male/group01/normal", [2] = "models/humans/female/group01/normal" },
    ["Формальный"] = { [1] = "models/humans/male/group01/formal", [2] = "models/humans/female/group01/formal" },
    ["Клетчатый"] = { [1] = "models/humans/male/group01/plaid", [2] = "models/humans/female/group01/plaid" },
    ["Полоски"] = { [1] = "models/humans/male/group01/striped", [2] = "models/humans/female/group01/striped" },
    ["Молодой"] = { [1] = "models/humans/male/group01/young", [2] = "models/humans/female/group01/young" },
    ["Куртка"] = { [1] = "models/humans/male/group01/cold", [2] = "models/humans/female/group01/cold" },
    ["Казуал"] = { [1] = "models/humans/male/group01/casual", [2] = "models/humans/female/group01/casual" }
}
hg.Appearance.Clothes = Clothes

local PlayerModels = {
    [1] = {},
    [2] = {}
}
for i = 1, 9 do
    table.insert(PlayerModels[1], "models/player/group01/male_0" .. i .. ".mdl")
end
for i = 1, 6 do
    table.insert(PlayerModels[2], "models/player/group01/female_0" .. i .. ".mdl")
end

hg.Appearance.PlayerModels = PlayerModels

local ModelsAllowed = {
    [1] = {
        ["models/player/group01/male_01.mdl"] = true,
        ["models/player/group01/male_02.mdl"] = true,
        ["models/player/group01/male_03.mdl"] = true,
        ["models/player/group01/male_04.mdl"] = true,
        ["models/player/group01/male_05.mdl"] = true,
        ["models/player/group01/male_06.mdl"] = true,
        ["models/player/group01/male_07.mdl"] = true,
        ["models/player/group01/male_08.mdl"] = true,
        ["models/player/group01/male_09.mdl"] = true
    },
    [2] = {
        ["models/player/group01/female_01.mdl"] = true,
        ["models/player/group01/female_02.mdl"] = true,
        ["models/player/group01/female_03.mdl"] = true,
        ["models/player/group01/female_04.mdl"] = true,
        ["models/player/group01/female_05.mdl"] = true,
        ["models/player/group01/female_06.mdl"] = true
    } 
}

local AllModels = {
    "models/player/group01/female_01.mdl",
    "models/player/group01/female_02.mdl",
    "models/player/group01/female_03.mdl",
    "models/player/group01/female_04.mdl",
    "models/player/group01/female_05.mdl",
    "models/player/group01/female_06.mdl",
    "models/player/group01/male_01.mdl",
    "models/player/group01/male_02.mdl",
    "models/player/group01/male_03.mdl",
    "models/player/group01/male_04.mdl",
    "models/player/group01/male_05.mdl",
    "models/player/group01/male_06.mdl",
    "models/player/group01/male_07.mdl",
    "models/player/group01/male_08.mdl",
    "models/player/group01/male_09.mdl"
}

local RandomNames = {
    [1] = { -- Male
        "Mike", "Dave", "Michel", "John", "Fred", "Michiel", "Steven", "Sergio",
        "Joel", "Samuel", "Larry", "Sean", "Thomas", "Jose", "Bobby", "Richard", "David"
    },
    [2] = { -- Female
        "Denise", "Joyce", "Jane", "Sara", "Emily", "Charlotte", "Cathy", "Ruth",
        "Julia", "Tanya", "Wanda", "Elizabeth", "Nicole", "Stacey", "Mary", "Anna", "Diana"
    }
}

if SERVER then
util.AddNetworkString("AppearanceSet")
util.AddNetworkString("AppearanceGet")

net.Receive("AppearanceSet",function(l,ply)
    local AppearanceTable = net.ReadTable()
    ply.Appearance = AppearanceTable
    ply:SetModel(AppearanceTable.Model)
    ply:SetPlayerColor(Vector(AppearanceTable.Color.r / 255,AppearanceTable.Color.g / 255,AppearanceTable.Color.b / 255))
    ply:SetSubMaterial()
    ply:SetSubMaterial(SubMaterials[string.lower(AppearanceTable.Model)],Clothes[AppearanceTable.ClothesStyle][AppearanceTable.FEMKA and 2 or 1])
end)

function ApplyAppearance(ent,AppearanceTable)
    if ent:IsRagdoll() and hg.RagdollOwner(ent) != nil and hg.RagdollOwner(ent).AppearanceOverride then
        return
    end
    if not AppearanceTable then return end
    ent.Appearance = AppearanceTable
    ent:SetModel(AppearanceTable.Model or ent:GetModel())
    ent:SetPlayerColor(Vector(AppearanceTable.Color.r / 255,AppearanceTable.Color.g / 255,AppearanceTable.Color.b / 255))
    ent:SetSubMaterial()
    ent:SetSubMaterial(SubMaterials[string.lower(AppearanceTable.Model)],Clothes[AppearanceTable.ClothesStyle][AppearanceTable.Gender])
end

function ApplyAppearanceEntity(ent,AppearanceTable)
    if not AppearanceTable then return end
    ent:SetSubMaterial()
    ent:SetSubMaterial(SubMaterials[string.lower(AppearanceTable.Model)],Clothes[AppearanceTable.ClothesStyle][AppearanceTable.Gender])
end
else

function ThatPlyIsFemale(mdl)
    if not isstring(mdl) then
        mdl = mdl:GetModel()
    end
    if ModelsAllowed[2][mdl] then
        return true
    else
        return false
    end
end

function ApplyAppearance(tbl)
    net.Start("AppearanceSet")
    net.WriteTable(tbl)
    net.SendToServer()

    --local AppearanceTable = tbl
    --for _, mat in ipairs(LocalPlayer():GetMaterials()) do
    --    print(mat)
    --end
end

function CreateRandomAppearance()--создание случайного апиренс
    local mdl = table.Random(AllModels)
    local isfemale = ThatPlyIsFemale(mdl)
    local plyname = (isfemale and table.Random(RandomNames[2]) or table.Random(RandomNames[1]))
    local clothes = "Нормальный"

    local AppTable = {
        Model = mdl,
        FEMKA = isfemale,
        Name = plyname,
        Gender = (isfemale and 2 or 1),
        ClothesStyle = clothes,
        Color = Color(math.random(1,255),math.random(1,255),math.random(1,255)),
        SubMaterial = Clothes[clothes][isfemale and 2 or 1]
    }

    file.CreateDir("hgr")
    file.Write("hgr/appearance.json",util.TableToJSON(AppTable))
end

local open = open or false
local appearancemenu

function SetAppearance(tbl)
    file.Write("hgr/appearance.json",util.TableToJSON(tbl))
end

function OpenAppMenu()
    --if LocalPlayer():Alive() then LocalPlayer():ChatPrint("Вы должны быть мертвы для изменения вашего внешнего вида.") return end --хз?????
    open = not open
    local gradient_d = Material("vgui/gradient-d")
    local blurMat = Material("pp/blurscreen")
    local Dynamic = 0
    local red = Color(34,34,34)
    if open then
        local menuappearance = vgui.Create("DFrame")
        menuappearance:SetSize( 500, 600 )
        menuappearance:Center()
        menuappearance:SetTitle( " " ) --нахуя?
        menuappearance:SetVisible( true ) 
        menuappearance:SetDraggable( true ) 
        menuappearance:ShowCloseButton( true ) 
        menuappearance:MakePopup()

        local AppearanceTableJSON = file.Read("hgr/appearance.json","DATA")
        local AppearanceTable = util.JSONToTable(AppearanceTableJSON)

        appearancemenu = menuappearance

        function menuappearance:Paint(w,h)
            draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 0, 0, 0, 140) )
            surface.SetMaterial(gradient_d)
            surface.DrawTexturedRect( 0, 0, w, h )
            surface.SetDrawColor( 34,34,34, 128)
            surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
        end

        local BasePanel = vgui.Create( "DPanel", appearancemenu )
        BasePanel:Dock( RIGHT )
        BasePanel:SetSize(190,450)
        BasePanel:DockMargin(0,0,2.5,5)
        function BasePanel:Paint( w, h )
        end

        local Mixer = vgui.Create("DColorMixer", BasePanel)
        Mixer:Dock(TOP)	
        Mixer:SetPalette(false)	
        Mixer:SetSize(0,100)
        Mixer:DockMargin( 5,5,5,0 )
        Mixer:SetAlphaBar(false)
        Mixer:SetWangs(false)
        Mixer:SetColor(Color(AppearanceTable.Color.r, AppearanceTable.Color.g, AppearanceTable.Color.b))
        function Mixer:ValueChanged(value)
            AppearanceTable.Color = value
        end

        local PlayerModel = vgui.Create("DAdjustableModelPanel",appearancemenu)
        PlayerModel:SetSize(230,480)
        PlayerModel:SetPos(0,70)
        PlayerModel:SetModel(LocalPlayer():GetModel() )
        PlayerModel:SetFOV( 35 )
        PlayerModel:SetLookAng( Angle( 15, 180, 0 ) )
        PlayerModel:SetCamPos( Vector( 55, 0, 55 ) )

        function PlayerModel:LayoutEntity( Entity ) 
            Entity.Angles = Entity.Angles or Angle(0,0,0)
            Entity:SetNWVector("PlayerColor",Vector(AppearanceTable.Color.r / 255, AppearanceTable.Color.g / 255, AppearanceTable.Color.b / 255))
            Entity:SetAngles(Entity.Angles)
            Entity:SetSubMaterial()
            Entity:SetSubMaterial(SubMaterials[string.lower(AppearanceTable.Model)],Clothes[AppearanceTable.ClothesStyle][AppearanceTable.Gender])
        end

        function PlayerModel.Entity:GetPlayerColor() return Vector(AppearanceTable.Color.r / 255, AppearanceTable.Color.g / 255, AppearanceTable.Color.b / 255) end

        local Label = vgui.Create( "DLabel", BasePanel )
        Label:Dock( TOP )
        Label:SetSize(200,15)
        Label:DockMargin( 10, 50.5, 2, 0 )
        Label:SetText("Одежда")
        Label:SetTextColor(color_white)

        local ClothesStyle = vgui.Create( "DComboBox", BasePanel )
        ClothesStyle:Dock( TOP )
        ClothesStyle:DockMargin( 2,5,2,0 )
        ClothesStyle:SetSize( 200, 30 )
        ClothesStyle:SetTextColor(color_white)
        for k, v in pairs(Clothes) do
            ClothesStyle:AddChoice( k )
        end
        ClothesStyle:SetValue( AppearanceTable.ClothesStyle )
        ClothesStyle.OnSelect = function( self, index, value )
            Style = value
            AppearanceTable.ClothesStyle = tostring(value)
            local sounds = {
                "eft_gear_sounds/gear_generic_use.wav",
                "eft_gear_sounds/gear_generic_pickup.wav",
                "eft_gear_sounds/gear_armor_pickup.wav",
                "eft_gear_sounds/gear_armor_drop.wav",
                "eft_gear_sounds/gear_backpack_pickup.wav"
            }
            surface.PlaySound(table.Random(sounds))
        end

        local ModelSelector = vgui.Create( "DComboBox", BasePanel )
        ModelSelector:Dock( TOP )
        ModelSelector:DockMargin( 2,5,2,0 )
        ModelSelector:SetSize( 200, 30 )
        ModelSelector:SetTextColor(color_white)
        ModelSelector:SetValue( AppearanceTable.Model )
        for k, v in ipairs(PlayerModels[AppearanceTable.Gender]) do
            ModelSelector:AddChoice( v )
        end
        function ModelSelector:Paint( w, h )
            self.a = Lerp(0.1,self.a or 100,self:IsHovered() and 255 or 150)
            draw.RoundedBox(0, 0, 0, w, h, Color(red.r,red.g,red.b,self.a))
            surface.SetDrawColor( color_black)
            surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
        end
        ModelSelector.OnSelect = function( self, index, value )
            PlayerModel:SetModel(value)
            AppearanceTable.Model = value
            function PlayerModel.Entity:GetPlayerColor() return Vector(AppearanceTable.Color.r / 255, AppearanceTable.Color.g / 255, AppearanceTable.Color.b / 255) end
        end

        local GenderSelector = vgui.Create( "DComboBox", BasePanel )
        GenderSelector:Dock( TOP )
        GenderSelector:DockMargin( 2,5,2,0 )
        GenderSelector:SetSize( 200, 30 )
        GenderSelector:SetValue( ( ( AppearanceTable.Gender == 1 and "Мужчина" ) or ( AppearanceTable.Gender == 2 and "Женщина" ) ) or "Мужчина")
        GenderSelector:AddChoice( "Мужчина" )
        GenderSelector:AddChoice( "Женщина" )
        GenderSelector:SetTextColor(color_white)
        function GenderSelector:Paint( w, h )
            self.a = Lerp(0.1,self.a or 100,self:IsHovered() and 255 or 150)
            draw.RoundedBox(0, 0, 0, w, h, Color(red.r,red.g,red.b,self.a))
            surface.SetDrawColor( color_black)
            surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
        end

        GenderSelector.OnSelect = function( self, index, value )
            PlayerModel:SetModel(index == 1 and "models/player/group01/male_01.mdl" or index == 2 and "models/player/group01/female_01.mdl")
            ModelSelector:Clear()
            ModelSelector:SetValue( index == 1 and "models/player/group01/male_01.mdl" or index == 2 and "models/player/group01/female_01.mdl" )
            AppearanceTable.Gender = index
            if index == 1 then
                AppearanceTable.FEMKA = false
            else
                AppearanceTable.FEMKA = true
            end
            AppearanceTable.Model = index == 1 and "models/player/group01/male_01.mdl" or index == 2 and "models/player/group01/female_01.mdl"
            AppearanceTable.ClothesStyle = Style

            function PlayerModel.Entity:GetPlayerColor() return Vector(AppearanceTable.Color.r / 255, AppearanceTable.Color.g / 255, AppearanceTable.Color.b / 255) end

            for k, v in ipairs(PlayerModels[index]) do
                ModelSelector:AddChoice( v )
            end
        end

        local ApplyButton = vgui.Create( "DButton", BasePanel )
        ApplyButton:Dock( BOTTOM )
        ApplyButton:DockMargin( 2,5,2,5 )
        ApplyButton:SetSize( 250, 30 )
        ApplyButton:SetTextColor(color_white)
        ApplyButton:SetText("Установить внешний вид")
        ApplyButton.DoClick = function()
        
            SetAppearance(AppearanceTable)  
            appearancemenu:Close()
            LocalPlayer():ChatPrint("Ваш внешний вид был установлен!")
            surface.PlaySound("eft_gear_sounds/gear_armor_use.wav")
        end
        
        
        function ApplyButton:Paint( w, h )
            self.a = Lerp(0.1,self.a or 100,self:IsHovered() and 255 or 150)
            draw.RoundedBox(0, 0, 0, w, h, Color(red.r,red.g,red.b,self.a))
            surface.SetDrawColor( color_black)
            surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
        end
        function ClothesStyle:Paint( w, h )
            self.a = Lerp(0.1,self.a or 100,self:IsHovered() and 255 or 150)
            draw.RoundedBox(0, 0, 0, w, h, Color(red.r,red.g,red.b,self.a))
            surface.SetDrawColor( color_black)
            surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
        end

        function menuappearance:OnClose()
            open = false
        end
    else
        if IsValid(appearancemenu) then
            appearancemenu:Close()
        end
    end
end

concommand.Add("hg_appearance_menu",function()
    OpenAppMenu()
end)

end