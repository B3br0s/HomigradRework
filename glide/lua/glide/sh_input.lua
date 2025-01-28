--[[
    Categorize and enumerate input actions.

    Each category contains a key-value pairs of
    action names and the default key that triggers them.
]]

local InputCategories = Glide.InputCategories or {}

Glide.InputCategories = InputCategories

-- Inputs that apply to all vehicle types
InputCategories["general_controls"] = {
    ["switch_weapon"] = KEY_R,
    ["toggle_engine"] = KEY_I
}

-- Inputs that only apply to land vehicle types
InputCategories["land_controls"] = {
    ["attack"] = MOUSE_LEFT,

    ["steer_left"] = KEY_A,
    ["steer_right"] = KEY_D,
    ["accelerate"] = KEY_W,
    ["brake"] = KEY_S,
    ["handbrake"] = KEY_SPACE,

    ["horn"] = KEY_R,
    ["siren"] = KEY_L,
    ["headlights"] = KEY_H,
    ["reduce_throttle"] = KEY_LSHIFT,

    ["lean_forward"] = KEY_UP,
    ["lean_back"] = KEY_DOWN,

    ["signal_left"] = KEY_LEFT,
    ["signal_right"] = KEY_RIGHT,

    ["shift_up"] = KEY_F,
    ["shift_down"] = KEY_G,
    ["shift_neutral"] = KEY_N
}

-- Inputs that only apply to aicraft vehicle types
InputCategories["aircraft_controls"] = {
    ["attack"] = MOUSE_LEFT,
    ["attack_alt"] = KEY_SPACE,

    ["free_look"] = KEY_LALT,
    ["landing_gear"] = KEY_G,
    ["countermeasures"] = KEY_F,

    ["pitch_up"] = KEY_DOWN,
    ["pitch_down"] = KEY_UP,
    ["yaw_left"] = KEY_A,
    ["yaw_right"] = KEY_D,
    ["roll_left"] = KEY_LEFT,
    ["roll_right"] = KEY_RIGHT,
    ["throttle_up"] = KEY_W,
    ["throttle_down"] = KEY_S
}

-- Allow some actions to trigger others
Glide.ACTION_ALIASES = {
    ["attack_alt"] = "attack"
}

-- Keys reserved for seat switching
Glide.SEAT_SWITCH_BUTTONS = {
    [KEY_1] = 1,
    [KEY_2] = 2,
    [KEY_3] = 3,
    [KEY_4] = 4,
    [KEY_5] = 5,
    [KEY_6] = 6,
    [KEY_7] = 7,
    [KEY_8] = 8,
    [KEY_9] = 9,
    [KEY_0] = 10
}
