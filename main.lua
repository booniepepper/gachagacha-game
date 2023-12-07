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

  local instrumentPairs = {
    {"a", "marimba/c2.wav"}, {"s", "marimba/d2.wav"}, {"d", "marimba/e2.wav"}, {"f", "marimba/g2.wav"}, {"g", "marimba/a2.wav"},
    {"h", "marimba/c3.wav"}, {"j", "marimba/d3.wav"}, {"k", "marimba/e3.wav"}, {"l", "marimba/g3.wav"}, {";", "marimba/a3.wav"},
    {"'", "marimba/c4.wav"},
    {"q", "vcsl/steinway/c2.wav"}, {"w", "vcsl/steinway/d2.wav"}, {"e", "vcsl/steinway/e2.wav"},
    {"r", "vcsl/steinway/c3.wav"}, {"t", "vcsl/steinway/d3.wav"}, {"y", "vcsl/steinway/e3.wav"},
    {"u", "vcsl/steinway/c4.wav"}, {"i", "vcsl/steinway/d4.wav"}, {"o", "vcsl/steinway/e4.wav"},
    {"p", "vcsl/steinway/c5.wav"}, {"[", "vcsl/steinway/d5.wav"}, {"]", "vcsl/steinway/e5.wav"},
    {"\\", "vcsl/steinway/c6.wav"},
    {"1", "vcsl/mbira/c3.wav"}, {"2", "vcsl/mbira/d3.wav"}, {"3", "vcsl/mbira/g3.wav"},
    {"4", "vcsl/mbira/c4.wav"}, {"5", "vcsl/mbira/d4.wav"}, {"6", "vcsl/mbira/g4.wav"},
    {"7", "vcsl/mbira/c5.wav"},
  }
  percussions = {
    "vcsl/percussion/bass-drum-1.wav", "vcsl/percussion/bass-drum-2.wav", "vcsl/percussion/bongo-high-1.wav", "vcsl/percussion/bongo-high-2.wav",
    "vcsl/percussion/bongo-low-1.wav", "vcsl/percussion/bongo-low-2.wav", "vcsl/percussion/conga-1.wav",      "vcsl/percussion/conga-2.wav",
    "vcsl/percussion/quinto-1.wav",    "vcsl/percussion/quinto-2.wav",    "vcsl/percussion/rimshot.wav",      "vcsl/percussion/snare-roll.wav",
    "vcsl/percussion/snare-tap.wav",   "vcsl/percussion/snare.wav",       "vcsl/percussion/timpani-1.wav",    "vcsl/percussion/timpani-2.wav",
    "vcsl/percussion/tom-1.wav",       "vcsl/percussion/tom-2.wav",       "vcsl/percussion/tumba-1.wav",      "vcsl/percussion/tumba-2.wav",
  }
  local percussionKeys = {"z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "'", "-", "lctrl", "lalt", "rctrl", "ralt", "lshift", "rshift", "tab", "return"}

  sfx = {}
  for _, pair in ipairs(instrumentPairs) do
    table.insert(sfx, {pair[1], love.audio.newSource(pair[2], "static")})
  end
  for i = 1, #percussions do
    local sound = love.audio.newSource(percussions[i], "static")
    table.insert(sfx, {percussionKeys[i], sound})
    percussions[i] = sound
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

  -- pop up an animal!
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

  -- play a sound!
  local matched = false
  for _, hit in ipairs(sfx) do
    if key == hit[1] then
      hit[2]:stop()
      hit[2]:play()
      matched = true
    end
  end
  if not matched then
    local percussion = percussions[math.random(1, #percussions)]
    percussion:stop()
    percussion:play()
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
