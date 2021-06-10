playertrail_array = require 'objects/playertrail_array'

player = {}

local playerPosX, playerPosY

function player:load()
  playerPosX = gw/2
  playerPosY = 290
  playerMoveDelta = 240
  angle = 0
end

function player:update(dt, isEndGame)
  if not isEndGame then
    angle = angle + (6000 / (playerMoveDelta * math.pi * 2.0)) * dt
    playerPosX = gw/2+math.cos(angle)*playerMoveDelta
    playerPosY = gh/2+math.sin(angle)*playerMoveDelta
    playertrail_array:update(dt, playerPosX, playerPosY)
  end
end

function player:draw()
  playertrail_array:draw()
  love.graphics.setColor(White)
  love.graphics.circle('fill', playerPosX, playerPosY, 20, 120)
  love.graphics.setColor(Player1Color)
  love.graphics.setLineWidth(8)
  love.graphics.circle('line', playerPosX, playerPosY, 20, 120)
end

function player:getPositionX()
  return playerPosX
end

function player:getPositionY()
  return playerPosY
end

return player
