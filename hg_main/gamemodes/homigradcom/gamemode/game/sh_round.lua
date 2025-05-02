hg = hg or {}

function TableRound(name) return _G[name or ROUND_NAME] end
    
    CurrentRound = TableRound

function UpdateShit()
    ROUND_LIST = ROUND_LIST or {}
    ROUND_ACTIVE = ROUND_ACTIVE or false
    ROUND_NEXT = ROUND_NEXT or nil
    ROUND_NAME = ROUND_NAME or "hunter"
    ROUND_ENDED = ROUND_ENDED or false
    ROUND_ENDSIN = ROUND_ENDSIN or 0
    
    hg.Points.box_spawn = hg.Points.box_spawn or {}
    hg.Points.box_spawn.Color = Color(150,0,0)
    hg.Points.box_spawn.Name = "box_spawn"
end

UpdateShit()

hook.Add("InitPostEntity","shit",function()
    UpdateShit()
end)