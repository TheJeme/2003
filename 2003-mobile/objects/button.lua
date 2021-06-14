local button = {}
button.__index = button

function newButton(x, y, radius, text, altText, isLogo, inlineColor, outlineColor, ox, oy, func)
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
  s.func = func

  return setmetatable(s, button)
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
  if button:isMouseOnButton(x / simpleScale.getScale()-160, y / simpleScale.getScale(), self.x, self.y, self.radius*0.9) then
    self.func()
    buttonhit:play()
  end
end
