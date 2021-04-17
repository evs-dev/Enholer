function init()
	RegisterTool("enholer", "Enholer", "MOD/vox/enholer.vox")
	SetBool("game.tool.enholer.enabled", true)

	--snd = LoadLoop("MOD/snd/gas.ogg")

	--emit = false
	--ui = false
 DEFAULT_RADIUS = 0.4
 MIN_RADIUS = 0.1
 MAX_RADIUS = 10
 RADIUS_INCREMENT = 0.025
 radius = DEFAULT_RADIUS
 hit = false
 hitPoint = Vec(0, 0, 0)
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
	if GetString("game.player.tool") == "enholer" then
  local ct = GetCameraTransform()
  local pos = ct.pos
  local dir = TransformToParentVec(ct, Vec(0, 0, -1))
  local didHit, dist, normal, shape = QueryRaycast(pos, dir, 500)
  hit = didHit
  if didHit then
   hitPoint = VecAdd(pos, VecScale(dir, dist))
  end
		if GetBool("game.player.canusetool") and InputDown("lmb") then
			if hit then
    MakeHole(hitPoint, radius, radius, radius)
   end
		end
  if InputDown("shift") then
   radius = radius + RADIUS_INCREMENT
  elseif InputDown("ctrl") then
   radius = radius - RADIUS_INCREMENT
  end
  radius = clamp(radius, MIN_RADIUS, MAX_RADIUS)
	end
end

function draw()
 if GetString("game.player.tool") == "enholer" and hit then
  local x, y, dist = UiWorldToPixel(hitPoint)
  UiTranslate(x, y)
  UiAlign("center middle")
  UiColor(1, 1, 1, 0.7)
  UiScale(10 * (radius / dist))
  UiImage("circle.png")
 end
end
