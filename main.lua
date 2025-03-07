local push = require "libs.push"
Object = require "libs.classic"

local gameWidth, gameHeight = 800, 800
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*0.7,windowHeight*0.7

local mapWidth, mapHeight = 2000, 2000

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

function love.load()
	-- set rendering to be good for pixel art
	love.graphics.setDefaultFilter("nearest","nearest")
	require "libs.spaceship"
	
	spaceship = Spaceship(160, 0)
	
	-- we can move the camera with mouse movement
	camera_x, camera_y = 0, 0
	camera_speed = 300
	mouse_margin = 100
	
	love.graphics.setLineWidth(2)
	love.graphics.setLineStyle("rough")
	
	-- set up input
	keys_pressed = {}
	
end

function love.keypressed(a,b)
	keys_pressed[a] = true
end

function love.keyreleased(a)
	keys_pressed[a] = nil
end

function love.update(dt)
	local x, y = love.mouse.getPosition()
	if x < mouse_margin and x > 0 then
		camera_x = camera_x + camera_speed * dt
	elseif (x < windowWidth) and (x > windowWidth - mouse_margin + 1) then
		camera_x = camera_x - camera_speed * dt
	end
	
	if y < mouse_margin and y > 0 then
		camera_y = camera_y + camera_speed * dt
	elseif y > windowHeight - mouse_margin + 1 then
		camera_y = camera_y - camera_speed * dt
	end

	spaceship.isMoving = false
	
	-- This sucks. How can it be better?
	if keys_pressed["right"] and keys_pressed["up"] then
		spaceship.rotation = 2
	elseif keys_pressed["left"] and keys_pressed["up"] then
		spaceship.rotation = 4
	elseif keys_pressed["left"] and keys_pressed["down"] then
		spaceship.rotation = 6
	elseif keys_pressed["right"] and keys_pressed["down"] then
		spaceship.rotation = 8
	elseif keys_pressed["right"] then
		spaceship.rotation = 1
	elseif keys_pressed["up"] then
		spaceship.rotation = 3
	elseif keys_pressed["left"] then
		spaceship.rotation = 5
	elseif keys_pressed["down"] then
		spaceship.rotation = 7
	end
	spaceship:update(dt)
end

function love.draw()
	-- new approach: draw the entire grid non-isometrically. this includes
	-- all the non-tile objects (like the ship)
	-- then, rotate everything by 45 degrees and scale everything by y = 0.5
	push:start()
	
	love.graphics.translate(camera_x, camera_y)
	love.graphics.push()
	--love.graphics.translate(gameWidth/2, gameHeight/2)
	love.graphics.scale(1, 0.5)
	love.graphics.rotate(math.rad(45))
	draw_grid()
	
	spaceship:draw()
	love.graphics.pop()
	
	push:finish()
end

function draw_grid()
	-- draw a normal size grid
	love.graphics.push()
	love.graphics.setColor( 0, 1, 1, 0.5 )
	
	for i=0,(mapWidth/80) do
		for j=0,(mapHeight/80) do
			love.graphics.push()
			love.graphics.translate(80 * i, 80 * j)
			love.graphics.translate(-40, -40)
			love.graphics.rectangle("line", 0, 0, 80, 80)
			love.graphics.pop()
		end
	end
	love.graphics.translate(0, -mapHeight / 2)
	love.graphics.setColor( 1, 1, 1, 1 )
	love.graphics.pop()
end
