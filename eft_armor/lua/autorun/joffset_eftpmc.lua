JMod = JMod or {}
JMod.LuaConfig = JMod.LuaConfig or {}
JMod.LuaConfig.ArmorOffsets = JMod.LuaConfig.ArmorOffsets or {}

local size_bdy =  Vector(0.95,0.95,0.95)
local pos_bdy =   Vector(-4,-3.15,0)
local ang_bdy =   Angle(-80,0,90)

local size_head = Vector(0.95,0.95,0.95)
local pos_head =  Vector(0.35,1.75,0)
local ang_head =  Angle(-75,0,-90)

local size_eye =  Vector(0.95,0.95,0.95)
local pos_eye =   Vector(0.35,1.75,0)
local ang_eye =   Angle(-75,0,-90)

local size_arms = Vector(0.95,0.95,0.95)

local pos_rarm =  Vector(-0.5,6.7,-0.2)
local ang_rarm =  Angle(180,90,25)

local pos_larm =  Vector(-0.5,6.7,0.2)
local ang_larm =  Angle(0,-90,-25)

local size_armband = Vector(1.02,1.02,1.02)

local pos_rarmband =  Vector(0,6.7,0.8)
local ang_rarmband =  Angle(180,90,5)

local pos_larmband =  Vector(-0.4,6,0)
local ang_larmband =  Angle(0,-92,-5)

local armotable = {
--[[
            _          
           (_)         
  _ __ ___  _ ___  ___ 
 | '_ ` _ \| / __|/ __|
 | | | | | | \__ \ (__ 
 |_| |_| |_|_|___/\___|
]]--
        ["White Catphones"] = {
            siz = Vector(1, 1, 1),
            pos = Vector(.75, -.5, 0),
            ang = Angle(-80, 0, -90),
        },
        ["Black Catphones"] = {
            siz = Vector(1, 1, 1),
            pos = Vector(.75, -.5, 0),
            ang = Angle(-80, 0, -90),
        },
        ["SC Alpha"] = {
            siz = Vector(0.6, 0.6, 0.6),
            pos = Vector(4, -5, -4),
            ang = Angle(-100, 230, 90),
        },
        ["SC Beta"] = {
            siz = Vector(0.6, 0.6, 0.6),
            pos = Vector(4, -5, -4),
            ang = Angle(100, 40, 90),
        },
        ["SC Epsilon"] = {
            siz = Vector(0.65, 0.65, 0.65),
            pos = Vector(4, -5, -4),
            ang = Angle(-100, 230, 90),
        },
        ["SC Gamma"] = {
            siz = Vector(0.8, 0.8, 0.8),
            pos = Vector(4, -5, -4),
            ang = Angle(100, 40, 90),
        },
        ["SC Kappa"] = {
            siz = Vector(1, 1, 1),
            pos = Vector(4, -5, -4),
            ang = Angle(-100, 230, 90),         
        },

        ["Armband [C]"] = {
            siz = size_armband,
            pos = pos_larmband,
            ang = ang_larmband,  
        },
--[[
   __ _ _ __ _ __ ___   ___  _ __ 
  / _` | '__| '_ ` _ \ / _ \| '__|
 | (_| | |  | | | | | | (_) | |   
  \__,_|_|  |_| |_| |_|\___/|_|    
]]--
    ["Module 3M"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["PACA"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["6B2"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Untar Vest"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Kora-Kulon"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Kora-Kulon DFL"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Zhuk3 Press"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["6B23"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Kirasa-N"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Trooper TFO"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["NFM THOR CRV"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["6B13"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["6B13 Flora"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["6B232"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["OTV"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["HPC"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Korund"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Redut-M"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Redut-M Neck"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Redut-M Pelvis"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["6B13 M"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Gzhel-K"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Defender-2"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["IOTV Gen4 Vest"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["IOTV Gen4 Pelvis"] = {-- csgo misc
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["IOTV Gen4 Left Shoulder"] = {-- csgo hydra
        siz = size_arms,
        pos = pos_larm,
        ang = ang_larm,
    },
    ["IOTV Gen4 RightShoulder"] = {-- csgo hydra
        siz = size_arms,
        pos = pos_rarm,
        ang = ang_rarm,
    },
    ["Redut-T5 Vest"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Redut-T5 Neck"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Redut-T5 Pelvis"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Redut-T5 L. Brassard"] = {-- csgo hydra
        siz = size_arms,
        pos = pos_larm,
        ang = ang_larm,
    },
    ["Redut-T5 R. Brassard"] = {-- csgo hydra
        siz = size_arms,
        pos = pos_rarm,
        ang = ang_rarm,
    },
    ["Hexgrid"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Slick Black"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
        ["Slick Tan"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Slick Olive"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["BNTI Zhuk-6a"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["THOR IC Vest"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["THOR IC Pelvis"] = {-- csgo misc
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["THOR IC Neck"] = {-- csgo misc
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["NFM THOR IC Left Shoulder"] = {-- csgo hydra
        siz = size_arms,
        pos = pos_larm,
        ang = ang_larm,
    },
    ["NFM THOR IC Right Shoulder"] = {-- csgo hydra
        siz = size_arms,
        pos = pos_rarm,
        ang = ang_rarm,
    },
    ["6B43 Vest"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["6B43 Pelvis"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["6B43 Neck"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["6B43 Left Shoulder"] = {
        siz = size_arms,
        pos = pos_larm,
        ang = ang_larm,
    },
    ["6B43 RightShoulder"] = {
        siz = size_arms,
        pos = pos_rarm,
        ang = ang_rarm,
    },
--[[
                                          _        _               _        _           
                                         | |      | |             | |      (_)          
   __ _ _ __ _ __ ___   ___  _ __ ___  __| |   ___| |__   ___  ___| |_ _ __ _  __ _ ___ 
  / _` | '__| '_ ` _ \ / _ \| '__/ _ \/ _` |  / __| '_ \ / _ \/ __| __| '__| |/ _` / __|
 | (_| | |  | | | | | | (_) | | |  __/ (_| | | (__| | | |  __/\__ \ |_| |  | | (_| \__ \
  \__,_|_|  |_| |_| |_|\___/|_|  \___|\__,_|  \___|_| |_|\___||___/\__|_|  |_|\__, |___/
                                                                               __/ |    
                                                                              |___/     
]]--
    ["6B516"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["TV115"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["EAI MBSS"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Eagle Industries MMAC"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Banshee"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Ars Arma A18"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["TV110"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Strandhogg"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["RBAV-AF"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Osprey MK4A A"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["MK4A Neck"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["MK4A L.SH.Guard"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["MK4A R.SH.Guard"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["MK4A A L.Brassard"] = {
        siz = size_arms,
        pos = pos_larm,
        ang = ang_larm,
    },
    ["MK4A A R.Brassard"] = {
        siz = size_arms,
        pos = pos_rarm,
        ang = ang_rarm,
    },
    ["6B3TM"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },   
    ["6B515"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["M2"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["M1"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Crye Precision AVS"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["TacTec"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["AACPC"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["CPC GE"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["PlateFrame GE"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Osprey MK4A P"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["MK4A P L.Brassard"] = {
        siz = size_arms,
        pos = pos_larm,
        ang = ang_larm,
    },
    ["MK4A P R.Brassard"] = {
        siz = size_arms,
        pos = pos_rarm,
        ang = ang_rarm,
    },
    ["Bagariy"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["TT SK"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["MBAV Tagilla"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
--[[
  _                _                     _        
 | |              | |                   | |       
 | |__   __ _  ___| | ___ __   __ _  ___| | _____ 
 | '_ \ / _` |/ __| |/ / '_ \ / _` |/ __| |/ / __|
 | |_) | (_| | (__|   <| |_) | (_| | (__|   <\__ \
 |_.__/ \__,_|\___|_|\_\ .__/ \__,_|\___|_|\_\___/
                       | |                        
                       |_|                        
]]--
    ["6Sh118"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["LBT-2670 SFMP"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Blackjack"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["F4 Terminator"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["SSO Attack 2"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["TT Trooper 35"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Pilgrim"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Paratus 3-Day"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Gunslinger"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Mechanism"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Beta 2 Battle BP"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Gruppa 99 T30 (B)"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Gruppa 99 T30 (M)"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["F5 Switchblade"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Tri-Zip"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["LBT-1476A"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Gruppa 99 T20 (T)"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Gruppa 99 T20 (M)"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Drawbridge"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Takedown Black"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Takedown Multicam"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Pillbox"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Scav Backpack"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Berkut BP"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["LBT-8005A Day Pack"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Sanitar's Bag"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Flyye MBSS"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["NICE COMM 3 BVS"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Duffle Bag"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["LolKek 3F"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Tactical Sling Bag"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["VKBO Army Bag"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Transformer Bag"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["RK-PT-25"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Dragon Egg MkII"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["SATL"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
--[[
       _               _          _           
      | |             | |        (_)          
   ___| |__   ___  ___| |_   _ __ _  __ _ ___ 
  / __| '_ \ / _ \/ __| __| | '__| |/ _` / __|
 | (__| | | |  __/\__ \ |_  | |  | | (_| \__ \
  \___|_| |_|\___||___/\__| |_|  |_|\__, |___/
                                     __/ |    
                                    |___/     
]]--
    ["Scav Vest"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Security Vest"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["M4 RSCR"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["DIY IDEA CR"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Bank Robber"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["MRig"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Chicom"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["TV-109"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["CSA"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["UMTBS 6sh112"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Khamelion"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Tarzan"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["D3CRX"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Triton"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Commando Black"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Commando Tan"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Thunderbolt"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["BSS-MK1"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Umka"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["LBT-1961A"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["LBCR GE"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["SProfi MK2 R"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["SProfi MK2 A"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["BlackRock"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["MK3 Chest Rig"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Alpha CR"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Azimut B"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["Azimut S"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["MPPV"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
    ["BeltAB"] = {
        siz = size_bdy,
        pos = pos_bdy,
        bon = "ValveBiped.Bip01_Spine4",
        ang = ang_bdy,
    },
--[[
  _                    _          _       
 | |                  | |        | |      
 | |__   ___  __ _  __| |___  ___| |_ ___ 
 | '_ \ / _ \/ _` |/ _` / __|/ _ \ __/ __|
 | | | |  __/ (_| | (_| \__ \  __/ |_\__ \
 |_| |_|\___|\__,_|\__,_|___/\___|\__|___/
]]--
    ["GSSh-01"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Sordin"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["M32"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head, 
    },
    ["ComTac"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head, 
    },
    ["Tactical Sport"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Razor"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["XCEL"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["ComTac 4"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head, 
    },
--[[
   ___ _   _  _____      _____  __ _ _ __ 
  / _ \ | | |/ _ \ \ /\ / / _ \/ _` | '__|
 |  __/ |_| |  __/\ V  V /  __/ (_| | |   
  \___|\__, |\___| \_/\_/ \___|\__,_|_|   
        __/ |                             
       |___/                              
]]--
    ["Tactical Glasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["AF Glasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["6B34"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["Dundukk sunglasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["M Frame Glasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["Pyramex Proximity"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["Gascan Glasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["Round Sunglasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["RayBench Glasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["Aviator Glasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["JohnB Glasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["Crossbow Glasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["Gas Welder Glasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["Batwolf Glasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
    ["Condor Glasses"] = {
        siz = size_eye,
        pos = pos_eye,
        ang = ang_eye,
    },
--[[
  _ ____   ____ _ ___ 
 | '_ \ \ / / _` / __|
 | | | \ V / (_| \__ \
 |_| |_|\_/ \__, |___/
             __/ |    
            |___/     
]]--
    ["PVS-14 NVM"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,     
    },
    ["PNV-10T NVG"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["N-15 NVG"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["GPNVG-18"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["T-7 Thermal Goggles"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Skull Lock"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
--[[
  _           _       
 | |         | |      
 | |__   __ _| |_ ___ 
 | '_ \ / _` | __/ __|
 | | | | (_| | |_\__ \
 |_| |_|\__,_|\__|___/
]]--
    ["Bomber"] = { --IDK IF I SHOULD PUT THIS IN HELMETS OR HATS 
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["LLCS"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Chimera"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Cowboy"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Ushanka"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Panama"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Door Kicker"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Beanie"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Kotton"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Army Cap"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Army Cap Black"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Army Cap Brown"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Army Cap CADPAT"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Army Cap Flora"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Army Cap Sand"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Army Cap UCP"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Baseball cap"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Santa hat"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },   
    ["Ded Moroz hat"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Police"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Fleece"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["UX PRO"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["USEC cap black"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["USEC cap tan"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["BEAR cap black"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["BEAR cap green"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["EMERCOM"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Pompon"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Bandana"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Ski Hat"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Beret Olive"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Beret Blue"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Beret Black"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Leather cap"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Tagilla Cap"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Big Pipe's Bandana"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Zryachiy Mask"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Gus Baseball Cap"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Basmach Leather Cap"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
--[[
   __                                       
  / _|                                      
 | |_ __ _  ___ ___  ___ _____   _____ _ __ 
 |  _/ _` |/ __/ _ \/ __/ _ \ \ / / _ \ '__|
 | || (_| | (_|  __/ (_| (_) \ V /  __/ |   
 |_| \__,_|\___\___|\___\___/ \_/ \___|_|   
]]--
    ["Glorious"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Shattered"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Death Knight"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["UBEY"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["GORILLA"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Hockey Captain"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Hockey Brawler"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Hockey Quiet"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["GP-5"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["GP-7"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Deadly Skull"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Respirator 3M"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["SOTR"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Pestily"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Spooky Skull Mask"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Slender"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Misha Mayorov"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Ghoul"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Faceless"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Jason"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Balaclava"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Balaclava (Black)"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Cold Fear"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Ghost Balaclava"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Ghost Half-Mask"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Nomex Balaclava"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Smoke Balaclava"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Shemagh (Green)"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Shemagh (Tan)"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Lower Half-Mask"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    }, 
    ["Neoprene Mask"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Mustache"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Santa"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Baddie"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Pipe"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Zryachiy's Balaclava"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Death Shadow"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["CQCM"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
--[[
  _          _                _       
 | |        | |              | |      
 | |__   ___| |_ __ ___   ___| |_ ___ 
 | '_ \ / _ \ | '_ ` _ \ / _ \ __/ __|
 | | | |  __/ | | | | | |  __/ |_\__ \
 |_| |_|\___|_|_| |_| |_|\___|\__|___/
 ]]--
    ["Tac-Kek FAST MT"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["TSh-4M-L"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Kolpak-1S"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["SHPM Firefighter Helmet"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["PSh-97 DJETA"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["LShZ"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["SSh-68"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Galvion Caiman"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Galvion Caiman Applique"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["HJELM"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Untar Helmet"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["6B47"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["6B47 Cover"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["KiverM"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["SFERA-S"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["DevTac Ronin"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["MSA ACH TC-2001"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["MSA ACH TC-2002"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["ACHHC Black"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["ACHHC Olive"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["TC 800"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Bastion"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Bastion Shield"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Fast MT Black"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Fast MT Black SLAAP"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Fast MT Tan"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Fast MT Tan SLAAP"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["TW EXFIL B"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["TW EXFIL C"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["ZSH-1-2M"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["ZSH-1-2M v2"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["ULACH B"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["ULACH C"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["LShZ-2DTM"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["LShZ-2DTM Cover"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Shlem Maska 1SH"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Shlem Maska 1SH (Killa)"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Altyn"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Rys-T"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Vulkan-5"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["NeoSteel"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Tor2"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
--[[
                     _                    
                    (_)                   
   __ _  ___  __   ___ ___  ___  _ __ ___ 
  / _` |/ __| \ \ / / / __|/ _ \| '__/ __|
 | (_| | (__   \ V /| \__ \ (_) | |  \__ \
  \__, |\___|   \_/ |_|___/\___/|_|  |___/
   __/ |                                  
  |___/                                   
]]--
    ["FAST Visor"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Caiman FA Visor"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Kolpak-1S Visor"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Tac-Kek Heavy Trooper"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Fast MT Shield"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Kiver Shield"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["TW EXFIL Shield B"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["TW EXFIL Shield C"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["LShZ-2DTM Shield"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Vulkan-5 Shield"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Altyn Face Shield"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Rys-T Face Shield"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Shmaska 1SH Shield"] = {-- csgo misc
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Shmaska 1SH Shield (Killa)"] = {-- csgo misc
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Tor-2 Shield"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
--[[
   __ _  ___    __ _ _ __ _ __ ___   ___  _ __ ___ 
  / _` |/ __|  / _` | '__| '_ ` _ \ / _ \| '__/ __|
 | (_| | (__  | (_| | |  | | | | | | (_) | |  \__ \
  \__, |\___|  \__,_|_|  |_| |_| |_|\___/|_|  |___/
   __/ |                                           
  |___/                                            
]]--
    ["Fast Mandible"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Caiman Mandible"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Fast Side Armor Black"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Fast Side Armor Tan"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Crye AirFrame Ears"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["TW EXFIL Ears B"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["TW EXFIL Ears C"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["Crye AirFrame Chops"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["LShZ-2DTM Aventail"] = {-- tarkov
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
    ["NeoSteel Mandible"] = {
        siz = size_head,
        pos = pos_head,
        ang = ang_head,
    },
}


JMod.LuaConfig.ArmorOffsets["models/eft/pmcs/bear_extended_pm.mdl"] = armotable
JMod.LuaConfig.ArmorOffsets["models/eft/pmcs/usec_extended_pm.mdl"] = armotable
JMod.LuaConfig.ArmorOffsets["models/eft/scavs/scav_extended_pm.mdl"] = armotable
--[[
JMod.LuaConfig.ArmorOffsets["models/eft/pm_gear/pm/bear_pm_armor.mdl"] = armotable
JMod.LuaConfig.ArmorOffsets["models/eft/pm_gear/pm/bear_pm_body.mdl"] = armotable
JMod.LuaConfig.ArmorOffsets["models/eft/pm_gear/pm/bear_pm_chestrig.mdl"] = armotable

JMod.LuaConfig.ArmorOffsets["models/eft/pm_gear/pm/usec_pm_armor.mdl"] = armotable
JMod.LuaConfig.ArmorOffsets["models/eft/pm_gear/pm/usec_pm_body.mdl"] = armotable
JMod.LuaConfig.ArmorOffsets["models/eft/pm_gear/pm/usec_pm_chestrig.mdl"] = armotable

JMod.LuaConfig.ArmorOffsets["models/eft/pm_gear/pm/scav_pm_armor.mdl"] = armotable
JMod.LuaConfig.ArmorOffsets["models/eft/pm_gear/pm/scav_pm_body.mdl"] = armotable
JMod.LuaConfig.ArmorOffsets["models/eft/pm_gear/pm/scav_pm_body.mdl"] = armotable
]]--