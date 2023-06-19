function love.load()
	frames = 0
	frameticks = 0
	move = 0
	moveuuu = false
	moveddd = false
	bit32 = require("bit")
	love.graphics.setBackgroundColor(0, 0, 0, 0)
	bg = love.graphics.newImage("background.png")
	palette = {}
	local gamecard = assert(io.open("game.mcr", "rb"))
	gamecard:read(0x226c) --dummy read for alignment
	for rr = 0,63 do
		palette[rr] = {}
		for ra = 0,15 do
			shitbyteb = string.byte(gamecard:read(1))
			shitbytea = string.byte(gamecard:read(1))
			colored = bit32.lshift(shitbytea,8)
			colored = bit32.bor(colored,shitbyteb)
			red = bit32.band(colored,0x1f)
			green = bit32.rshift(colored,5)
			green = bit32.band(green,0x1f)
			blue = bit32.rshift(colored,10)
			blue = bit32.band(blue,0x1f)
			palette[rr][ra] = {["red"]=red/32,["green"]=green/32,["blue"]=blue/32}
		end
	end
	gamecard:close()
	
	spural = {}
	--if iscorrectsize ~= 128*1024 then error("Woah wait... Are you put the correct size of memory card? This is not right size.",0) end
	for bruuh = 0,63 do
	brueh = love.image.newImageData(256,768)
	local gamecard = assert(io.open("game.mcr", "rb"))
	gamecard:read(0x7f78) --dummy read for alignment
		for rb = 0,47 do
				for rg = 0,15 do
	for rr = 0,15 do
			for ra = 0,14,2 do
					shitbyte = string.byte(gamecard:read(1))
					rightnibble = bit32.band(shitbyte,0xf0)
					rightnibble = bit32.rshift(shitbyte,4)
					leftnibble = bit32.band(shitbyte,0x0f)
					--error(brightness)
					dizur = palette[5][leftnibble]["red"]
					dizug = palette[5][leftnibble]["green"]
					dizub = palette[05][leftnibble]["blue"]
					brueh:setPixel((rr*16)+ra, (rb*16)+rg, dizur, dizug, dizub, leftnibble == 0 and 0 or 255)
					dizur = palette[5][rightnibble]["red"]
					dizug = palette[05][rightnibble]["green"]
					dizub = palette[05][rightnibble]["blue"]
					brueh:setPixel((rr*16)+ra+1, (rb*16)+rg, dizur, dizug, dizub, rightnibble == 0 and 0 or 255)
				end
			end
		end
	end
	spural[bruuh] = love.graphics.newImage(brueh)
	spural[bruuh]:setFilter("linear", "nearest")
	brueh:release()
	gamecard:close()
	end
end
function love.keypressed(key, scancode, isrepeat)
	if key == "up" then
		moveuuu=true
	end
	if key == "down" then
		moveddd=true
	end
end
function love.keyreleased(key)
	if key == "up" then
		moveuuu=false
	end
	if key == "down" then
		moveddd=false
	end
end
function love.update(dt)
frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		if moveuuu then move = move + 1 end
		if moveddd then move = move - 1 end
		frames = frames - 1
	end
end
function drawsprite(image,x,y,cx,cy,sx,sy,rt)
	love.graphics.push()
	love.graphics.translate( x, y)
	love.graphics.rotate(rt or 0)
	love.graphics.scale(sx, sy)
	love.graphics.draw(image or pieceimagetype.G, -cx, -cy)
	love.graphics.pop()
end
function love.draw()
	love.graphics.draw(bg, 0, 0)
	drawsprite(spural[5],64,move,0,0,2,2)
	--love.graphics.captureScreenshot("fuckfuckfuck.png")
	--bg = love.graphics.newImage("fuckfuckfuck.png")
end