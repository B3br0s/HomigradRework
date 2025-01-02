if engine.ActiveGamemode() == "homigradcom" then
hg = hg or {}

include("homigrad_scr/loader.lua")
include("homigrad_scr/run.lua")

if SERVER then
    resource.AddWorkshop("3004847067")
end
end