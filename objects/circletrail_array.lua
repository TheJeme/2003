circletrail = require 'objects/circletrail'

local circletrail_array = {}

function circletrail_array:draw()
	for i = 1, #circletrail_array do
		circletrail_array[i]:draw()
	end
end

function circletrail_array:update(dt)
	for i = #circletrail_array, 1, -1 do
		circletrail_array[i]:update(dt)
		if circletrail_array[i].size <= 0 then
			table.remove(circletrail_array, i)
		end
	end
end

return circletrail_array
