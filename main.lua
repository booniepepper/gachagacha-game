function love.load()
  love.window.setTitle("GachaGacha - Key masher game for tykes")
  math.randomseed(os.time())
  love.window.setFullscreen(true)
  love.graphics.setBackgroundColor(31/255, 15/255, 31/255)
  love.mouse.setVisible(false)

  local _, _, flags = love.window.getMode()
  width, height = love.window.getDesktopDimensions(flags.display)

  if not love.system.hasBackgroundMusic() then
    -- Play some music
  end

  images = love.filesystem.getDirectoryItems("irasutoya")
  for i = 1, #images do
    images[i] = love.graphics.newImage("irasutoya/" .. images[i])
  end

  imageN = math.random(1, #images)
  rot = 0
  rotFactor = 1
end


function love.update(dt)
  rot = rot + dt * rotFactor
  if rot < -1/2 or 1/2 < rot then
    rot = rot - dt * rotFactor
    rotFactor = -rotFactor
  end
end


function love.keypressed(key)
  -- how 2 quit
  if prevkeys == "qui" and key == "t" then
    love.event.quit(0)
  elseif prevkeys == "qu" and key == "i" then
    prevkeys = "qui"
  elseif prevkeys == "q" and key == "u" then
    prevkeys = "qu"
  elseif key == "q" then
    prevkeys = "q"
  end

  -- animals
  -- TODO: sfx
  if key == "space" then
    imageN = imageN + 1
    if imageN > #images then
      imageN = 1
    end
  end

  -- TODO: letters
end


function love.draw()
  love.graphics.print("Type the full word \"quit\" to quit", 8, 8, 0, 2, 2)

  local image = images[imageN]
  local iwidth = image:getWidth()
  local iheight = image:getHeight()
  love.graphics.draw(image, width/2, height/2, rot, 1, 1, iwidth/2, iheight/2)
end


