require 'managers/levelmanager'
require 'objects/player'

local audio = require "lib/wave"

maingame = {}

levelSongs = {audio:newSource("songs/DJ Okawari - Flower Dance.mp3", "stream"),
              audio:newSource("songs/Goukisan - Betrayal Of Fate.mp3", "stream"),
              audio:newSource("songs/TMM43 - Ultimate Destruction.mp3", "stream"),
              audio:newSource("songs/kors k - Erehamonika.mp3", "stream")}

local levelIndex
local timer
local menuSelected
local gameBG

function maingame:load()

  pauseLogoButton = newSquareButton(gw / 2-330-15, gh / 2 - 130, 180, "Paused", "", true, Lavender, White, 0, -34)
  pauseContinueButton = newSquareButton(gw / 2-100, gh / 2 + 85, 150, "Continue", "", false, Green, White, 0, -23, function() maingame:pause() end)
  pauseRestartButton = newSquareButton(gw / 2+130, gh / 2 - 85, 150, "Restart", "", false, Blue, White, 0, -23, function() maingame:restart() end)
  pauseQuitButton = newSquareButton(gw / 2+360, gh / 2 + 85, 150, "Quit", "", false, Red, White, 0, -23, function() maingame:endLevel() end)

  gameBG = love.graphics.newImage("assets/level1bg.jpg")
  player:load()
  failsound = audio:newSource("assets/failsound.wav", "stream")
  failsound:setVolume(volumeValue * 0.001)
  levelIndex = 2
  timer = 0
  menuSelected = 1
end

function maingame:update(dt)
  if not (isPause) then
    player:update(dt)
  end
end

function maingame:draw()
  love.graphics.setColor(White)
  love.graphics.draw(gameBG, 0, 0)
  love.graphics.setColor(0, 0, 0, 0.25)
  love.graphics.rectangle('fill', 0, 0, gw, gh)
  love.graphics.setColor(Dark)
  love.graphics.circle("fill", gw/2, gh/2, 500)
  love.graphics.setColor(White)
  love.graphics.setLineWidth(9)
  love.graphics.circle("line", gw/2, gh/2, 500)
  love.graphics.circle("fill", gw/2, gh/2, 50)
  love.graphics.circle("line", gw/2, gh/2, 50)
  love.graphics.line(gw/2-500, gh/2, gw/2+500, gh/2)

  love.graphics.setColor(Player1Color)
  love.graphics.circle("fill", 520, gh/2, 30)
  love.graphics.setColor(White)
  love.graphics.circle("line", 520, gh/2, 30)

  love.graphics.setColor(Player2Color)
  love.graphics.arc("fill", 600, gh/2, 30, 0, math.pi)
  love.graphics.setColor(White)
  love.graphics.arc("line", 600, gh/2, 30, 0, math.pi)

  love.graphics.setColor(Player2Color)
  love.graphics.arc("fill", 1100, gh/2, 30, math.pi, 2*math.pi)
  love.graphics.setColor(White)
  love.graphics.arc("line", 1100, gh/2, 30, math.pi, 2*math.pi)

  player:draw()

  if (isPause) then
    maingame:pauseScreen()
  end
end

function maingame:mousepressed(x, y, button)
  pauseContinueButton:mousepressed(x, y, button)
  pauseRestartButton:mousepressed(x, y, button)
  pauseQuitButton:mousepressed(x, y, button)
end

function maingame:pauseBaseLayout(color)
  love.graphics.setColor(0, 0, 0, 0.6)
  love.graphics.rectangle("fill", 0, 0, gw, gh)
  love.graphics.setColor(color)
  love.graphics.circle("fill", gw/2, gh/2, 400, 4)
  love.graphics.setColor(White)
  love.graphics.setLineWidth(15)
  love.graphics.circle("line", gw/2, gh/2, 400, 4)
  love.graphics.line(gw/2-50, 300,
                     gw/2, 250,
                     gw/2+50, 300)
  love.graphics.line(gw/2-50, gh-300,
                     gw/2, gh-250,
                     gw/2+50, gh-300)
end

function maingame:pauseScreen()
  love.graphics.setColor(0, 0, 0, 0.55)
  love.graphics.rectangle('fill', 0, 0, gw, gh)
  pauseLogoButton:draw()
  pauseContinueButton:draw()
  pauseRestartButton:draw()
  pauseQuitButton:draw()
end

function maingame:gamepadpressed(joystick, button)
  if (button == "start" or button == "back") then
    maingame:pause()
  end
  if (isPause) then
    restartButton:gamepadpressed(joystick, button)
    exitButton:gamepadpressed(joystick, button)
  end
end

function maingame:keypressed(key)
  if (key == "escape") then
    maingame:pause()
  end
end

function maingame:loadLevel(index)
  levelIndex = index
  gamemusic = levelSongs[levelIndex]
  gamemusic:setVolume(volumeValue * 0.001)
  gamemusic:setLooping(true)
  maingame:restart()
end

function maingame:pause()
  isPause = not isPause
  menuSelected = 1
end

function maingame:restart()
  timer = 0
  isPause = false
  --gamemusic:play()
  levelmanager:loadLevel(levelIndex)
end

function maingame:endLevel()
  statemanager:changeState("menu")
  --gamemusic:stop()
  menumusic:play()
end


function maingame:getSong()
  if (levelIndex == 1) then
    return "Flower Dance"
  elseif (levelIndex == 2) then
    return "Explorers"
  elseif (levelIndex == 3) then
    return "Ultimate Destruction"
  elseif (levelIndex == 4) then
    return "Lunar Abyss"
  elseif (levelIndex == 5) then
    return "Der Wald"
  elseif (levelIndex == 6) then
    return "Sines of Respect"
  end
end


return maingame
