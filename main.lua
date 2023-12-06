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

  local irasutoya = love.filesystem.getDirectoryItems("irasutoya")
  images = {}
  for i = 1, #irasutoya do
    if irasutoya[i]:sub(-4) == ".png" then
      table.insert(images, love.graphics.newImage("irasutoya/" .. irasutoya[i]))
    end
  end

  animals = {}
  imageN = math.random(1, #images)
  rot = 0
  rotFactor = 1
end


function love.update(dt)
  for i, animal in ipairs(animals) do
    -- wiggle
    local rotf = animal.rotf
    local rot = animal.rot + dt * rotf
    if rot < -1/2 or 1/2 < rot then
      rot = rot - dt * rotf
      animal.rotf = -rotf
    end
    animal.rot = rot

    -- shrink
    animal.size = animal.size - dt / 4
    if animal.size < 0 then
      table.remove(animals, i)
    end
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
    local animal = {}
    local i = math.random(1, #images)
    animal.image = images[i]
    animal.size = 1
    animal.rot = 0
    animal.rotf = 1
    table.insert(animals, animal)
  end

  -- TODO: letters
end


function love.draw()
  love.graphics.print("Type the full word \"quit\" to quit", 8, 8, 0, 2, 2)

  for i = 1, #animals do
    local animal = animals[i]
    local image = animal.image
    local iwidth = image:getWidth()
    local iheight = image:getHeight()
    love.graphics.draw(image, width/2, height/2, animal.rot, animal.size, animal.size, iwidth/2, iheight/2)
  end
end


