--- Resets all input action values for a specific seat.
function ENT:ResetInputs( seatIndex )
    local bools = self.inputBools[seatIndex]

    if bools then
        for action, _ in pairs( bools ) do
            bools[action] = false
        end
    end

    local floats = self.inputFloats[seatIndex]

    if floats then
        for action, _ in pairs( floats ) do
            floats[action] = 0
        end
    end
end

--- Get the action's boolean value from a specific seat.
function ENT:GetInputBool( seatIndex, action )
    local bools = self.inputBools[seatIndex]
    if bools then return bools[action] end

    return false
end

do
    -- Translate these boolean actions to float values.
    local BOOL_TO_FLOAT = {
        ["accelerate"] = { "", "accelerate" },
        ["brake"] = { "", "brake" },
        ["steer"] = { "steer_left", "steer_right" },
        ["pitch"] = { "pitch_up", "pitch_down" },
        ["roll"] = { "roll_left", "roll_right" },
        ["yaw"] = { "yaw_left", "yaw_right" },
        ["throttle"] = { "throttle_down", "throttle_up" },
        ["lean_pitch"] = { "lean_back", "lean_forward" }
    }

    local Clamp = math.Clamp

    --- Get the action's float value from a specific seat.
    function ENT:GetInputFloat( seatIndex, action )
        local value = 0

        -- Try to get the float value directly
        local floats = self.inputFloats[seatIndex]
        if floats then
            value = floats[action] or 0
        end

        -- Try to convert the boolean actions to a float action
        local bools = self.inputBools[seatIndex]
        if bools then
            local indexes = BOOL_TO_FLOAT[action]
            value = value + ( bools[indexes[1]] and -1 or ( bools[indexes[2]] and 1 or 0 ) )
        end

        return Clamp( value, -1, 1 )
    end
end

function ENT:SetInputBool( seatIndex, action, pressed )
    local handled = self:OnSeatInput( seatIndex, action, pressed )
    if handled then return end

    local bools = self.inputBools[seatIndex]

    if bools then
        bools[action] = pressed
    end

    if not pressed then return end

    -- Weapon switching
    if action == "switch_weapon" then
        self:SelectWeaponIndex( self:GetWeaponIndex() + 1 )
    end
end

function ENT:SetInputFloat( seatIndex, action, value )
    local floats = self.inputFloats[seatIndex]

    if floats then
        floats[action] = value
    end
end
