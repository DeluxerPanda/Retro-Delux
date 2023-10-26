

    if OnPinballGame == true then 
    FlipperOne:load()
    FlipperTwo:load()
    FlipperBall:load()
end

function love.update(dt)
    if OnPinballGame == true then

    if not paused and not helper then
    FlipperOne:update(dt)
    FlipperTwo:update(dt)

    if started_PinBall == true then
    FlipperBall:update(dt)
    end
end
end
end

function love.draw()
    if started_PinBall_Text == true then
    if not helper then
    if not paused then
        local SpaceStart_y = love.graphics.getHeight() / 2
        local SpaceStart_x = (love.graphics.getWidth() / 2) - (button_start_y / 2)
        love.graphics.setColor(white)
        love.graphics.setFont(emoji_font)
        love.graphics.printf(SpaceStartName, SpaceStart_x, SpaceStart_y, button_start_y, "center")
    end
    end
end

    if OnPinballGame == true then
    if not helper then
        FlipperOne:draw()
        FlipperTwo:draw()
        if started_PinBall == true then
        FlipperBall:draw()
        end
    end

if paused then
    pause_menu()
    end
    if helper then
    selectButton = 1
    PinBallhelp()
    end
    end
    end
    if HasNotPlaydeBefore_PinBall then
       HasNotPlaydeBefore_PinBall = false
       helper = true
    end


function checkCollision(a, b)
   if OnPinballGame then
   if a.x + a.Width > b.x and a.x < b.x + b.Width and a.y + a.Height > b.y and a.y < b.y + b.Height then
      return true
   else
      return false
   end
end
end