
local PANEL = {}

surface.CreateFont( 'SolidMapVote.Title', { font = 'Roboto', size = ScreenScale( 20 ), weight = 1000 } )
surface.CreateFont( 'SolidMapVote.Time', { font = 'Roboto', size = ScreenScale( 7 ), weight = 1, italic = true } )
surface.CreateFont( 'SolidMapVote.SubTitle', { font = 'Roboto', size = ScreenScale( 9 ), weight = 1000, italic = true } )

function PANEL:Init()
    self.maps = {}
    self.mapButtons = {}
    self.startTime = RealTime()
    self.endTime = self.startTime + SolidMapVote[ 'Config' ][ 'Length' ]
    self.layoutPaused = false
    self.finished = false
    self.subTitleText = ''

    self:SetPos( 0, 0 )
    self:SetSize( ScrW(), ScrH() )

    if SolidMapVote[ 'Config' ][ 'Enable Extend' ] then
        self.extend = vgui.Create( 'SolidMapVoteButton', self )
        self.extend:SetLabel( 'extend' )
        self.extend:SetImage( SolidMapVote[ 'Config' ][ 'Extend Image' ] )
    end

    if SolidMapVote[ 'Config' ][ 'Enable Random' ] then
        self.random = vgui.Create( 'SolidMapVoteButton', self )
        self.random:SetLabel( 'random' )
        self.random:SetImage( SolidMapVote[ 'Config' ][ 'Random Image' ] )
    end

    hook.Add( 'SolidMapVote.WinningMaps', 'SolidMapVote.WinningMaps.main', function( winningMaps, realWinner, fixedWinner )
        self.finished = true

        local realDisplayName = string.upper( SolidMapVote.GetMapConfigInfo( realWinner ).displayname )
        local fixedDisplayName = string.upper( SolidMapVote.GetMapConfigInfo( fixedWinner ).displayname )

        if #winningMaps > 1 then
            if realWinner == 'extend' then
                self.subTitleText = 'MAP HAS BEEN EXTENDED AS TIE BREAKER!'
            elseif realWinner == 'random' then
                self.subTitleText = fixedDisplayName .. ' HAS BEEN CHOSEN RANDOMLY AS TIE BREAKER!'
            else
                self.subTitleText = realDisplayName .. ' HAS BEEN CHOSEN AS TIE BREAKER!'
            end
        elseif realWinner == 'extend' then
            self.subTitleText = 'MAP HAS BEEN EXTENDED!'
        elseif realWinner == 'random' then
            self.subTitleText = fixedDisplayName .. ' WAS RANDOMLY CHOSEN!'
        else
            self.subTitleText = 'WINNING MAP IS ' .. realDisplayName .. '!'
        end
    end )
end

function PANEL:SetMaps( maps )
    self.maps = maps

    self:CreateMapButtons()
end

function PANEL:CreateMapButtons()
    for k, map in pairs( self.maps ) do
        local btn = vgui.Create( 'SolidMapVoteMap', self )
        btn:SetMap( map )

        table.insert( self.mapButtons, btn )
    end
end

function PANEL:PauseLayout( bool )
    self.layoutPaused = bool
end

function PANEL:PerformLayout(w, h)
    if self.layoutPaused then return end -- Pause the layout when buttons are animating

    local buttonWidth = w * 0.12
    local buttonHeight = SolidMapVote['Config']['Map Button Size'] == 1 and h * 0.6 or buttonWidth
    local spacing = 20
    local buttonsPerRow = math.floor((w * 0.8) / (buttonWidth + spacing)) -- Calculate how many buttons fit in a row

    -- Center the grid horizontally
    local startX = (w - (buttonsPerRow * (buttonWidth + spacing)) + spacing) * 0.5
    local startY = h * 0.2 -- Starting Y position a little below the top

    local currentRow = 0
    local currentColumn = 0

    -- Position map buttons
    for k, btn in ipairs(self.mapButtons) do
        btn:SetSize(buttonWidth, buttonHeight)

        -- Calculate position for this button in the grid
        local posX = startX + currentColumn * (buttonWidth + spacing)
        local posY = startY + currentRow * (buttonHeight + spacing)
        btn:SetPos(posX, posY)

        -- Move to the next column
        currentColumn = currentColumn + 1

        -- If we've reached the maximum number of buttons per row, move to the next row
        if currentColumn >= buttonsPerRow then
            currentColumn = 0
            currentRow = currentRow + 1
        end

        -- Store original size and position for animations
        local x, y = btn:GetPos()
        btn:SetOriginalSize(buttonWidth, buttonHeight)
        btn:SetOriginalPos(x, y)
    end

    -- Bottom button (RANDOM and EXTEND) size and positioning
    local buttonSize = SolidMapVote['Config']['Map Button Size'] == 1 and buttonHeight * 0.1 or buttonHeight * 0.3
    local bottomButtonYPos = h - (buttonSize + 40) -- Fixed position at the bottom

    -- Place the EXTEND button
    if SolidMapVote['Config']['Enable Extend'] then
        local extendButtonXPos = w - (buttonWidth + 220) -- Align right with 40px padding
        self.extend:SetSize(buttonWidth, buttonSize)
        self.extend:SetPos(extendButtonXPos, bottomButtonYPos)

        -- Store original size and position for animations
        self.extend:SetOriginalSize(buttonWidth, buttonSize)
        self.extend:SetOriginalPos(extendButtonXPos, bottomButtonYPos)
    end

    -- Place the RANDOM button
    if SolidMapVote['Config']['Enable Random'] then
        local randomButtonXPos = w - (2 * buttonWidth + 246) -- Place left of the EXTEND button with 20px spacing
        self.random:SetSize(buttonWidth, buttonSize)
        self.random:SetPos(randomButtonXPos, bottomButtonYPos)

        -- Store original size and position for animations
        self.random:SetOriginalSize(buttonWidth, buttonSize)
        self.random:SetOriginalPos(randomButtonXPos, bottomButtonYPos)
    end
end


function PANEL:Paint(w, h)
    local timeRemainingDelta = (self.endTime - RealTime()) / SolidMapVote['Config']['Length'] / 1.2
    local timeRemainingFormatted = string.FormattedTime(math.max(math.Round(self.endTime - RealTime(), 2), 0), '%02i:%02i:%02i')

    local startY = SolidMapVote['Config']['Map Button Size'] == 1 and h * 0.135 or h * 0.335

    -- Draw MAPVOTE title at the top left
    local titleX, titleY = w * 0.11, ScrH() - 1035
    local titleW, titleH = draw.SimpleTextOutlined('MAPVOTE', 'SolidMapVote.Title', titleX, titleY, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, 15))
    draw.SimpleTextOutlined('MAPVOTE', 'SolidMapVote.Title', titleX, titleY, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 30))

    -- Adjust X for the time to be next to the title, with a small offset
    local timeX = titleX + titleW + 20
    local timeY = ScrH() - 1005 -- Vertical alignment with the title (slightly lower than the title)
    local timeW, timeH = draw.SimpleTextOutlined(timeRemainingFormatted, 'SolidMapVote.Time', timeX, timeY, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, 15))
    draw.SimpleTextOutlined(timeRemainingFormatted, 'SolidMapVote.Time', timeX, timeY, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 30))

    -- Draw subtitle text just below the time
    local subTitleX = timeX -- Align subtitle with the time
    local subTitleY = ScrH() - 1035 -- Spacing under the time
    draw.SimpleTextOutlined(self.subTitleText, 'SolidMapVote.SubTitle', subTitleX, subTitleY, Color(233, 212, 96), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, 15))
    draw.SimpleTextOutlined(self.subTitleText, 'SolidMapVote.SubTitle', subTitleX, subTitleY, Color(233, 212, 96), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 30))

    -- Skip the progress bar if the voting has finished
    if self.finished then return end

    -- Draw progress bar (timer) properly under the content
    local progressBarX = w * 0.11 -- Set the X position further from the left
    local progressBarY = ScrH() - 970--h - 40 -- Set the Y position near the bottom
    local progressBarWidth = Lerp(timeRemainingDelta, 0, w * 0.9) -- Full width for the progress bar, adjusting by time remaining
    local progressBarHeight = 20 -- Set a fixed height for the progress bar

    -- Draw the progress bar background (shadow)
    draw.RoundedBox(0, progressBarX - 2, progressBarY - 2, progressBarWidth + 2, progressBarHeight + 4, Color(0, 0, 0, 30))
    draw.RoundedBox(0, progressBarX - 1, progressBarY - 1, progressBarWidth + 4, progressBarHeight + 2, Color(0, 0, 0, 60))

    -- Draw the progress bar foreground (actual progress)
    draw.RoundedBox(0, progressBarX, progressBarY, progressBarWidth, progressBarHeight, color_white)
end


function PANEL:Think()
    gui.EnableScreenClicker( true )
end

vgui.Register( 'SolidMapVote', PANEL )
