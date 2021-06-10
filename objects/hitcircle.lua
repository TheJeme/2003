local hitcircle = {}

function newButton(x, speed, type)
  local c = {}
  c.x = x
  c.speed = speed
  c.type = type -- 1 or 2

  return setmetatable(b, button)
end

function button:update(dt)
  self.isMouseOnButton = cursorMX > self.x and cursorMX < self.x + self.width and
                          cursorMY > self.y and cursorMY < self.y + self.height
  if self.isMouseOnButton then
    if (self.hover == false) then
      self.hover = true
      buttonhover:play()
    end
  else
    self.hover = false
  end
end

function button:mousepressed(x, y, button)
  if self.isMouseOnButton and (button == 1) then
    self.func()
    buttonhit:play()
  elseif self.isMouseOnButton and button == 2 then
    self.func2()
    buttonhit:play()
  end
end

function button:gamepadpressed(joystick, button)
  if self.isMouseOnButton and button == "a" then
    self.func()
  elseif self.isMouseOnButton and button == "x" then
    self.func2()
  end
end

function button:getHoverState()
  return self.hover
end
