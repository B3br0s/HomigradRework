local Page = {}
SettingsPages[3] = Page
Page.Name = "Звуки"

function Page.Open(panel)
    local cat = panel:AddCategory(L("settings_main"))

    if not sound.CanUseDSP() then
        cat:AddText("DSP Sound change","Нужен BRANCH x86-64")
        cat:AddText("DSP Sound","Нужен BRANCH x86-64")
    else
        cat:AddSwitch("DSP Sound change","hg_sound_dsp_change")
        cat:AddSwitch("DSP Sound","hg_sound_dsp")
    end

    cat:AddSlider(L("settings_volume_shootgun"),"hg_volume_shoot",nil,nil,100)
    
    local cat = panel:AddCategory("Dynamic Weapon Reverb")
    cat:AddSwitch(L("settings_dwr"),"cl_dwr_disable_reverb",true)
    cat:AddSlider(L("settings_dwr_volume"),"cl_dwr_volume",nil,nil,100)
    //cat:AddSlider("Количество лучей","cl_dwr_occlusion_rays",nil,nil,1)
    //cat:AddSlider("Количество отражающих лучей","cl_dwr_occlusion_rays_reflections",nil,nil,1)
end