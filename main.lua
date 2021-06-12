require 'lib/simpleScale'

require 'globals'
require 'colors'

require 'managers/statemanager'
require 'managers/savemanager'

local discordRPC = require 'lib/discordRPC'
local appId = require 'applicationId'

function love.load()
  savemanager:load()
  volumeValue = savemanager.settings.volume or 100
  resolutionIndex = savemanager.settings.resolutionIndex or 8
  statemanager:load()
  if resolutionList[resolutionIndex][1] == 0 and resolutionList[resolutionIndex][2] == 0 then
    isFullScreen = true
  else
    isFullScreen = false
  end
  simpleScale.setWindow(gw, gh, resolutionList[resolutionIndex][1], resolutionList[resolutionIndex][2], {fullscreen = isFullScreen})
  love.window.setVSync(0)
  joystick = nil

  discordRPC.initialize(appId, true)
  now = os.time(os.date("*t"))
  nextPresenceUpdate = 0
end

function discordApplyPresence()
  if statemanager:getState() == "game" then
    detailsNow = "Playing: " .. maingame:getLevelName()
  else
    detailsNow = "In Mainmenu"
  end
  stateNow = ""
  presence = {
    largeImageKey = "icon",
    largeImageText = "2003",
    details = detailsNow,
    state = stateNow,
    startTimestamp = now,
  }

  return presence
end

function love.update(dt)
  collectgarbage()
  mx = love.mouse.getX() / simpleScale.getScale()
  my = love.mouse.getY() / simpleScale.getScale()

  statemanager:update(dt)

  if nextPresenceUpdate < love.timer.getTime() then
      discordRPC.updatePresence(discordApplyPresence())
      nextPresenceUpdate = love.timer.getTime() + 2.0
  end
  discordRPC.runCallbacks()
end

function love.draw()
	simpleScale.set()
    statemanager:draw()
    if false then
      love.graphics.setLineWidth(2)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.line(gw * 0.5, 0, gw * 0.5, gh)
      love.graphics.line(0, gh * 0.5, gw, gh * 0.5)
      love.graphics.line(love.mouse.getX(), 0, love.mouse.getX(), gh)
      love.graphics.line(0, love.mouse.getY(), gw, love.mouse.getY())
      love.graphics.setFont(defaultFont)
      love.graphics.print("X: " .. string.format("%0.2f", love.mouse.getX() / gw * 100) .. "%", love.mouse.getX() + 10, love.mouse.getY() - 40)
      love.graphics.print("Y: " .. string.format("%0.2f", love.mouse.getY() / gh * 100) .. "%", love.mouse.getX() + 10, love.mouse.getY() - 20)
    end
  simpleScale.unSet()
end

function love.mousepressed(x, y, button)
  statemanager:mousepressed(x, y, button)
end

function love.gamepadpressed(joystick, button)
  statemanager:gamepadpressed(joystick, button)
  if (button == "y" and statemanager:getState() == "menu" and joystick ~= nil) then
    isJoystickMove = not isJoystickMove
    joystickNoticeTextOpacity = 1
  end
end

function love.keypressed(key)
  statemanager:keypressed(key)
  if (key == "y" and statemanager:getState() == "menu" and joystick ~= nil) then
    isJoystickMove = not isJoystickMove
    joystickNoticeTextOpacity = 1
  end
end

function love.joystickadded(jstick)
  joystick = jstick
end

function love.joystickremoved(jstick)
  if (joystick == jstick) then
    joystick = nil
    if (isJoystickMove) then
      isJoystickMove = false
      joystickNoticeTextOpacity = 1
    end
  end
end

function love.quit()
  discordRPC.shutdown()
end
