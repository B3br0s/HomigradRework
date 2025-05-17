table.insert(ROUND_LIST,"event")

event = event or {}

event.name = "Event"
event.TeamBased = false
event.CantRandom = true

event.Teams = {
    [1] = {Name = "event_maker",
           Color = Color(87,87,255),
           Desc = "event_maker_desc"
        },
    [2] = {Name = "event_player",
       Color = Color(223,0,0),
       Desc = "event_player_desc"
    },
}