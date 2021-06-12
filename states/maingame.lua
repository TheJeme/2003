require 'objects/circle'

require 'levels/level01'
require 'levels/level02'
require 'levels/level03'
require 'levels/level04'

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

local levelIndex, timer, nextNote, endTime, levelNotes, isPause, isFailed

function maingame:load()
  pauseLogoButton = newButton(gw / 2-330-15, gh / 2 - 130, 180, "Paused", "", true, Lavender, White, 0, -34)
  pauseContinueButton = newButton(gw / 2-100, gh / 2 + 85, 150, "Continue", "", false, Green, White, 0, -23, function() maingame:pause() end, function() maingame:pause() end)
  pauseProgressButton = newButton(gw / 2-100, gh / 2 + 85, 150, "", "", false, Green, White, 0, -23)
  pauseRestartButton = newButton(gw / 2+130, gh / 2 - 85, 150, "Restart", "", false, Blue, White, 0, -23, function() maingame:restart() end, function() maingame:restart() end)
  pauseQuitButton = newButton(gw / 2+360, gh / 2 + 85, 150, "Quit", "", false, Red, White, 0, -23, function() maingame:endLevel() end, function() maingame:endLevel() end)

  circlehitsound = audio:newSource("assets/circlehit.wav", "stream")
  circlehitsound:setVolume(volumeValue * 0.001)

  failsound = audio:newSource("assets/fail.wav", "stream")
  failsound:setVolume(volumeValue * 0.001)
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
    for i, v in ipairs(levelNotes) do
      if (#levelNotes >= nextNote and (levelNotes[nextNote][3] - 400) * 0.001 < timer) then
        --createCircle(math.random(-10,6)+2, levelNotes[nextNote][2])
        nextNote = nextNote + 1
      end
    end
    if (#listOfCircles == 0) then
      local x = math.random(1,6)
      local x1 = math.random(0,1)
      local x2 = math.random(0,1)
      if (x1 == 0) then
        x = x*-1
      end
      if (x2 == 0) then
        createCircle(x, math.random(850,1700))
      else
        createCircle(x, math.random(-1700,-850))
      end
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
  love.graphics.line(gw/2-500, gh/2, gw/2+500, gh/2)
  love.graphics.setColor(Black)
  love.graphics.circle("fill", gw/2, gh/2, 150)
  love.graphics.setColor(White)
  love.graphics.circle("line", gw/2, gh/2, 150)
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
  pauseProgressButton:setMainText(math.floor(timer/maingame:getLevelLength()*100) .. "%")
  if false then
    pauseProgressButton:setAltText("New highscore")
  else
    pauseProgressButton:setAltText("")
  end
  pauseLogoButton:draw()
  pauseProgressButton:draw()
  pauseRestartButton:draw()
  pauseQuitButton:draw()
end

function maingame:progressBar()
  love.graphics.setColor(0.3, 0.3, 0.3, 1)
  love.graphics.rectangle("fill", 0, gh-10, gw, 10)
  love.graphics.setColor(0.95, 0.95, 0.95, 1)
  love.graphics.rectangle("fill", 0, gh-10, gw*(timer/maingame:getLevelLength()), 10)
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
  if not isFailed then
    if (key == "escape") then
      maingame:pause()
    end
    if (#listOfCircles > 0) then
      if (key == "d" or key == "f") then
        if (math.abs(listOfCircles[1].angle) > math.pi*0.94 and math.abs(listOfCircles[1].angle) < math.pi*1.06 and listOfCircles[1].pos > 0) then
          table.remove(listOfCircles, 1)
          circlehitsound:play()
        elseif (math.abs(listOfCircles[1].angle) > math.pi*0.90 and math.abs(listOfCircles[1].angle) < math.pi*0.94) then
          --maingame:fail()
        end
      elseif (key == "j" or key == "k") then
        if (math.abs(listOfCircles[1].angle) > math.pi*0.94 and math.abs(listOfCircles[1].angle) < math.pi*1.06 and listOfCircles[1].pos < 0) then
          table.remove(listOfCircles, 1)
          circlehitsound:play()
        elseif (math.abs(listOfCircles[1].angle) > math.pi*0.90 and math.abs(listOfCircles[1].angle) < math.pi*0.94) then
          --maingame:fail()
        end
      end
    end
  end
end

function maingame:loadLevel(index)
  math.randomseed(os.time())
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
  listOfCircles = {}
  gamemusic:stop()
  gamemusic:play()
  levelNotes = maingame:getMapNotes()
end

function maingame:endLevel()
  statemanager:changeState("menu")
  gamemusic:stop()
  menumusic:play()
end

function maingame:getMapNotes()
  if (levelIndex == 1) then
    return level01:hitcircles()
  elseif (levelIndex == 2) then
    return level02:hitcircles()
  elseif (levelIndex == 3) then
    return level03:hitcircles()
  elseif (levelIndex == 4) then
    return level04:hitcircles()
  end
end

function maingame:getLevelName()
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

function maingame:getLevelLength()
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
