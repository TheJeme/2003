playertrail = require 'objects/playertrail'

local playertrail_array = {}

function playertrail_array:draw()
	for i = 1, #playertrail_array do
		playertrail_array[i]:draw()
	end
end

function playertrail_array:update(dt, posX, posY)
	table.insert(playertrail_array, playertrail:new(posX, posY))
	for i = #playertrail_array, 1, -1 do
		playertrail_array[i]:update(dt)
		if playertrail_array[i].size <= 0 then
			table.remove(playertrail_array, i)
		end
	end
end

return playertrail_array
