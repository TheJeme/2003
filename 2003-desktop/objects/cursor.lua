cursor = {}

function cursor:load()
  cursor_img = love.graphics.newImage("assets/cursor.png")
end

function cursor:draw()
  love.graphics.draw(cursor_img, mx, my)
end

return cursor
