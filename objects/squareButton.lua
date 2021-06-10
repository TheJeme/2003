local squareButton = {}
squareButton.__index = squareButton


function newSquareButton(x, y, radius, text, altText, isLogo, inlineColor, outlineColor, ox, oy, func1, func2)
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

  return setmetatable(s, squareButton)
end

function squareButton:isMouseOnButton(mx, my, ox, oy, r)
  local dist = (mx - ox)^2 + (my - oy)^2
  return dist <= (1 + r)^2
end

function squareButton:draw()
  love.graphics.setLineWidth(30)
  love.graphics.setColor(self.outlineColor)
  love.graphics.circle("line", self.x, self.y, self.radius, 4)
  love.graphics.setColor(self.inlineColor)
  love.graphics.circle("fill", self.x, self.y, self.radius, 4)
  if (squareButton:isMouseOnButton(mx, my, self.x, self.y, self.radius*0.9) and not self.isLogo) then
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

function squareButton:mousepressed(x, y, button)
  if squareButton:isMouseOnButton(mx, my, self.x, self.y, self.radius*0.9) then
    if (button == 1) then
      self.func1()
      --soundManager.playSoundEffect(soundManager.buttonHitsrc)
    elseif (button == 2) then
      self.func2()
    end
  end
end
