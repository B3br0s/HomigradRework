hg = hg or {}

ROUND_LIST = ROUND_LIST or {}
ROUND_ACTIVE = ROUND_ACTIVE or false
ROUND_NEXT = ROUND_NEXT or nil
ROUND_NAME = ROUND_NAME or "hunter"
ROUND_ENDED = ROUND_ENDED or false
ROUND_ENDSIN = ROUND_ENDSIN or 0

function TableRound(name) return _G[name or ROUND_NAME] end

CurrentRound = TableRound