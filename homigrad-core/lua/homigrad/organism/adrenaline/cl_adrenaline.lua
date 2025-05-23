local is_bright = (ConVarExists("hg_adrenaline_bright") and GetConVar("hg_adrenaline_bright") or CreateClientConVar("hg_adrenaline_bright","1",true,false,"disable shit flashbang",0,1))

hook.Add( "EffectRender", "Adrenaline_FX", function()

    local ply = LocalPlayer()

    if !ply:Alive() then
        return
    end

    local adr = ply:GetNWFloat("adrenaline")

    DrawSharpen(adr,1)

    if is_bright:GetBool() then
        DrawBloom(0, adr * 0.25, 0, 0, 2, 4, 1, 1, 1) //готово нахуй
    end

    // чет еще надо сделать?
    //оружия поделай пока что (ганпак расширь)
    //ок
    // модели брать из нашего контента? -- iz sharika tozhe mozhno (cs:go) понял
    
end )