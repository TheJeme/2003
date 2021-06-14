require 'objects/button'

local menuparticles = require 'objects/menuparticles'

local audio = require "lib/wave"

mainmenu = {}

local levelsLogoButton, Levels1Button, Levels2Button, Levels3Button, Levels4Button
local menuBG

function mainmenu:load()
  menuBG = love.graphics.newImage("assets/menubg.jpg")
  levelsLogoButton = newButton(gw / 2-330-15, gh / 2 - 130, 180, "Levels", "", true, Lavender, White, 0, -34)
  Levels1Button = newButton(gw / 2-100, gh / 2 + 85, 150, "Super", "", false, Green, White, 0, -23, function() mainmenu:startLevel(1) end)
  Levels2Button = newButton(gw / 2+130, gh / 2 - 85, 150, "Hyper", "", false, Blue, White, 0, -23, function() mainmenu:startLevel(2) end)
  Levels3Button = newButton(gw / 2+360, gh / 2 + 85, 150, "Ultra", "", false, Red, White, 0, -23, function() mainmenu:startLevel(3) end)
  Levels4Button = newButton(gw / 2+590, gh / 2 - 85, 150, "Extreme", "", false, Purple, White, 0, -23, function() mainmenu:startLevel(4) end)

  buttonhover = audio:newSource("assets/buttonhover.wav", "stream")
  buttonhover:setVolume(volumeValue * 0.001)

  buttonhit = audio:newSource("assets/buttonhit.wav", "stream")
  buttonhit:setVolume(volumeValue * 0.001)

  menumusic = audio:newSource("songs/OcularNebula - Pulsar.mp3", "stream")
  menumusic:parse()
  menumusic:setVolume(volumeValue * 0.001)
  menumusic:setLooping(true)
  menumusic:play()
end

function mainmenu:startLevel(index)
  menumusic:stop()
  menuparticles:clearParticles()
  statemanager:changeState("game")
  maingame:loadLevel(index)
end


function mainmenu:update(dt)
  menuparticles:update(dt)
end

function mainmenu:draw()
  love.graphics.draw(menuBG, 0, 0)
  love.graphics.setColor(0, 0, 0, 0.25)
  love.graphics.rectangle('fill', 0, 0, gw, gh)
  menuparticles:draw()
  levelsLogoButton:draw()
  Levels1Button:draw()
  Levels2Button:draw()
  Levels3Button:draw()
  Levels4Button:draw()
end

function mainmenu:mousepressed(x, y, button)
  Levels1Button:mousepressed(x, y, button)
  Levels2Button:mousepressed(x, y, button)
  Levels3Button:mousepressed(x, y, button)
  Levels4Button:mousepressed(x, y, button)
end

function mainmenu:keypressed(key)
  if (key == "escape") then
    love.event.quit()
  end
end

return mainmenu
