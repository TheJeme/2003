local menuparticles = {}
listOfMenuParticles = {}

local cooldown = 0.2

function newMenuParticle()
  local particle = {}
  particle.radius = math.random(45, 100)
  particle.colorA = math.random(300, 500)
  particle.speed = math.random(30, 100)
  particle.x = math.random(gw)
  particle.y = gh + particle.radius

  table.insert(listOfMenuParticles, particle)
end

function menuparticles:update(dt)

   if (cooldown > 0.4) then
     newMenuParticle()
     cooldown = 0
   else
     cooldown = cooldown + dt
   end

  for i, v in ipairs(listOfMenuParticles) do
  v.y = v.y - dt * v.speed
    if (v.radius > 2000) then
      table.remove(listOfMenuParticles, i)
    end
  end
end

function menuparticles:draw()
  for _, v in ipairs(listOfMenuParticles) do
    love.graphics.setColor(100 / 255, 42 / 255, 51 / 255, v.colorA / 1000)
    love.graphics.circle("fill", v.x, v.y, v.radius, 4)
  end
end

function menuparticles:clearParticles()
  for i in pairs(listOfMenuParticles) do
    listOfMenuParticles[i] = nil
  end
end

return menuparticles
