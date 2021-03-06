local button = {}
button.__index = button

function newButton(x, y, radius, text, altText, isLogo, inlineColor, outlineColor, ox, oy, func1, func2)
  local s = {}
  s.x = x
  s.y = y
  s.radius = radius
  s.text = text
  s.altText = altText
  s.isLogo = isLogo
  s.inlineColor = inlineColor
  s.outlineColor = outlineColor
  s.ox = ox or 0
  s.oy = oy or 0
  s.func1 = func1
  s.func2 = func2

  return setmetatable(s, button)
end

function button:update(dt)
  if button:isMouseOnButton(mx, my, self.x, self.y, self.radius*0.9) then
    if (self.hover == false) then
      self.hover = true
      buttonhover:play()
    end
  else
    self.hover = false
  end
end

function button:isMouseOnButton(mx, my, ox, oy, r)
  local dist = (mx - ox)^2 + (my - oy)^2
  return dist <= (1 + r)^2
end

function button:setMainText(text)
  self.text = text
end

function button:setAltText(altText)
  self.altText = altText
end

function button:draw()
  love.graphics.setLineWidth(30)
  love.graphics.setColor(self.outlineColor)
  love.graphics.circle("line", self.x, self.y, self.radius, 4)
  love.graphics.setColor(self.inlineColor)
  love.graphics.circle("fill", self.x, self.y, self.radius, 4)
  if (button:isMouseOnButton(mx, my, self.x, self.y, self.radius*0.9) and not self.isLogo) then
    love.graphics.setColor(0.1, 0.1, 0.1, 0.1)
    love.graphics.circle("fill", self.x, self.y, self.radius, 4)
  end
  love.graphics.setColor(1, 1, 1, 1)
  if (self.isLogo) then
    love.graphics.setFont(logoFont)
  else
    love.graphics.setFont(titleFont)
  end
  love.graphics.printf(self.text, self.x - self.radius + self.ox, self.y + self.oy, self.radius * 2, "center")
  love.graphics.setFont(altTitleFont)
  love.graphics.printf(self.altText, self.x - self.radius + self.ox, self.y + self.oy + 50, self.radius * 2, "center")
end

function button:mousepressed(x, y, b)
  if button:isMouseOnButton(mx, my, self.x, self.y, self.radius*0.9) then
    if (b == 1) then
      self.func1()
    elseif (b == 2) then
      self.func2()
    end
    buttonhit:play()
  end
end
