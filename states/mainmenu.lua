require 'objects/button'
require 'objects/squareButton'
local menuparticles = require 'objects/menuparticles'


local audio = require "lib/wave"

mainmenu = {}

local menuSelected, menuState
local menuBG

function mainmenu:load()
  menuState = "main"
  menuSelected = 1
  menuBG = love.graphics.newImage("assets/menubg.jpg")

  mainLogoButton = newSquareButton(gw / 2-330-15, gh / 2 - 130, 180, "2003", "", true, Lavender, White, 0, -34)
  mainPlayButton = newSquareButton(gw / 2-100, gh / 2 + 85, 150, "Play", "", false, Green, White, 0, -23, function() menuState = "levels" end, function() end)
  mainOptionsButton = newSquareButton(gw / 2+130, gh / 2 - 85, 150, "Options", "", false, Blue, White, 0, -23, function() menuState = "options" end, function() end)
  mainExitButton = newSquareButton(gw / 2+360, gh / 2 + 85, 150, "Exit", "", false, Red, White, 0, -23, function() love.event.quit(0) end, function() end)

  optionsLogoButton = newSquareButton(gw / 2-330-15, gh / 2 - 130, 180, "Options", "", true, Lavender, White, 0, -34)
  optionsResolutionButton = newSquareButton(gw / 2-100, gh / 2 + 85, 150, "Resolution", "1920 x 1080", false, Green, White, 0, -23, function() mainmenu:changeResolution(1) end, function() mainmenu:changeResolution(-1) end)
  optionsVolumeButton = newSquareButton(gw / 2+130, gh / 2 - 85, 150, "Volume", "100%", false, Blue, White, 0, -23, function() mainmenu:changeVolume(5) end, function() mainmenu:changeVolume(-5) end)
  optionsBackButton = newSquareButton(gw / 2+360, gh / 2 + 85, 150, "Back", "", false, Red, White, 0, -23, function() menuState = "main" end, function() end)

  levelsLogoButton = newSquareButton(gw / 2-330-15, gh / 2 - 130, 180, "Levels", "", true, Lavender, White, 0, -34)
  Levels1Button = newSquareButton(gw / 2-100, gh / 2 + 85, 150, "Super", "0%", false, Green, White, 0, -23, function() mainmenu:startLevel(1) end, function() end)
  Levels2Button = newSquareButton(gw / 2+130, gh / 2 - 85, 150, "Hyper", "20%", false, Blue, White, 0, -23, function() mainmenu:startLevel(2) end, function() end)
  Levels3Button = newSquareButton(gw / 2+360, gh / 2 + 85, 150, "Ultra", "12%", false, Red, White, 0, -23, function() mainmenu:startLevel(3) end, function() end)
  Levels4Button = newSquareButton(gw / 2+590, gh / 2 - 85, 150, "Extreme", "100%", false, Purple, White, 0, -23, function() mainmenu:startLevel(4) end, function() end)

  buttonhover = audio:newSource("assets/buttonhover.wav", "stream")
  buttonhover:setVolume(volumeValue * 0.001)
  buttonhover:setLooping(false)

  buttonhit = audio:newSource("assets/buttonhit2.wav", "stream")
  buttonhit:setVolume(volumeValue * 0.001)
  buttonhit:setLooping(false)

  menumusic = audio:newSource("songs/OcularNebula - Pulsar.mp3", "stream")
  menumusic:parse()
  menumusic:setVolume(volumeValue * 0.001)
  menumusic:setLooping(true)
  menumusic:play()
end

function mainmenu:startLevel(levelIndex)
  menumusic:stop()
  menuparticles:clearParticles()
  statemanager:changeState("game")
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
  if (menuState == "main") then
    if (key == "return") then
      if (menuSelected == 1) then
        menuState = "levels"
        menuSelected = 1
      elseif (menuSelected == 2) then
        menuState = "options"
        menuSelected = 1
      elseif (menuSelected == 3) then
        love.event.quit(0)
      end
    end
  elseif (menuState == "options") then
    if (key == "escape") then
      menuState = "main"
      menuSelected = 1
    elseif (key == "return") then
        if (menuSelected == 3) then
          menuState = "main"
          menuSelected = 1
        end
    end
  elseif (menuState == "levels") then
    if (key == "escape") then
      menuState = "main"
      menuSelected = 1
    elseif (key == "return") then
      mainmenu:startLevel(menuSelected)
    end
  end
end

function mainmenu:menuScreen()
  if (menuSelected == 1) then
    mainmenu:baseLayout(Green)
    love.graphics.setFont(titleFont)
    love.graphics.printf("Play", 0, gh/2-35, gw, "center")
  elseif (menuSelected == 2) then
    mainmenu:baseLayout(Purple)
    love.graphics.setFont(titleFont)
    love.graphics.printf("Options", 0, gh/2-35, gw, "center")
  elseif (menuSelected == 3) then
    mainmenu:baseLayout(Red)
    love.graphics.setFont(titleFont)
    love.graphics.printf("Quit", 0, gh/2-35, gw, "center")
  end
  love.graphics.setFont(difficultyFont)
end


function mainmenu:optionsScreen()
  if (menuSelected == 1) then
    mainmenu:baseLayout(Green)
    love.graphics.setFont(titleFont)
    love.graphics.printf("Resolution", 0, gh/2-50, gw, "center")
    love.graphics.printf("1920 x 1080", 0, gh/2, gw, "center")
  elseif (menuSelected == 2) then
    mainmenu:baseLayout(Purple)
    love.graphics.setFont(titleFont)
    love.graphics.printf("Volume", 0, gh/2-50, gw, "center")
    love.graphics.printf("100%", 0, gh/2, gw, "center")
  elseif (menuSelected == 3) then
    mainmenu:baseLayout(Red)
    love.graphics.setFont(titleFont)
    love.graphics.printf("Back", 0, gh/2-35, gw, "center")
  end
end


function mainmenu:playScreen()
  mainmenu:baseLayout(Blue)
  love.graphics.setFont(titleFont)
  if (menuSelected == 1) then
    love.graphics.printf("Flower Dance", 0, gh/2-50, gw, "center")
    love.graphics.setFont(difficultyFont)
    love.graphics.printf("Easy", 0, gh/2+20, gw, "center")
  elseif (menuSelected == 2) then
    love.graphics.printf("Betrayal Fate", 0, gh/2-50, gw, "center")
    love.graphics.setFont(difficultyFont)
    love.graphics.printf("Normal", 0, gh/2+20, gw, "center")
  elseif (menuSelected == 3) then
    love.graphics.printf("Ultimate Destruction", 0, gh/2-50, gw, "center")
    love.graphics.setFont(difficultyFont)
    love.graphics.printf("Hard", 0, gh/2+20, gw, "center")
  elseif (menuSelected == 4) then
    love.graphics.printf("Erehamonika", 0, gh/2-50, gw, "center")
    love.graphics.setFont(difficultyFont)
    love.graphics.printf("Insane", 0, gh/2+20, gw, "center")
  end
end

function mainmenu:baseLayout(color)
  love.graphics.setColor(color)
  love.graphics.circle("fill", gw/2, gh/2, 500, 4)
  love.graphics.setColor(Opacity15)
  love.graphics.polygon("fill", 460, gh/2,
                                680, gh/2-220,
                                680, gh/2+220)
  love.graphics.polygon("fill", gw-460, gh/2,
                              gw-680, gh/2-220,
                              gw-680, gh/2+220)
  love.graphics.setFont(logoFont)
  love.graphics.setColor(White)
  love.graphics.printf("2003", 0, 230, gw, "center")
  love.graphics.setLineWidth(15)
  love.graphics.circle("line", gw/2, gh/2, 500, 4)
  love.graphics.line(620, gh/2-50,
                     570, gh/2,
                     620, gh/2+50)
  love.graphics.line(gw-620, gh/2-50,
                     gw-570, gh/2,
                     gw-620, gh/2+50)
end

function mainmenu:changeResolution(value)
  changedResolution = true
  resolutionIndex = resolutionIndex + value
  if (resolutionIndex < 1) then
    resolutionIndex = #resolutionList
  elseif (resolutionIndex > #resolutionList) then
    resolutionIndex = 1
  end
end

function mainmenu:changeVolume(value)
  volumeValue = volumeValue + value
  if (volumeValue < 0) then
    volumeValue = 200
  elseif (volumeValue > 200) then
    volumeValue = 0
  end
  menumusic:setVolume(volumeValue * 0.001)
end

return mainmenu
