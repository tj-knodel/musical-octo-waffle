-- Stores the spaceship class
Spaceship = Object:extend()

function Spaceship:new(x, y)
	self.x = x or 0
	self.y = y or 0
	self.rotation = 1
	self.speed = 0
	self.sprite = love.graphics.newImage("assets/spaceship_sprites/e.png")
	self.isMoving = false
	self.isSelected = true
	-- load the image and animations
	local width = self.sprite:getWidth()
	local height = self.sprite:getHeight()
	print(width)
	
	frames = {}
	
	local frame_width = 256
	local frame_height = 144
	
	-- set the origin
	self.origin_x = frame_width / 2
	self.origin_y = frame_height / 2
	
	-- load sprite renders
	table.insert(frames, love.graphics.newImage("assets/spaceship_sprites/e.png"))
	table.insert(frames, love.graphics.newImage("assets/spaceship_sprites/ne.png"))
	table.insert(frames, love.graphics.newImage("assets/spaceship_sprites/n.png"))
	table.insert(frames, love.graphics.newImage("assets/spaceship_sprites/nw.png"))
	table.insert(frames, love.graphics.newImage("assets/spaceship_sprites/w.png"))
	table.insert(frames, love.graphics.newImage("assets/spaceship_sprites/sw.png"))
	table.insert(frames, love.graphics.newImage("assets/spaceship_sprites/s.png"))
	table.insert(frames, love.graphics.newImage("assets/spaceship_sprites/se.png"))

end

function Spaceship:update(dt)
	if self.rotation < 1 then
		self.rotation = 8
	end
	if self.rotation > 8 then
		self.rotation = 1
	end
	--print("Rotation: " .. self.rotation)
end

function Spaceship:draw()
	
	if self.isSelected then
		draw_selected(self.x, self.y)
	end
	love.graphics.push()
	love.graphics.translate(self.x,self.y)
	love.graphics.rotate(math.rad(-45))
	love.graphics.scale(1, 2)
	love.graphics.draw(frames[math.floor(self.rotation)],
						0, 0,
						0,
						1, 1,
						self.origin_x, self.origin_y)
	love.graphics.pop()
end

-- draw an isometric grid square around the object
function draw_selected(x, y)
	love.graphics.push()
	love.graphics.setColor( 0, 100/255, 200/255 )
	love.graphics.translate(x, y)
	-- math.rad(35.264)
	-- This works for now? Figure out how to generate a ton of squares
	--love.graphics.scale(1, 0.5)
	--love.graphics.rotate(math.rad(45))
	love.graphics.translate(-40, -40)
	love.graphics.rectangle("line", 0, 0, 80, 80)
	love.graphics.setColor( 1, 1, 1 )
	love.graphics.pop()
end