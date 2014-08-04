local hero
local inv = {}
local facing = 0

function loadCharacter()
	local img = love.graphics.newImage("assets/herowalk.png")
   	local wAnim = newAnimation(img, 64, 128, 0.1, 3)
   	wAnim:setMode("loop")
   	wAnim:stop()
	hero = { x = 144, y = 144, speed = 100, health = 100, inventory = inv, equipped = nil, sprite=lg.newImage("assets/hero.png"), walk = wAnim}
	loadLv1Sword()
	loadBow()
	addToInventory("Lv1Sword")
	addToInventory("Bow")
end

function getFacing()
	-- getter
	return facing
end

function transitionCharacter(x, y)
	hero.x = x
	hero.y = y
end

function mouseMoveCharacter(dt, x, y)
	local tempx = hero.x
	local tempy = hero.y
	local moveX  = ""
	local moveY = ""
	local tempFace = 0

	if (math.abs(x) > 5) then
		if math.abs(x) < 30 then
			modx = 0.3
		else
			modx = 1
		end

		if x > 0 then
			tempx = hero.x + (hero.speed * dt * modx)
			if checkTile(tempx, tempy) then
				hero.x = tempx
				moveX = "left"
				facing = math.pi/2
				tempFace = math.pi/4
			end
		end
		if x < 0 then 
			tempx = hero.x - (hero.speed * dt * modx)
			if checkTile(tempx, tempy) then
				hero.x = tempx
				moveX = "right"
				facing = -math.pi/2
				tempFace = -math.pi/4
			end
		end
	end

	if(math.abs(y) > 5) then
		if math.abs(y) < 30 then
			mody = 0.3
		else
			mody = 1
		end
		if y > 0 then 
			tempy = hero.y + (hero.speed * dt * mody)
			if checkTile(tempx, tempy) then
				hero.y = tempy
				moveY = "up"
				facing = math.pi
				tempFace = -tempFace
			end
		end
		if y < 0 then 
			tempy = hero.y - (hero.speed * dt * mody)
			if checkTile(tempx, tempy) then
				hero.y = tempy
				moveY = "down"
				facing = 0
			end
		end 
	end

	if moveX ~= "" and moveY ~= "" then
		facing = facing + tempFace
	end

	if moveX ~= "" or moveY ~= "" then
		hero.walk:play()
	else
		hero.walk:seek(3)
		hero.walk:stop()
	end

	mouseMoveMap(dt, x, y, moveX, moveY)
end

function getSize()
	-- getter
	return (hero.sprite):getWidth(), (hero.sprite):getHeight()
end

function getLocation()
	-- getter
	return hero.x, hero.y
end

function getSpeed()
	--body
	return hero.speed
end

function changeSpeed(change)
	-- adds 'change' to the hero's speed
	-- if change is negative, hero loses speed
	hero.speed = hero.speed + change
end

function changeHealth(change)
	-- adds 'change' to the hero's health
	-- if change is negative, hero loses health
	hero.health = hero.health + change
	if change < 0 then
		hero.x = hero.x - 30
		shiftMap(-15, 0)
		--hero.y = hero.y - 10
		-- push the hero back a bit
	end
end

function getEquipped()
	-- getter
	return hero.equipped
end

function getHealth()
	--body
	return hero.health
end

function addToInventory(item)
	--body
	hero.inventory[(#hero.inventory)+1] = item
end

function drawInventory()
	--body
	for i=1, #hero.inventory do
		print(hero.inventory[i])
	end
end

function moveCharacter(dt, x, y)
	local tempx = hero.x
	local tempy = hero.y
	local moveX = ""
	local moveY = ""
	local tempFace = 0

	updateWalk(dt)

	if lm.isDown("l") then
		mouseMoveCharacter(dt, x, y)
		--useItem(equipped, hero.x, hero.y)
		return
	end

	if lk.isDown("left") then
		tempx = hero.x - (hero.speed * dt)
		if checkTile(tempx, tempy) then
			hero.x = tempx
			moveX = "left"
			facing = -math.pi/2
			tempFace = -math.pi/4
		end
	elseif lk.isDown("right") then
		tempx = hero.x + (hero.speed * dt)
		if checkTile(tempx, tempy) then
			hero.x = tempx
			moveX = "right"
			facing = math.pi/2
			tempFace = math.pi/4
		end
	end
	
	if lk.isDown("up") then
		tempy = hero.y - (hero.speed * dt)
		if checkTile(tempx, tempy) then
			hero.y = tempy
			moveY = "up"
			facing = 0
		end	
	elseif lk.isDown("down") then
		tempy = hero.y + (hero.speed * dt)
		if checkTile(tempx, tempy) then
			hero.y = tempy
			moveY = "down"
			facing = math.pi
			tempFace = -tempFace
		end	
	end

	if moveX ~= "" and moveY ~= "" then
		facing = facing + tempFace
	end

	if moveX ~= "" or moveY ~= "" then
		hero.walk:play()
	else
		hero.walk:seek(3)
		hero.walk:stop()
	end

	moveMap(dt, moveX, moveY)
end

function drawWalk(x, y)
	-- draw
	hero.walk:draw(x, y, facing, 1, 1, hero.walk:getWidth()/2, hero.walk:getHeight()/4)
end

function updateWalk(dt)
	-- update
	hero.walk:update(dt)
end

function equipItem(item)
	-- adds item to hero's equipped slot
	if hero.inventory[1] ~= nil and
		hero.equipped ~= item then
		print("equipping " .. item)
		hero.equipped = item
	end
end

function drawCharacter(characters)
	-- draw character
	lg.draw(hero.sprite, hero.x, hero.y, facing, 1, 1, hero.sprite:getWidth()/2, hero.sprite:getHeight()/2)
	--if ()
		drawWalk(hero.x, hero.y)
end

function drawEquipped()
	if hero.equipped ~= nil then
		-- later change the x and y to like, a hand
		drawItem(hero.equipped, lg.getWidth() - 45, 25)
	end
end
