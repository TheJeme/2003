circletrail_array = require 'objects/circletrail_array'

circle = {}
listOfCircles = {}

function createCircle(pos, speed)
  circle = {}
  circle.x = 0
  circle.y = 0
  circle.pos = pos
  circle.speed = speed
  circle.angle = 0
  table.insert(listOfCircles, circle)
end

function circle:update(dt)
  for i, v in ipairs(listOfCircles) do
    v.angle = v.angle + (v.speed / v.pos * dt)
    v.x = gw/2+math.cos(v.angle)*v.pos
    v.y = gh/2+math.sin(v.angle)*v.pos
  end
end

function circle:draw()
  for i, v in ipairs(listOfCircles) do
    love.graphics.setColor(White)
    love.graphics.circle('fill', v.x, v.y, 20, 120)
    love.graphics.setColor(Player1Color)
    love.graphics.setLineWidth(8)
    love.graphics.circle('line', v.x, v.y, 20, 120)
  end
end

return circle
