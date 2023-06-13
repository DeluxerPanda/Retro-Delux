-- pong
require ("pong/pongMenu")
-- pong Singel Player
require("pong/SinglePlayer/player_SinglePlayer")
require("pong/SinglePlayer/ai_SinglePlayer")
require("pong/SinglePlayer/ball_SinglePlayer")
-- pong Local MultiPlayer
require("pong/LocalMultiPlayer/player_LocalMultiPlayer")
require("pong/LocalMultiPlayer/playerTow_LocalMultiPlayer")
require("pong/LocalMultiPlayer/ball_LocalMultiPlayer")
-- background
require("pong/background/ai_background")
require("pong/background/ai_Tow_background")
require("pong/background/ball_background")
-- utils
require("utils/resize")
require("utils/pause_menu")
require("utils/keypresses")
require("utils/lang")
require("utils/color")
require ('utils/simple-slider')



Game_Titl_font = love.graphics.newFont("Fonts/VT323-Regular.ttf", 50)
Button_font = love.graphics.newFont("Fonts/VT323-Regular.ttf", 30)
blip = love.audio.newSource("Music/ping_pong_8bit_beeep.mp3", "static")
blip_win = love.audio.newSource("Music/ping_pong_8bit_peeeeeep.mp3", "static")
button_blop = love.audio.newSource("Music/ping_pong_8bit_plop.mp3", "static")
Marcus_Nyman_MLIM_S2 = love.audio.newSource("Music/Marcus_Nyman_feat.Fluency_Melody_MLIM_S2_Music_1.mp3", "stream")
Marcus_Nyman_MLIM_S2:setLooping(true)
Nostalgia = love.audio.newSource("Music/8_Bit_Nostalgia.mp3", "stream")
Nostalgia:setLooping(true)
Lobby_Time = love.audio.newSource("Music/Lobby-Time.mp3", "stream")
Lobby_Time:setLooping(true)
started_SinglePlayer = false
started_LocalMultiPlayer = false
OnPongMenu = false
OnSettings = false
OnSettingsAudio = false
OnStartMenu = true
OnPongButton = true
WiningPong = false
WiningPongWhitPoints = true
 corner_radius = 10
 button_width = 200
 button_height = 50
 button_padding = 20
 button_start_y = 500
 selectButton = 1
 joystick_timer = 0
 joystick_delay = 0.2
love.mouse.setVisible(true)

local file = io.open("settings.conf", "r")
file:seek("set")
-- läser alla rader
local line = file:read("*line")
local line2 = file:read("*line")
local line3 = file:read("*line")
local line4 = file:read("*line")
local line5 = file:read("*line")
local line6 = file:read("*line")
local line7 = file:read("*line")
volumeMainV = line3
volumeMusicV = line4
point_GivenV = line5
volumeHitV = line6
volumeButton_hitV = line7
file:close()
local line = nil
local line2 = nil
local line3 = nil
local line4 = nil
local line5 = nil
local line6 = nil
local line7 = nil
collectgarbage("collect")

love.audio.setVolume(volumeMainV)
Marcus_Nyman_MLIM_S2:setVolume(volumeMusicV)
Lobby_Time:setVolume(volumeMusicV)
Nostalgia:setVolume(volumeMusicV)
blip_win:setVolume(point_GivenV)
blip:setVolume(volumeHitV)
button_blop:setVolume(volumeButton_hitV)

function love.load()
    lang:language()
    if OnStartMenu then
        love.mouse.setVisible(true)
        love.audio.play(Marcus_Nyman_MLIM_S2)
     --   keyboard:GetVolume()
        -- Set the button positions
        GameTitle_x = (love.graphics.getWidth() / 2) - (button_start_y / 2)
        GameTitle_y = 80

        pongMenu_button_x = (love.graphics.getWidth() / 2) - (button_width / 2)
        pongMenu_button_y = love.graphics.getHeight() / 2 - button_height / 2

        pinball_button_x = (love.graphics.getWidth() / 2) - (button_width / 2)
        pinball_button_y =  pongMenu_button_y + button_height + button_padding

        Settings_button_x = love.graphics.getWidth() - button_width - 10
        Settings_button_y = love.graphics.getHeight() - 60

        quit_button_x = (love.graphics.getWidth() / 2) - (button_width / 2)
        quit_button_y = love.graphics.getHeight() - 60

        credits_button_x = 10
        credits_button_y = love.graphics.getHeight() - 60
        if OnPongButton then
        -- background
        ai_background:load()
        ai_Tow_background:load()
        ball_background:load()
        end

    end
end
local timera = 0

function wait(duration, callback)
    timera = duration
    while timera > 0 do
        timera = timera - love.timer.getDelta()
    end
    if callback then
        callback()
    end
end

function love.update(dt)
    if OnStartMenu or OnPongMenu then
        if OnPongButton then
        -- background
        ai_background:update(dt)
        ai_Tow_background:update(dt)
        ball_background:update(dt)
    end
    end

   local joystickcount = love.joystick.getJoystickCount()
    if (joystickcount > 0) then

  joystick_timer = joystick_timer + dt
  if joystick_timer >= joystick_delay then
   
    local threshold = 0.5
    local joystick = love.joystick.getJoysticks()[1]
    if joystick:getAxis(2) < -threshold then
        keyboard:MenuUp()
        success = joystick:setVibration(1, 1)
        wait(1, function() joystick:setVibration(0, 0) end)
    elseif joystick:getAxis(2) > threshold then
        keyboard:MenuDown()
    elseif joystick:getAxis(1) < -threshold then
        keyboard:MenuLeft()
    elseif joystick:getAxis(1) > threshold then
        keyboard:MenuRight()
    end
    joystick_timer = 0
  end
    end

end
--
function love.gamepadaxis( joystick, axis, value )
	if axis == 'triggerleft' or axis == 'triggerright' then
		local left = joystick:getGamepadAxis("triggerleft")
		local right = joystick:getGamepadAxis("triggerright")
		success = joystick:setVibration(left, right)
	end
end
--
function love.draw()
    if OnStartMenu or OnPongMenu then
            -- background
            love.graphics.setBackgroundColor(slategray)
            if OnPongButton then
            ai_background:draw()
            ai_Tow_background:draw()
            ball_background:draw()
            end
            end
    if OnPongMenu then
        pongMenu()
    end
    if OnStartMenu or OnSettings then
        local mouse_x, mouse_y = love.mouse.getPosition()
    -- Hover over the Buttons --
    -- pongMenu
    if mouse_x >= pongMenu_button_x and mouse_x <= pongMenu_button_x + button_width and
        mouse_y >= pongMenu_button_y and mouse_y <= pongMenu_button_y + button_height or
        selectButton == 1 then
         selectButton = 1
         OnPongButton = true
        love.graphics.setColor(yellow)
        love.graphics.rectangle("fill", pongMenu_button_x , pongMenu_button_y , button_width + 5, button_height + 5, corner_radius, corner_radius)
    end
    -- pinball
    if mouse_x >= pinball_button_x and mouse_x <= pinball_button_x + button_width and
        mouse_y >= pinball_button_y and mouse_y <= pinball_button_y + button_height or
        selectButton == 2 then
         selectButton = 2
         OnPongButton = false
        love.graphics.setColor(yellow)
        love.graphics.rectangle("fill", pinball_button_x , pinball_button_y , button_width + 5, button_height + 5, corner_radius, corner_radius)
    end
    -- GameExit
    if mouse_x >= quit_button_x and mouse_x <= quit_button_x + button_width and
        mouse_y >= quit_button_y and mouse_y <= quit_button_y + button_height or
        selectButton == 3 then
         selectButton = 3
         OnPongButton = false
        love.graphics.setColor(yellow)
        love.graphics.rectangle("fill", quit_button_x , quit_button_y, button_width + 5, button_height + 5, corner_radius, corner_radius)
    end
    -- Credits
    if mouse_x >= credits_button_x and mouse_x <= credits_button_x + button_width and
        mouse_y >= credits_button_y and mouse_y <= credits_button_y + button_height or
        selectButton == 4 then
         selectButton = 4
         OnPongButton = false
        love.graphics.setColor(yellow)
        love.graphics.rectangle("fill", credits_button_x, credits_button_y, button_width + 5, button_height + 5, corner_radius, corner_radius)
    end
    -- Settings
    if mouse_x >= Settings_button_x and mouse_x <= Settings_button_x + button_width and
        mouse_y >= Settings_button_y and mouse_y <= Settings_button_y + button_height or
        selectButton == 5 then
         selectButton = 5
         OnPongButton = false
        love.graphics.setColor(yellow)
        love.graphics.rectangle("fill", Settings_button_x , Settings_button_y , button_width + 5, button_height + 5, corner_radius, corner_radius)
    end
        -- Game Title
        love.graphics.setFont(Game_Titl_font)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(GameTitleName, GameTitle_x, GameTitle_y, button_start_y, "center")

        love.graphics.setFont(Button_font)
        -- pongMenu
        love.graphics.setColor(green)
        love.graphics.rectangle("fill", pongMenu_button_x, pongMenu_button_y, button_width, button_height, corner_radius, corner_radius)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(PongName, pongMenu_button_x, pongMenu_button_y + 10, button_width, "center")
        -- pinball
        love.graphics.setColor(gary)
        love.graphics.rectangle("fill", pinball_button_x, pinball_button_y, button_width, button_height, corner_radius, corner_radius)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(pinballName, pinball_button_x, pinball_button_y + 10, button_width, "center")
        -- Settings
        love.graphics.setColor(green)-- 0, 0, 0.737, 1
        love.graphics.rectangle("fill", Settings_button_x, Settings_button_y, button_width, button_height, corner_radius, corner_radius)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(SettingsName, Settings_button_x, Settings_button_y + 10, button_width, "center")
        -- GameExit
        love.graphics.setColor(red)
        love.graphics.rectangle("fill", quit_button_x, quit_button_y, button_width, button_height, corner_radius, corner_radius)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(GameExitName, quit_button_x, quit_button_y + 10, button_width, "center")
        -- Credits
        love.graphics.setColor(green)
        love.graphics.rectangle("fill", credits_button_x, credits_button_y, button_width, button_height, corner_radius, corner_radius)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(CreditsName, credits_button_x, credits_button_y + 10, button_width, "center")
end
end

function checkCollision(a, b)
    if a.x + a.Width > b.x and a.x < b.x + b.Width and a.y + a.Height > b.y and a.y < b.y + b.Height then
        return true
    else
        return false
    end
end