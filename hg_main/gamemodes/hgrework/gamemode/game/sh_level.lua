ROUND_STATE_WAITING = 1
ROUND_STATE_ACTIVE = 2
ROUND_STATE_ENDING = 3
ROUND_ACTIVE = ROUND_ACTIVE or false
ROUND_ENDED = ROUND_ENDED or false
ROUND_STATE = ROUND_STATE or ROUND_STATE_WAITING
ROUND_NAME = ROUND_NAME or nil
ROUND_LIST = ROUND_LIST or {}

function TableRound(name) return _G[name or ROUND_NAME] end

timer.Simple(0,function()
    if ROUND_NAME == nil then
        ROUND_NAME = "homicide"
        StartRound()
    end
end)