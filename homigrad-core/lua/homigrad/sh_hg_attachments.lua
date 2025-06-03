hg.Attachments = {
    ["holo1"] = {
        Name = "Barska",
        Model = "models/weapons/arccw_go/atts/barska.mdl",
        WorldPos = Vector(0,0,0),
        WorldAng = Angle(0,0,0),
        CorrectSize = 1,
        Placement = "sight",
        ViewPos = Vector(0,0,0.15),

        MountType = "picatinny",

        IsHolo = true,
        Reticle = "vgui/arc9_eft_shared/reticles/new/scope_all_aimpoint_micro_h1_high_marks.png",
        ReticleSize = 12,
        ReticleUp = 0,
        ReticleRight = 0
    },
    ["holo2"] = {
        Name = "Kobra",
        Model = "models/weapons/arccw_go/atts/kobra.mdl",
        WorldPos = Vector(0,0,0),
        WorldAng = Angle(0,0,0),
        CorrectSize = 1,
        Placement = "sight",
        ViewPos = Vector(0,0,-0.1),

        MountType = "picatinny",

        IsHolo = true,
        Reticle = "vgui/arc9_eft_shared/reticles/new/scope_all_vomz_pilad_p1x42_mark_mode_001",
        ReticleSize = 9,
        ReticleUp = 1.45,
        ReticleRight = 0
    },
    ["holo3"] = {
        Name = "Eotech553",
        Model = "models/weapons/arc9_eft_shared/atts/optic/eft_optic_553.mdl",
        WorldPos = Vector(0,0,0),
        WorldAng = Angle(0,0,0),
        CorrectSize = 0.65,
        Placement = "sight",
        ViewPos = Vector(0,0,0),

        MountType = "picatinny",

        IsHolo = true,
        Reticle = "vgui/arc9_eft_shared/reticles/new/scope_all_eotech_xps3-4_marks.png",
        ReticleSize = 11,
        ReticleUp = 0,
        ReticleRight = 0
    },
    ["optic1"] = {
        Name = "SIG Bravo-4",
        Model = "models/weapons/arc9/darsu_eft/mods/scope_sig_bravo4.mdl",
        WorldPos = Vector(0,0,0),
        WorldAng = Angle(0,0,0),
        CorrectSize = 0.7,
        Placement = "sight",

        ScopePos = Vector(3,0,0.83),
        ScopeAng = Angle(0,0,0),
        ViewPos = Vector(0,0,-0.25),

        IsOptic = true,
        Fov = 9,
        MaxFov = 3,
        MinFov = 9,
        Reticle = "vgui/arc9_eft_shared/reticles/scope_all_ncstar_advance_dual_optic_3_9x_42_mark.png",
        ReticleSize = 1,
        Mat = "effects/arc9/rt",

        BlackMat = "decals/scope.png",
        BlackSize = 2070,
        BlackScope = 400,

        MountType = "picatinny",

        Rotation = 0
    },
    ["optic2"] = {
        Name = "ELCAN SpecterDR",
        Model = "models/weapons/arc9/darsu_eft/mods/scope_elcan_specter.mdl",
        WorldPos = Vector(0,0,0),
        WorldAng = Angle(0,0,0),
        CorrectSize = 0.7,
        Placement = "sight",

        ScopePos = Vector(3,0,0.99),
        ScopeAng = Angle(0,0,0),
        ViewPos = Vector(0,0,-0.1),

        IsOptic = true,
        Fov = 20,
        MaxFov = 5,
        MinFov = 20,
        Reticle = "vgui/arc9_eft_shared/reticles/scope_34mm_s&b_pm_ii_3_12x50_lod0_mark_12.png",
        ReticleSize = 0.6,
        Mat = "effects/arc9/rt",

        BlackMat = "decals/scope.png",
        BlackSize = 2070,
        BlackScope = 400,

        MountType = "picatinny",

        Rotation = 0
    },
    ["grip1"] = {
        Name = "Ergo Grip",
        Model = "models/weapons/arccw_go/atts/foregrip_ergo.mdl",
        WorldPos = Vector(0,0,0),
        WorldAng = Angle(0,0,0),
        CorrectSize = 1,
        Placement = "grip",

        LHandAng = Angle(30,-140,90),
        LHand = Vector(1.2,3,-3),

        DrawFunction = function(self) 
            if !IsValid(self:GetOwner()) then
                return
            end
            //hg.bone.Set(self:GetOwner(),"r_finger0",Vector(0,0,0),Angle(0,0,0),1,0.1)
            //hg.bone.Set(self:GetOwner(),"r_finger1",Vector(0,0,0),Angle(0,0,0),1,0.1)
        end
    },
    ["supp1"] = {
        Name = "SilencerCo Hybrid",
        Model = "models/weapons/arc9_eft_shared/atts/muzzle/silencer_mount_silencerco_hybrid_46_multi.mdl",
        WorldPos = Vector(0,0,0),
        WorldAng = Angle(0,0,0),
        CorrectSize = 1,
        Placement = "barrel",
        IsSupp = true
    },
    ["supp2"] = {
        Name = "AWC Thor PSR",
        Model = "models/weapons/arc9/darsu_eft/mods/silencer_base_awc_thor_psr_xl_multi.mdl",
        WorldPos = Vector(0,0,0),
        WorldAng = Angle(0,0,0),
        CorrectSize = 1,
        Placement = "barrel",
        IsSupp = true
    },
}

if SERVER then
    function hg.force_attachment(self,att_name)
        local att = hg.Attachments[att_name]
        if !self.Attachments then
            self.Attachments = {}
        end
        self.Attachments[att.Placement][1] = att_name

        timer.Simple(0,function()
            net.Start("att sync")
            net.WriteTable(self.Attachments)
            net.WriteEntity(self)
            net.Broadcast()
        end)
    end
end