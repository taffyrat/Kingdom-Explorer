require('core/map')
require('core/item')
require("core/projectiles")
require("core/drops")
require("core/destructable")
require('characters/hero')
require('characters/mob')
require('characters/characters')
require('ui/hud')
require("libraries/AnAL")
require("libraries/functions")
require("libraries/androidFunctions")

local diffX, diffY = 0, 0

function setVariables()
	lk = love.keyboard
	lw = love.window
	lg = love.graphics
	lm = love.mouse
	lf = love.filesystem
	
	mapX, mapY = 0, 0
	maps = {'coredump', 'chez-peter', 'map1', 'map2'}
	
	heroTable = {}
	projectiles = {}
	mobTable = {}
	dropsTable = {}
	destructsTable = {}
end

function love.load()
	setVariables()
	loadMap('/maps/' .. maps[4] .. '.lua')
	loadHero()
	loadOverlay(hero)
	scaleH = lg.getHeight() / (32 * 18)
	scaleW = lg.getWidth() / (32 * 25)
end

function love.update(dt)
	diffX, diffY = updateOverlay(dt)
	updateCharacters(dt, diffX, diffY)
	updateEquippedItem(dt)
	updateProjectiles(dt)
	updateDrops()
	updateDestructables()
	checkCharacters()
end

function love.mousepressed(x, y, button, isTouch)
	if not isTouch then
		if button == "l" then
			if (x < lg.getWidth()/3) then
				controllerPressed(x, y)	
			else
				startSwipe(x, y) 
			end
		end

		if button == "r" then
			print(lm.getPosition())
		end
	end
end

function love.mousereleased(x, y, button, isTouch)
	if not isTouch then
		if button == "l" then

			if (x < lg.getWidth()/3) then
				controllerReleased() 
			else
				endSwipe(x, y)
			end
			
		end
	end
end

function love.resize(w, h)
	scaleH = (lg.getHeight() / (32 * 18))
	scaleW = (lg.getWidth() / (32 * 25))
	-- also resize whatever it is you're using for the map scroll limits
	resizeMap()
	resizeOverlay(w, h)
end

function love.draw()
	lg.push()
		lg.scale(scaleW, scaleH)
		lg.translate(mapX, mapY)
		lg.push()
			drawMap(currentMap)
			drawCharacters()
			drawDestructables()
			drawDrops()
			drawProjectiles()
		lg.pop()	
	lg.pop()	

	drawOverlay()
	drawEquipped()
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end
