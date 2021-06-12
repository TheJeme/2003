local circletrail = {}

function circletrail:new(x, y)
	local p = {}
	self.__index = self
	p.x = x
	p.y = y
	p.size = 24
	p.alpha = 1
	return setmetatable(p, circletrail)
end

function circletrail:update(dt)
	self.size = self.size - 5 * dt
	self.alpha = self.alpha - 11 * dt
end

function circletrail:draw()
	love.graphics.setColor(9 / 255, 132 / 255, 227 / 255, self.alpha)
	love.graphics.circle('fill', self.x, self.y, self.size)
end

return circletrail
