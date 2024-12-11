local ENT,CLASS = oop.Reg("base_nextbot","lib_event")
if not ENT then return end

CLASS.NonRegisterGMOD = true

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"

ENT:Event_Add("zombieinfection","register",function(class)
    local content = class[1]
    if content.NonRegisterGMOD or class.NonRegisterGMOD then return end

    scripted_ents.Register(content,content.ClassName)
end)

