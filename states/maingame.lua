require 'managers/levelmanager'
require 'objects/circle'

local audio = require "lib/wave"

maingame = {}

levelSongs = {audio:newSource("songs/DJ Okawari - Flower Dance.mp3", "stream"),
              audio:newSource("songs/Goukisan - Betrayal Of Fate.mp3", "stream"),
              audio:newSource("songs/Goukisan - Betrayal Of Fear.mp3", "stream"),
              audio:newSource("songs/kors k - Erehamonika.mp3", "stream")}

levelBGs = {love.graphics.newImage("assets/level1bg.jpg"),
              love.graphics.newImage("assets/level2bg.jpg"),
              love.graphics.newImage("assets/level3bg.jpg"),
              love.graphics.newImage("assets/level4bg.jpg")}

local levelIndex, timer, nextNote, endTime, mapNotes, isPause, isFailed

function maingame:load()
  pauseLogoButton = newSquareButton(gw / 2-330-15, gh / 2 - 130, 180, "Paused", "", true, Lavender, White, 0, -34)
  pauseContinueButton = newSquareButton(gw / 2-100, gh / 2 + 85, 150, "Continue", "", false, Green, White, 0, -23, function() maingame:pause() end)
  pauseRestartButton = newSquareButton(gw / 2+130, gh / 2 - 85, 150, "Restart", "", false, Blue, White, 0, -23, function() maingame:restart() end)
  pauseQuitButton = newSquareButton(gw / 2+360, gh / 2 + 85, 150, "Quit", "", false, Red, White, 0, -23, function() maingame:endLevel() end)

  failsound = audio:newSource("assets/failsound.wav", "stream")
  failsound:setVolume(volumeValue * 0.001)
end

function maingame:update(dt)
  if not isPause and not isFailed then
    timer = timer + dt
    for i, v in ipairs(mapNotes) do
      if (#mapNotes >= nextNote and (mapNotes[nextNote][5] - 400) * 0.001 < timer) then
        if (mapNotes[nextNote][4] == 0) then
          createCircle(mapNotes[nextNote][1], mapNotes[nextNote][2])
        end
        nextNote = nextNote + 1
      end
    end
    createCircle(600, 100)
    circle:update(dt)
  end
end

function maingame:draw()
  maingame:LayoutUI()
  circle:draw()
  maingame:progressBar()
  if (isPause) then
    love.mouse.setVisible(true)
    maingame:pauseScreen()
  elseif (isFailed) then
    love.mouse.setVisible(true)
    maingame:failedScreen()
  else
    love.mouse.setVisible(false)
  end
end

function maingame:LayoutUI()
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
end

function maingame:mousepressed(x, y, button)
  pauseContinueButton:mousepressed(x, y, button)
  pauseRestartButton:mousepressed(x, y, button)
  pauseQuitButton:mousepressed(x, y, button)
end

function maingame:pauseScreen()
  love.graphics.setColor(0, 0, 0, 0.55)
  love.graphics.rectangle('fill', 0, 0, gw, gh)
  pauseLogoButton:draw()
  pauseContinueButton:draw()
  pauseRestartButton:draw()
  pauseQuitButton:draw()
end

function maingame:failedScreen()
  love.graphics.setColor(0, 0, 0, 0.55)
  love.graphics.rectangle('fill', 0, 0, gw, gh)
  pauseLogoButton:draw()
  pauseRestartButton:draw()
  pauseQuitButton:draw()
end

function maingame:progressBar()
  love.graphics.setColor(0.3, 0.3, 0.3, 1)
  love.graphics.rectangle("fill", 0, gh-10, gw, 10)
  love.graphics.setColor(0.95, 0.95, 0.95, 1)
  love.graphics.rectangle("fill", 0, gh-10, gw*(timer/maingame:getSongLength()), 10)
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
  maingame:restart()
  gameBG = levelBGs[levelIndex]
end

function maingame:pause()
  isPause = not isPause
  if (isPause) then
    gamemusic:pause()
  else
    gamemusic:play()
  end
end

function maingame:fail()
  isFailed = true
  gamemusic:stop()
end

function maingame:restart()
  timer = 0
  isPause = false
  isFailed = false
  nextNote = 1
  endTime = 0
  mapNotes = {}
  gamemusic:play()
  --mapNotes = mapManager.getNotesOfIndex(mapList.getSelectedMapIndex())
  --levelmanager:loadLevel(levelIndex)
end

function maingame:endLevel()
  statemanager:changeState("menu")
  gamemusic:stop()
  menumusic:play()
end


function maingame:getSong()
  if (levelIndex == 1) then
    return "Super"
  elseif (levelIndex == 2) then
    return "Hyper"
  elseif (levelIndex == 3) then
    return "Ultra"
  elseif (levelIndex == 4) then
    return "Extreme"
  end
end

function maingame:getSongLength()
  if (levelIndex == 1) then
    return 263
  elseif (levelIndex == 2) then
    return 174
  elseif (levelIndex == 3) then
    return 275
  elseif (levelIndex == 4) then
    return 123
  end
end


return maingame
