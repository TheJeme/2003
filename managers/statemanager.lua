require 'states/mainmenu'
require 'states/maingame'

statemanager = {}

local currentState

function statemanager:load()
  currentState = "menu"
  mainmenu:load()
  maingame:load()
end

function statemanager:update(dt)
  if (currentState == "menu") then
    mainmenu:update(dt)
  elseif (currentState == "game") then
    maingame:update(dt)
  end
end

function statemanager:draw()
  if (currentState == "menu") then
    mainmenu:draw()
  elseif (currentState == "game") then
    maingame:draw()
  end
end

function statemanager:mousepressed(x, y, button)
  if (currentState == "menu") then
    mainmenu:mousepressed(x, y, button)
  elseif (currentState == "game") then
    maingame:mousepressed(x, y, button)
  end
end

function statemanager:keypressed(key)
  if (currentState == "menu") then
    mainmenu:keypressed(key)
  elseif (currentState == "game") then
    maingame:keypressed(key)
  end
end

function statemanager:changeState(state)
  currentState = state
end

function statemanager:getState()
  return currentState
end


return statemanager
