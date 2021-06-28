require 'objects/circle'

local audio = require "lib/wave"

maingame = {}

local levelIndex, timer, notesPassed, isPause, isFailed, isWin

function maingame:load()
  levelSongs = {love.audio.newSource("songs/DJ Okawari - Flower Dance.mp3", "stream"),
                love.audio.newSource("songs/Goukisan - Betrayal Of Fate.mp3", "stream"),
                love.audio.newSource("songs/Goukisan - Betrayal Of Fear.mp3", "stream"),
                love.audio.newSource("songs/kors k - Erehamonika.mp3", "stream")}

  levelBGs = {love.graphics.newImage("assets/level1bg.jpg"),
                love.graphics.newImage("assets/level2bg.jpg"),
                love.graphics.newImage("assets/level3bg.jpg"),
                love.graphics.newImage("assets/level4bg.jpg")}

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
  if not isPause and not isFailed and not isWin then
    timer = timer + dt
    if timer/maingame:getLevelLength() > 1 then
      maingame:win()
    elseif (#listOfCircles == 0 and timer > 0.2) then
      local x
      local speed
      if (levelIndex == 1) then
        if (notesPassed%2==0) then
          x = math.random(2,5)
          speed = 800
        else
          x = math.random(-5,-2)
          speed = -800
        end
        createCircle(x, speed)
      elseif (levelIndex == 2) then
        if (math.random() < 0.5) then
          x = math.random(2,5)
          speed = 900
        else
          x = math.random(-5,-2)
          speed = -900
        end
        createCircle(-x, speed)
      elseif (levelIndex == 3) then
        x = math.random(2,5)
        if (math.random() < 0.5) then
          x = x*-1
        end
        createCircle(x, -1000)
      elseif (levelIndex == 4) then
        x = math.random(3,5)
        if (math.random() < 0.5) then
          x = x*-1
        end
        if (math.random() < 0.5) then
          createCircle(x, 1100)
        else
          createCircle(x, -1100)
        end
      end
    end
    circle:update(dt)
  end
end

function maingame:win()
  isWin = true
  listOfCircles = {}
  pauseLogoButton:setMainText("Win")
  pauseProgressButton:setAltText("Level Complete!")
end

function maingame:draw()
  maingame:LayoutUI()
  circle:draw()
  maingame:progressBar()
  if isWin then
    maingame:winScreen()
  elseif isFailed then
    maingame:failedScreen()
  elseif isPause then
    maingame:pauseScreen()
  end
end

function maingame:LayoutUI()
  love.graphics.setColor(White)
  love.graphics.draw(gameBG, 0, 0)
  love.graphics.setColor(0, 0, 0, 0.25)
  love.graphics.rectangle('fill', 0, 0, gw, gh)
  love.graphics.setColor(Dark)
  love.graphics.setLineWidth(345)
  love.graphics.circle("line", gw/2, gh/2, 325)
  love.graphics.setColor(White)
  love.graphics.setLineWidth(9)
  love.graphics.circle("line", gw/2, gh/2, 500)
  love.graphics.line(gw/2-500, gh/2, gw/2-150, gh/2)
  love.graphics.line(gw/2+150, gh/2, gw/2+500, gh/2)
  love.graphics.setColor(White)
  love.graphics.circle("line", gw/2, gh/2, 150)
end

function maingame:mousepressed(x, y, button)
  if not isFailed and not isPause and not isWin then
    if (#listOfCircles > 0) then
      if (x <= love.graphics.getWidth() / 2) then
        if (math.abs(listOfCircles[1].angle) > math.pi*0.93 and math.abs(listOfCircles[1].angle) < math.pi*1.07 and listOfCircles[1].pos > 0) then
          table.remove(listOfCircles, 1)
          notesPassed = notesPassed + 1
          circlehitsound:play()
        elseif (math.abs(listOfCircles[1].angle) > math.pi*0.84 and math.abs(listOfCircles[1].angle) < math.pi*0.93) then
          maingame:fail()
        end
      elseif (x >= love.graphics.getWidth() / 2) then
        if (math.abs(listOfCircles[1].angle) > math.pi*0.93 and math.abs(listOfCircles[1].angle) < math.pi*1.07 and listOfCircles[1].pos < 0) then
          table.remove(listOfCircles, 1)
          notesPassed = notesPassed + 1
          circlehitsound:play()
        elseif (math.abs(listOfCircles[1].angle) > math.pi*0.84 and math.abs(listOfCircles[1].angle) < math.pi*0.93) then
          maingame:fail()
        end
      end
    end
  elseif isWin then
    pauseRestartButton:mousepressed(x, y, button)
    pauseQuitButton:mousepressed(x, y, button)
  elseif isFailed then
    pauseRestartButton:mousepressed(x, y, button)
    pauseQuitButton:mousepressed(x, y, button)
  elseif isPause then
    pauseContinueButton:mousepressed(x, y, button)
    pauseRestartButton:mousepressed(x, y, button)
    pauseQuitButton:mousepressed(x, y, button)
  end
end

function maingame:keypressed(key)
  if not isFailed and not isWin and not isPause then
    if (key == "escape") then
      maingame:pause()
    end
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
  pauseProgressButton:draw()
  pauseRestartButton:draw()
  pauseQuitButton:draw()
end

function maingame:winScreen()
  love.graphics.setColor(0, 0, 0, 0.55)
  love.graphics.rectangle('fill', 0, 0, gw, gh)
  pauseProgressButton:setMainText(math.floor(timer/maingame:getLevelLength()*100) .. "%")
  pauseLogoButton:draw()
  pauseProgressButton:draw()
  pauseRestartButton:draw()
  pauseQuitButton:draw()
end

function maingame:progressBar()
  love.graphics.setColor(0.3, 0.3, 0.3, 0.3)
  love.graphics.rectangle("fill", 0, gh-10, gw, 10)
  love.graphics.setColor(0.95, 0.95, 0.95, 1)
  love.graphics.rectangle("fill", 0, gh-10, gw*(timer/maingame:getLevelLength()), 10)
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
  pauseLogoButton:setMainText("Paused")
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
  pauseLogoButton:setMainText("Failed")
  pauseProgressButton:setMainText(math.floor(timer/maingame:getLevelLength()*100) .. "%")
end

function maingame:restart()
  timer = 0
  isPause = false
  isFailed = false
  isWin = false
  notesPassed = 0
  listOfCircles = {}
  gamemusic:stop()
  gamemusic:play()
end

function maingame:endLevel()
  statemanager:changeState("menu")
  gamemusic:stop()
  menumusic:play()
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
