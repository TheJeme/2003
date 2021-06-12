require 'managers/levelmanager'
require 'objects/circle'
local audio = require "lib/wave"

maingame = {}

levelSongs = {love.audio.newSource("songs/DJ Okawari - Flower Dance.mp3", "stream"),
              love.audio.newSource("songs/Goukisan - Betrayal Of Fate.mp3", "stream"),
              love.audio.newSource("songs/Goukisan - Betrayal Of Fear.mp3", "stream"),
              love.audio.newSource("songs/kors k - Erehamonika.mp3", "stream")}

levelBGs = {love.graphics.newImage("assets/level1bg.jpg"),
              love.graphics.newImage("assets/level2bg.jpg"),
              love.graphics.newImage("assets/level3bg.jpg"),
              love.graphics.newImage("assets/level4bg.jpg")}

local levelIndex, timer, nextNote, endTime, mapNotes, isPause, isFailed

function maingame:load()
  pauseLogoButton = newButton(gw / 2-330-15, gh / 2 - 130, 180, "Paused", "", true, Lavender, White, 0, -34)
  pauseContinueButton = newButton(gw / 2-100, gh / 2 + 85, 150, "Continue", "", false, Green, White, 0, -23, function() maingame:pause() end, function() maingame:pause() end)
  pauseRestartButton = newButton(gw / 2+130, gh / 2 - 85, 150, "Restart", "", false, Blue, White, 0, -23, function() maingame:restart() end, function() maingame:restart() end)
  pauseQuitButton = newButton(gw / 2+360, gh / 2 + 85, 150, "Quit", "", false, Red, White, 0, -23, function() maingame:endLevel() end, function() maingame:endLevel() end)

  circlehitsound = audio:newSource("assets/circlehit.wav", "stream")
  circlehitsound:setVolume(volumeValue * 0.001)

  failsound = audio:newSource("assets/fail.wav", "stream")
  failsound:setVolume(volumeValue * 0.001)
  timer2 = 999
end

function maingame:update(dt)
  if isPause then
    pauseContinueButton:update(dt)
    pauseRestartButton:update(dt)
    pauseQuitButton:update(dt)
  elseif isFailed then
    pauseRestartButton:update(dt)
    pauseQuitButton:update(dt)
  elseif not isPause and not isFailed then
    timer = timer + dt
    for i, v in ipairs(mapNotes) do
      if (#mapNotes >= nextNote and (mapNotes[nextNote][5] - 400) * 0.001 < timer) then
        if (mapNotes[nextNote][4] == 0) then
          createCircle(mapNotes[nextNote][1], mapNotes[nextNote][2])
        end
        nextNote = nextNote + 1
      end
    end
    if (timer2 > 0.2) then
      createCircle(5, 600)
      timer2 = 0
    else
      timer2 = timer2 + dt
    end
    circle:update(dt)
  end
end

function maingame:draw()
  maingame:LayoutUI()
  circle:draw()
  maingame:progressBar()
  if isFailed then
    love.mouse.setVisible(true)
    maingame:failedScreen()
  elseif isPause then
    love.mouse.setVisible(true)
    maingame:pauseScreen()
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
  if isFailed then
    pauseRestartButton:mousepressed(x, y, button)
    pauseQuitButton:mousepressed(x, y, button)
  elseif isPause then
    pauseContinueButton:mousepressed(x, y, button)
    pauseRestartButton:mousepressed(x, y, button)
    pauseQuitButton:mousepressed(x, y, button)
  end
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
  elseif (key == "d" or key == "f") then
    if (math.abs(listOfCircles[1].angle) > math.pi*0.90 and math.abs(listOfCircles[1].angle) < math.pi*1.10 and listOfCircles[1].pos > 0) then
      table.remove(listOfCircles, 1)
      circlehitsound:play()
    end
  elseif (key == "j" or key == "k") then
    if (math.abs(listOfCircles[1].angle) > math.pi*0.90 and math.abs(listOfCircles[1].angle) < math.pi*1.10 and listOfCircles[1].pos < 0) then
      table.remove(listOfCircles, 1)
      circlehitsound:play()
    end
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
  failsound:play()
end

function maingame:restart()
  timer = 0
  isPause = false
  isFailed = false
  nextNote = 1
  endTime = 0
  --for i, v in ipairs(mapNotes) do
  --  listOfCircles = {}
  --end
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
