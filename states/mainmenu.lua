require 'objects/button'
require 'objects/button'

local menuparticles = require 'objects/menuparticles'

local audio = require "lib/wave"

mainmenu = {}

local mainLogoButton, mainPlayButton, mainOptionsButton, mainExitButton
local optionsLogoButton, optionsResolutionButton, optionsVolumeButton, optionsBackButton
local levelsLogoButton

local menuState, menuBG

function mainmenu:load()
  menuState = "main"
  menuBG = love.graphics.newImage("assets/menubg.jpg")

  mainLogoButton = newButton(gw / 2-330-15, gh / 2 - 130, 180, "2003", "", true, Lavender, White, 0, -34)
  mainPlayButton = newButton(gw / 2-100, gh / 2 + 85, 150, "Play", "", false, Green, White, 0, -23, function() menuState = "levels" end, function() menuState = "levels" end)
  mainOptionsButton = newButton(gw / 2+130, gh / 2 - 85, 150, "Options", "", false, Blue, White, 0, -23, function() menuState = "options" end, function() menuState = "options" end)
  mainExitButton = newButton(gw / 2+360, gh / 2 + 85, 150, "Exit", "", false, Red, White, 0, -23, function() love.event.quit(0) end, function() love.event.quit(0) end)

  optionsLogoButton = newButton(gw / 2-330-15, gh / 2 - 130, 180, "Options", "", true, Lavender, White, 0, -34)
  if (resolutionIndex == 8) then
    optionsResolutionButton = newButton(gw / 2-100, gh / 2 + 85, 150, "Resolution", "Fullscreen", false, Green, White, 0, -23, function() mainmenu:changeResolution(1) end, function() mainmenu:changeResolution(-1) end)
  else
    optionsResolutionButton = newButton(gw / 2-100, gh / 2 + 85, 150, "Resolution", resolutionList[resolutionIndex][1] .." x " .. resolutionList[resolutionIndex][2], false, Green, White, 0, -23, function() mainmenu:changeResolution(1) end, function() mainmenu:changeResolution(-1) end)
  end
  optionsVolumeButton = newButton(gw / 2+130, gh / 2 - 85, 150, "Volume", volumeValue .. "%", false, Blue, White, 0, -23, function() mainmenu:changeVolume(5) end, function() mainmenu:changeVolume(-5) end)
  optionsBackButton = newButton(gw / 2+360, gh / 2 + 85, 150, "Back", "", false, Red, White, 0, -23, function() mainmenu:saveSettings() menuState = "main" end, function() mainmenu:saveSettings() menuState = "main" end)

  levelsLogoButton = newButton(gw / 2-330-15, gh / 2 - 130, 180, "Levels", "", true, Lavender, White, 0, -34)
  Levels1Button = newButton(gw / 2-100, gh / 2 + 85, 150, "Super", savemanager.highscores.levelScore[1] .. "%", false, Green, White, 0, -23, function() mainmenu:startLevel(1) end, function() mainmenu:startLevel(1) end)
  Levels2Button = newButton(gw / 2+130, gh / 2 - 85, 150, "Hyper", savemanager.highscores.levelScore[2] .. "%", false, Blue, White, 0, -23, function() mainmenu:startLevel(2) end, function() mainmenu:startLevel(2) end)
  Levels3Button = newButton(gw / 2+360, gh / 2 + 85, 150, "Ultra", savemanager.highscores.levelScore[3] .. "%", false, Red, White, 0, -23, function() mainmenu:startLevel(3) end, function() mainmenu:startLevel(3) end)
  Levels4Button = newButton(gw / 2+590, gh / 2 - 85, 150, "Extreme", savemanager.highscores.levelScore[4] .. "%", false, Purple, White, 0, -23, function() mainmenu:startLevel(4) end, function() mainmenu:startLevel(4) end)

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

function mainmenu:saveSettings()
  savemanager:saveSettings(resolutionIndex, volumeValue)
  if (changedResolution) then
    changedResolution = false
    if resolutionList[resolutionIndex][1] == 0 and resolutionList[resolutionIndex][2] == 0 then
      isFullScreen = true
    else
      isFullScreen = false
    end
    simpleScale.updateWindow(resolutionList[resolutionIndex][1], resolutionList[resolutionIndex][2], {fullscreen=isFullScreen})
  end
end

function mainmenu:update(dt)
  menuparticles:update(dt)
  if (menuState == "main") then
    mainPlayButton:update(dt)
    mainOptionsButton:update(dt)
    mainExitButton:update(dt)
  elseif (menuState == "options") then
    optionsResolutionButton:update(dt)
    optionsVolumeButton:update(dt)
    optionsBackButton:update(dt)
  elseif (menuState == "levels") then
    Levels1Button:update(dt)
    Levels2Button:update(dt)
    Levels3Button:update(dt)
    Levels4Button:update(dt)
  end
end

function mainmenu:draw()
  love.graphics.draw(menuBG, 0, 0)
  love.graphics.setColor(0, 0, 0, 0.25)
  love.graphics.rectangle('fill', 0, 0, gw, gh)
  menuparticles:draw()
  if (menuState == "main") then
    mainLogoButton:draw()
    mainPlayButton:draw()
    mainOptionsButton:draw()
    mainExitButton:draw()
  elseif (menuState == "options") then
    optionsLogoButton:draw()
    optionsResolutionButton:draw()
    optionsVolumeButton:draw()
    optionsBackButton:draw()
  elseif (menuState == "levels") then
    levelsLogoButton:draw()
    Levels1Button:draw()
    Levels2Button:draw()
    Levels3Button:draw()
    Levels4Button:draw()
  end
  cursor:draw()
end

function mainmenu:mousepressed(x, y, button)
  if (menuState == "main") then
    mainPlayButton:mousepressed(x, y, button)
    mainOptionsButton:mousepressed(x, y, button)
    mainExitButton:mousepressed(x, y, button)
  elseif (menuState == "options") then
    optionsResolutionButton:mousepressed(x, y, button)
    optionsVolumeButton:mousepressed(x, y, button)
    optionsBackButton:mousepressed(x, y, button)
  elseif (menuState == "levels") then
    Levels1Button:mousepressed(x, y, button)
    Levels2Button:mousepressed(x, y, button)
    Levels3Button:mousepressed(x, y, button)
    Levels4Button:mousepressed(x, y, button)
  end
end

function mainmenu:gamepadpressed(joystick, button)
  if (button == "start" or button == "back" or button == "b") then
    if (menuState == "main") then
      menuState = "quit"
    elseif (menuState == "options") then
      menuState = "main"
    elseif (menuState == "levels") then
      menuState = "main"
    end
  end
  if (menuState == "main") then
    playButton:gamepadpressed(joystick, button)
    optionsButton:gamepadpressed(joystick, button)
    quitButton:gamepadpressed(joystick, button)
  elseif (menuState == "options") then
    if (joystick ~= nil) then
      optionsJoystickButton:gamepadpressed(joystick, button)
    end
    optionsResolutionButton:gamepadpressed(joystick, button)
    optionsVolumeButton:gamepadpressed(joystick, button)
    optionsBackButton:gamepadpressed(joystick, button)
  elseif (menuState == "levels") then
    level1Button:gamepadpressed(joystick, button)
    level2Button:gamepadpressed(joystick, button)
    level3Button:gamepadpressed(joystick, button)
    level4Button:gamepadpressed(joystick, button)
    level5Button:gamepadpressed(joystick, button)
    levelBackButton:gamepadpressed(joystick, button)
  end
end

function mainmenu:keypressed(key)
  if (menuState == "options") then
    if (key == "escape") then
      menuState = "main"
    end
  elseif (menuState == "levels") then
    if (key == "escape") then
      menuState = "main"
    end
  end
end

function mainmenu:changeResolution(value)
  changedResolution = true
  resolutionIndex = resolutionIndex + value
  if (resolutionIndex < 1) then
    resolutionIndex = #resolutionList
  elseif (resolutionIndex > #resolutionList) then
    resolutionIndex = 1
  end
  if (resolutionIndex == 8) then
    optionsResolutionButton:setAltText("Fullscreen")
  else
    optionsResolutionButton:setAltText(resolutionList[resolutionIndex][1] .." x " .. resolutionList[resolutionIndex][2])
  end
end

function mainmenu:changeVolume(value)
  volumeValue = volumeValue + value
  if (volumeValue < 0) then
    volumeValue = 200
  elseif (volumeValue > 200) then
    volumeValue = 0
  end
  optionsVolumeButton:setAltText(volumeValue .. "%")
  menumusic:setVolume(volumeValue * 0.001)
  buttonhover:setVolume(volumeValue * 0.001)
  buttonhit:setVolume(volumeValue * 0.001)
  circlehitsound:setVolume(volumeValue * 0.001)
  failsound:setVolume(volumeValue * 0.001)
end

return mainmenu
