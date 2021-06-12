circletrail = require 'objects/circletrail'

circle = {}
listOfCircles = {}

function createCircle(pos, speed)
  c = {}
  c.x = 0
  c.y = 0
  if (pos > 0) then
    c.pos = 50+50*pos
    c.color = Player1Color
  else
    c.pos = -50+50*pos
    c.color = Player2Color
  end
  c.speed = speed
  c.angle = 0
  c.circletrail = {}
  table.insert(listOfCircles, c)
end

function circle:update(dt)
  for i, v in ipairs(listOfCircles) do
    v.angle = v.angle + (v.speed / v.pos * dt)
    v.x = gw/2+math.cos(v.angle)*v.pos
    v.y = gh/2+math.sin(v.angle)*v.pos
    if (math.abs(v.angle) > math.pi) then
      table.remove(listOfCircles, i)
      maingame:fail()
    end
    table.insert(v.circletrail, circletrail:new(v.x, v.y))
    for i = #v.circletrail, 1, -1 do
      v.circletrail[i]:update(dt)
      if v.circletrail[i].size <= 0 then
        table.remove(v.circletrail, i)
      end
    end
  end
end

function circle:draw()
  for i, v in ipairs(listOfCircles) do
    for i = 1, #v.circletrail do
      v.circletrail[i]:draw()
    end
    love.graphics.setColor(White)
    love.graphics.circle('fill', v.x, v.y, 20, 120)
    love.graphics.setColor(v.color)
    love.graphics.setLineWidth(8)
    love.graphics.circle('line', v.x, v.y, 20, 120)
  end
end

return circle
