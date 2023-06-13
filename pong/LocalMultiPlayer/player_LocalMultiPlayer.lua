player_LocalMultiPlayer =  {}
function player_LocalMultiPlayer:load()
   self.x = 50
   self.y = love.graphics.getHeight() / 2
   self.Height = 100
   self.Width = 20
   self.speed = 300
end

function player_LocalMultiPlayer:update(dt)
   player_LocalMultiPlayer:move(dt)
   player_LocalMultiPlayer:border()
end

function player_LocalMultiPlayer:move(dt)
-- Hand Controller
   local joystick = love.joystick.getJoysticks()[1]
   local joystickcount = love.joystick.getJoystickCount()
   if (joystickcount > 0) then
   local threshold = 0.5 -- adjust this as needed
   if joystick:getAxis(2) < -threshold then
      self.y = self.y - self.speed * dt
   elseif joystick:getAxis(2) > threshold then
      self.y = self.y + self.speed * dt
   end
end
-- hand conrller End

-- Keyboard
   if love.keyboard.isDown("w") then
      self.y = self.y - self.speed * dt
   elseif
      love.keyboard.isDown("s") then
         self.y = self.y + self.speed * dt
      end
   end
-- keyboard End

   function player_LocalMultiPlayer:border()
      if self.y < 0 then
         self.y = 0
      elseif self.y + self.Height > love.graphics.getHeight() then
         self.y = love.graphics.getHeight() - self.Height
      end
   end

   function player_LocalMultiPlayer:draw()
      love.graphics.setColor(0, 255, 0)
      love.graphics.rectangle("fill", self.x, self.y, self.Width, self.Height)
   end