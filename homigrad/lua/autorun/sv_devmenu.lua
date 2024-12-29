
if CLIENT then
function OpenDevMenu()
    local window = vgui.Create( "DFrame" )
    window:SetSize( 500, 500 )
    window:Center()
    window:SetTitle("DEV-Меню")
    window:MakePopup()

    local checkbox = window:Add( "DCheckBox" )
    checkbox:SetPos( 25, 50 )
    checkbox:SetValue( true )

    local HP = vgui.Create( "DNumSlider", window )
    HP:SetPos( 25, 40 )
    HP:SetSize( 300, 100 )
    HP:SetText( "HP" )
    HP:SetMin( 0 )
    HP:SetMax( 1000 )
    HP:SetDecimals( 0 )
    HP:SetValue(LocalPlayer():Health())

    HP.OnValueChanged = function( self, value )
    net.Start("DEVMENU")
    net.WriteString("HP")
    net.WriteEntity(LocalPlayer())
    net.WriteFloat(value)
    net.SendToServer()
    end

    local adr = vgui.Create( "DNumSlider", window )
    adr:SetPos( 25, 120 )
    adr:SetSize( 300, 100 )
    adr:SetText( "Adrenaline" )
    adr:SetMin( 0 )
    adr:SetMax( 9 )
    adr:SetDecimals( 5 )
    adr:SetValue(tonumber(LocalPlayer():GetNWFloat("Adrenaline")))

    adr.OnValueChanged = function( self, value )
    net.Start("DEVMENU")
    net.WriteString("ADR")
    net.WriteEntity(LocalPlayer())
    net.WriteFloat(value)
    net.SendToServer()
    end

    local blood = vgui.Create( "DNumSlider", window )
    blood:SetPos( 25, 200 )
    blood:SetSize( 300, 100 )
    blood:SetText( "Blood" )
    blood:SetMin( 0 )
    blood:SetMax( 20 )
    blood:SetDecimals( 0 )
    blood:SetValue(tonumber(LocalPlayer():GetNWFloat("Blood") / 1000))

    blood.OnValueChanged = function( self, value )
    net.Start("DEVMENU")
    net.WriteString("BLOOD")
    net.WriteEntity(LocalPlayer())
    net.WriteFloat(value * 1000)
    net.SendToServer()
    end
end
concommand.Add("hg_devmenu",function (ply)
    if ply:SteamID() != "STEAM_0:1:526713154" then ply:ChatPrint("Пошел нахуй") print("А не пошел бы ты нахуй??") return end
    OpenDevMenu()
end)

else

util.AddNetworkString("DEVMENU")

net.Receive("DEVMENU",function (len,ply)
    if ply:SteamID() != "STEAM_0:1:526713154" then ply.ISEXPLOITERHAHA = true return end
    local type = net.ReadString()

    local amt = net.ReadFloat()

    if type == "HP" then
        ply:SetHealth(amt)
    elseif type == "ADR" then
        ply.adrenaline = amt
    elseif type == "BLOOD" then
        ply.Blood = amt
    end

end)
end