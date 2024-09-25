local Page = {}
SettingsPages[1] = Page
Page.Name = "Игра"

function Page.Open(panel)
    local cat = panel:AddCategory(L("settings_camera"))
    cat:AddSlider("FOV","hg_fov",nil,nil,1)
    /*cat:AddSwitch("Плавная камера","hg_camera_smooth")
    cat:AddSwitch("Трясущееся камера","hg_camera_movement")*/
    cat:AddSwitch("Body Camera","hg_bodycam_enable")
    cat:AddSwitch("Body Camera Sound","hg_bodycam_dsp")
    local cat = panel:AddCategory("HUD")
    cat:AddSwitch("Chat History On HUD","hg_chat_visible")
    cat:AddSwitch("Spectate HUD","hg_show_hudspectate")
    cat:AddSwitch("Voice HUD","hg_show_voicehud")
    cat:AddSwitch(L("settings_playsound_startround"),"hg_sound_round",n)
    cat:AddSwitch("Streamer Mode","hg_streamer_mode")
end

cvars.CreateOption("hg_chat_visible","1")

local PLAYER = FindMetaTable("Player")

if not HNameStreamerMode then HNameStreamerMode = PLAYER.Name end

cvars.CreateOption("hg_streamer_mode","0",function(value)
    if tonumber(value) > 0 then
        PLAYER.Name = function(self) return tostring(self:UserID()) end
        PLAYER.Nick = PLAYER.Name

        StreamMode = true
    else
        PLAYER.Name = HNameStreamerMode
        PLAYER.Nick = PLAYER.Name

        StreamMode = false
    end
end)