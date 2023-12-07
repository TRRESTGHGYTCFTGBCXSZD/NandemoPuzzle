--[[
Puzzlow - Ochige-Yarouze Emulator Created by GerioSB

0529d ~ 052ac - Block Appearing Probability
0529c - TL;DR Magical Drop-Like Reaction (active low), Blocks Only React When Moved By Gravity, Locked Block Pair, Not Blocks Only React By Directly Contacting
05290 - Adjacent Block will react Reacting Blocks (active high)
!0541d - Is Solid "Blocks" Sticky (active high)
0541d - Is Solid "Blocks" Sticky (active high)
052f8 - Whatever Every Piece is Unique "Blocks" (active high)

0541d - Is Solid "Blocks" Sticky (active high)

Nothing to do with this tab "Files"

Nothing to do with this tab "Test"

Nothing to do with this tab "Options"

052e4 - Win/Lose Language (english if high)
!0541d - Contiune Language (english if high) (will be used as mode selection language, as this will make harder to read)
!0541d - Start Language (english if high)
!0541d - Paused Language (english if high)

0226c ~ 02d6b - Palette Data
07f78 ~ 1df77 - Sprite Data

0541d - Is Solid "Blocks" Sticky (active high)
--]]
function love.load()
	frames = 0
	frameticks = 0
	
	move = 0
	moveuuu = false
	moveddd = false
	
	coins = 0
	coindexter = 0
	bit32 = require("bit")
	GerioVOX = require("data.sfx.misc.VOX")
	love.graphics.setBackgroundColor(0, 0, 0, 0)
	
	colorswap = {}
  colorswap.shader = love.graphics.newShader( -- load the shader
  [[
    //Fragment shader
    uniform sampler2D ColorTable; // 1 x 16 pixels
    uniform sampler2D MyIndexTexture;
    varying vec2 TexCoord0;

    vec4 effect( vec4 color, Image MyIndexTexture, vec2 TexCoord0, vec2 screen_coords ){
    	//What color do we want to index?
    	vec4 myindex = texture2D(MyIndexTexture, TexCoord0);
    	//Do a dependency texture read
    	vec4 texel = texture2D(ColorTable, myindex.xy);
    	return texel;   //Output the color
    }
  ]] )
	
	globalfont = love.graphics.newFont( "paz.otf" ,16 )
	--globalwafont = love.graphics.newFont( "paz.otf" ,16 )
	--globalwafont = love.graphics.newImageFont( "wario.png", "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよヵヶらりるれろがぎぐげござじずぜぞだぢづでばびぶべぼぱぴぷぺぽわをんゔゎぁぃぅぇぉゃぃゃゅょっゑゐ단단/단단단단.ｅ<>&■ アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤヰユヱヨラリルレロガギグゲゴザジズゼゾダヂヅデバビブベボパピプペポヮァィゥェォャィャュョッヵヶワンヴヲ,             ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890~-!?()、。·:;'\"ÁÀÂÄÃÅßĆ단Ĉ단ÉÈÊË단ÍÌÎÏÑÓÒÔÖáàâäãåᵃć단ĉ단çéèêë단단단íìîïñóòŒÚÙÛÜ«»단ôöœ°úùûü¡¿     ", -6 )
	globalwafont = love.graphics.newImageFont( "wario_english.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890~-!?()、。·:;'\"" )
	--esafafa = love.graphics.newText( globalwafont, "このフォントの使用に関してはすべて無保証とさせていただきます" )
	esafafa = love.graphics.newText( globalwafont, "sfbsbghslbjsdfbglshbhsfblfkgbkj" )
	statbartopleft = love.graphics.newText( globalfont, "INSERT COIN" )
	statbartopcent = love.graphics.newText( globalfont, "HI 0" )
	statbartopright = love.graphics.newText( globalfont, "PUSH START" )
	
	statbarbotleft = love.graphics.newText( globalfont )
	statbarbotcent = love.graphics.newText( globalfont, "CREDITS 99" )
	statbarbotright = love.graphics.newText( globalfont )
	
	bg = love.graphics.newImage("background.png")
	coined = GerioVOX(love.filesystem.read("data/sfx/misc/n03.rom25"),1000000,1)
	selectionselect = love.audio.newSource("data/sfx/misc/selectionselect.wav", "static")
	selectiondecide = love.audio.newSource("data/sfx/misc/selectiondecide.wav", "static")
	
	palette = {}
	local gamecard = assert(love.filesystem.read("game.mcr"))
	local address = (0x226c) --dummy read for alignment
	for rr = 0,63 do
		palette[rr] = {}
		for ra = 0,15 do
			shitbyteb = string.byte(string.sub(gamecard,address+1,address+1))
			address = address + 1
			shitbytea = string.byte(string.sub(gamecard,address+1,address+1))
			address = address + 1
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
	numberOfPalettes = 0
	paletteData = love.image.newImageData(16,65)
	for gon = 0,15 do
		paletteData:setPixel(gon, 0, gon/16, gon/16, gon/16, gon == 0 and 0 or 1)
	end
	for pa = 0,63 do
		for gon = 0,15 do
			dizur = palette[pa][gon]["red"]
			dizug = palette[pa][gon]["green"]
			dizub = palette[pa][gon]["blue"]
			paletteData:setPixel(gon, pa+1, dizur, dizug, dizub, gon == 0 and 0 or 1)
		end
	end
	honjitsu = love.graphics.newImage(paletteData)
	coordinates = {}
	for x = 1, paletteData:getWidth() do
		local r, g, b, a = paletteData:getPixel(x - 1, 0)
		table.insert(coordinates, {x = r*255, y = g*255})
	end

	palettes = {}
	for y = 1, paletteData:getHeight() do
		numberOfPalettes = numberOfPalettes + 1
		local canvas = love.graphics.newCanvas(256, 256)
		local canvasData = canvas:newImageData()
		for x = 1, paletteData:getWidth() do
			local cx, cy = coordinates[x].x, coordinates[x].y
			local r, g, b, a = paletteData:getPixel(x - 1, y - 1)
			canvasData:setPixel(cx, cy, r, g, b, a)
		end
		local result = love.graphics.newImage(canvasData)
		result:setFilter( 'nearest' )
		table.insert(palettes, result)
	end
	colorswap.palette = 7
	colorswap.shader:send( "ColorTable", palettes[colorswap.palette] )
	
	--if iscorrectsize ~= 128*1024 then error("Woah wait... Are you put the correct size of memory card? This is not right size.",0) end
	brueh = love.image.newImageData(256,768+16)
	local address = (0x7f78) --dummy read for alignment
	for ar = 0,15 do
		brueh:setPixel(ar, 0, ar/16, ar/16, ar/16, ar == 0 and 0 or 1)
	end
	for rb = 0,47 do
		for rg = 0,15 do
			for rr = 0,15 do
				for ra = 0,14,2 do
					shitbyte = string.byte(string.sub(gamecard,address+1,address+1))
					address = address + 1
					rightnibble = bit32.band(shitbyte,0xf0)
					rightnibble = bit32.rshift(shitbyte,4)
					leftnibble = bit32.band(shitbyte,0x0f)
					--error(brightness)
					brueh:setPixel((rr*16)+ra, (rb*16)+rg+16, leftnibble/16, leftnibble/16, leftnibble/16, leftnibble == 0 and 0 or 1)
					brueh:setPixel((rr*16)+ra+1, (rb*16)+rg+16, rightnibble/16, rightnibble/16, rightnibble/16, rightnibble == 0 and 0 or 1)
				end
			end
		end
	end
	spural = love.graphics.newImage(brueh)
	spural:setFilter("linear", "nearest")
	renderstage = love.graphics.newCanvas(768,512)
end
function love.keypressed(key, scancode, isrepeat)
	if key == "up" then
		moveuuu=true
	end
	if key == "down" then
		moveddd=true
	end
	if key == "5" then
		coindexter=coindexter+1
	end
	if key == "6" then
		coindexter=coindexter+1
	end
	if key == "9" then
		coindexter=coindexter+1
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
		if moveuuu then 
			move = move + 1
			--love.audio.stop(selectionselect)
			--love.audio.play(selectionselect)
		end
		if moveddd then
			move = move - 1
			--love.audio.stop(selectionselect)
			--love.audio.play(selectionselect)
		end
		if coindexter >= 1 then
			coins = coins + coindexter
			coindexter = 0 
			coined:Play(0x01795C*2,0x018292*2,4,false,nil)
		end
		frames = frames - 1
		local drooow = ""
		if coins > 1 then
		drooow = "CREDITS "
		else
		drooow = "CREDIT "
		end
		if coins <= 9 then
		drooow = drooow .. "0" .. coins
		else
		drooow = drooow .. coins
		end
		statbarbotcent:set(drooow)
	end
	coined:Update()
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
    love.graphics.setCanvas(renderstage)
	love.graphics.setColor(1,1,1)
	love.graphics.draw(bg, 0, 16)
	love.graphics.setShader(colorswap.shader)
	drawsprite(spural,0,move,0,0,2,2)
	love.graphics.setShader()
	drawsprite(spural,512,move,0,0,2,2)
	--love.graphics.captureScreenshot("fuckfuckfuck.png")
	--bg = love.graphics.newImage("fuckfuckfuck.png")
	
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0, 0, 768, 16)
	love.graphics.rectangle("fill", 0, 480+16, 768, 16)
	
	love.graphics.setColor(1,.75,0)
	drawsprite(statbartopleft,160,8,statbartopleft:getWidth()/2,8,1,1)
	drawsprite(statbartopcent,384,8,statbartopcent:getWidth()/2,8,1,1)
	drawsprite(statbartopright,608,8,statbartopright:getWidth()/2,8,1,1)
	
	drawsprite(statbarbotleft,160,504,statbarbotleft:getWidth()/2,8,1,1)
	drawsprite(statbarbotcent,384,504,statbarbotcent:getWidth()/2,8,1,1)
	drawsprite(statbarbotright,608,504,statbarbotright:getWidth()/2,8,1,1)
	
	drawsprite(esafafa,20,20,0,0,1,1)
    love.graphics.setCanvas()
	love.graphics.setColor(1,1,1)
	love.graphics.push()
	love.graphics.scale(love.graphics.getWidth( )/768, love.graphics.getHeight( )/512)
	love.graphics.draw(renderstage, 0, 0)
	love.graphics.pop()
end