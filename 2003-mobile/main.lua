require 'lib/simpleScale'

require 'globals'
require 'colors'

require 'managers/statemanager'

function love.load()
  statemanager:load()
  simpleScale.setWindow(gw, gh, 866, 411)
end

function love.update(dt)
  collectgarbage()
  statemanager:update(dt)
end

function love.draw()
  simpleScale.set()
    statemanager:draw()
  simpleScale.unSet()
end

function love.mousepressed(x, y, button)
  statemanager:mousepressed(x, y, button)
end

function love.keypressed(key)
  statemanager:keypressed(key)
end
