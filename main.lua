function init()
 RegisterTool("enholer", "Enholer", "MOD/vox/enholer.vox")
 SetBool("game.tool.enholer.enabled", true)

 DEFAULT_RADIUS = 0.4
 MIN_RADIUS = 0.1
 MAX_RADIUS = 10
 RADIUS_INCREMENT = 0.025

 radius = DEFAULT_RADIUS
 isUsingTool = false
 inRadiusConfig = false
 hit = false
 hitPoint = Vec()
end

function clamp(value, min, max)
 if value < min then
  return min
 elseif value > max then
  return max
 end
 return value
end

function tick(dt)
 -- Check if Enholer is selected
 isUsingTool = GetString("game.player.tool") == "enholer" and (GetBool("game.player.canusetool") or inRadiusConfig)
 if isUsingTool then
  -- Raycast at what the player is looking at, if anything
  local ct = GetCameraTransform()
  local pos = ct.pos
  local dir = TransformToParentVec(ct, Vec(0, 0, -1))
  local didHit, dist = QueryRaycast(pos, dir, 500)

  -- Update the global variables for draw() to use
  hit = didHit
  if didHit then
   hitPoint = VecAdd(pos, VecScale(dir, dist))
  end

  -- Check for left click to make hole
  if didHit and InputDown("lmb") and not inRadiusConfig then
   MakeHole(hitPoint, radius, radius, radius)
  end
 else
  hit = false
 end
end

function draw()
 if hit then
  -- Draw radius indicator scaled to world space radius
  local x, y, dist = UiWorldToPixel(hitPoint)
  UiPush()
   UiTranslate(x, y)
   UiAlign("center middle")
   UiColor(1, 1, 1, 0.7)
   UiScale(10 * (radius / dist))
   UiImage("circle.png")
  UiPop()
 end

 if isUsingTool then
  -- Radius configuration
  if InputPressed("r") then
   inRadiusConfig = not inRadiusConfig
  end

  UiTranslate(UiWidth() - 350, 60)
  UiAlign("left top")
  UiFont("regular.ttf", 26)

  if inRadiusConfig then
   UiMakeInteractive()
   UiText("Press R to close")
   UiTranslate(0, 26)
   UiText("Press A to decrease radius")
   UiTranslate(0, 26)
   UiText("Press D to increase radius")

   if InputDown("a") then
    radius = radius - RADIUS_INCREMENT
   end
   if InputDown("d") then
    radius = radius + RADIUS_INCREMENT
   end
   radius = clamp(radius, MIN_RADIUS, MAX_RADIUS)
  else
   UiText("Press R to change radius")
  end
 end
end
