require 'lib/simpleScale'

require 'globals'
require 'colors'

require 'objects/cursor'

require 'managers/statemanager'
require 'managers/savemanager'

local discordRPC = require 'lib/discordRPC'
local appId = require 'applicationId'

function love.load()
  savemanager:load()
  cursor:load()
  volumeValue = savemanager.settings.volume or 100
  resolutionIndex = savemanager.settings.resolutionIndex or 8
  statemanager:load()
  if resolutionList[resolutionIndex][1] == 0 and resolutionList[resolutionIndex][2] == 0 then
    isFullScreen = true
  else
    isFullScreen = false
  end
  simpleScale.setWindow(gw, gh, resolutionList[resolutionIndex][1], resolutionList[resolutionIndex][2], {fullscreen = isFullScreen})
  mx = love.mouse.getX() / simpleScale.getScale()
  my = love.mouse.getY() / simpleScale.getScale()
  love.window.setVSync(0)
  love.mouse.setVisible(false)

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
  simpleScale.unSet()
end

function love.mousepressed(x, y, button)
  statemanager:mousepressed(x, y, button)
end

function love.keypressed(key)
  statemanager:keypressed(key)
end

function love.quit()
  discordRPC.shutdown()
end
