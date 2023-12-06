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

  sfx = {
    {"a", love.audio.newSource("marimba/c2.wav", "static")},
    {"s", love.audio.newSource("marimba/d2.wav", "static")},
    {"d", love.audio.newSource("marimba/e2.wav", "static")},
    {"f", love.audio.newSource("marimba/g2.wav", "static")},
    {"g", love.audio.newSource("marimba/a2.wav", "static")},
    {"h", love.audio.newSource("marimba/c3.wav", "static")},
    {"j", love.audio.newSource("marimba/d3.wav", "static")},
    {"k", love.audio.newSource("marimba/e3.wav", "static")},
    {"l", love.audio.newSource("marimba/g3.wav", "static")},
    {";", love.audio.newSource("marimba/a3.wav", "static")},
    {"'", love.audio.newSource("marimba/c4.wav", "static")},
    {"q", love.audio.newSource("vcsl/steinway/c2.wav", "static")},
    {"w", love.audio.newSource("vcsl/steinway/d2.wav", "static")},
    {"e", love.audio.newSource("vcsl/steinway/e2.wav", "static")},
    {"r", love.audio.newSource("vcsl/steinway/c3.wav", "static")},
    {"t", love.audio.newSource("vcsl/steinway/d3.wav", "static")},
    {"y", love.audio.newSource("vcsl/steinway/e3.wav", "static")},
    {"u", love.audio.newSource("vcsl/steinway/c4.wav", "static")},
    {"i", love.audio.newSource("vcsl/steinway/d4.wav", "static")},
    {"o", love.audio.newSource("vcsl/steinway/e4.wav", "static")},
    {"p", love.audio.newSource("vcsl/steinway/c5.wav", "static")},
    {"[", love.audio.newSource("vcsl/steinway/d5.wav", "static")},
    {"]", love.audio.newSource("vcsl/steinway/e5.wav", "static")},
    {"\\", love.audio.newSource("vcsl/steinway/c6.wav", "static")},
    {"z", love.audio.newSource("vcsl/mbira/c3.wav", "static")},
    {"x", love.audio.newSource("vcsl/mbira/d3.wav", "static")},
    {"c", love.audio.newSource("vcsl/mbira/g3.wav", "static")},
    {"v", love.audio.newSource("vcsl/mbira/c4.wav", "static")},
    {"b", love.audio.newSource("vcsl/mbira/d4.wav", "static")},
    {"n", love.audio.newSource("vcsl/mbira/g4.wav", "static")},
    {"m", love.audio.newSource("vcsl/mbira/a4.wav", "static")},
  }

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

    -- launch
    animal.x = animal.x + animal.dx * dt
    animal.y = animal.y + animal.dy * dt
    animal.dy = animal.dy + dt * 1000
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
  else
    prevkeys = ""
  end

  -- animals
  -- TODO: sfx
  if key == "space" then
    local animal = {}
    local i = math.random(1, #images)
    animal.image = images[i]
    animal.size = 1
    animal.x = math.random(0, width)
    animal.dx = math.random(-250, 250)
    animal.y = math.random(0, height)
    animal.dy = -1000
    animal.rot = 0
    animal.rotf = 1
    table.insert(animals, animal)
  end

  -- TODO: letters
  for _, hit in ipairs(sfx) do
    if key == hit[1] then
      hit[2]:stop()
      hit[2]:play()
    end
  end
end


function love.draw()
  love.graphics.print("Type the full word \"quit\" to quit", 8, 8, 0, 2, 2)

  for _, animal in ipairs(animals) do
    local image = animal.image
    local iwidth = image:getWidth()
    local iheight = image:getHeight()
    love.graphics.draw(image, animal.x, animal.y, animal.rot, animal.size, animal.size, iwidth/2, iheight/2)
  end
end


