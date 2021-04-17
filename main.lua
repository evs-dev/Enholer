function init()
	RegisterTool("enholer", "Enholer", "MOD/vox/enholer.vox")
	SetBool("game.tool.enholer.enabled", true)

	--snd = LoadLoop("MOD/snd/gas.ogg")

	--emit = false
	--ui = false
end

function tick(dt)
	-- Check if Enholer is selected
	if GetString("game.player.tool") == "enholer" then
		if GetBool("game.player.canusetool") and InputDown("lmb") then
			local ct = GetCameraTransform();
			local pos = ct.pos
			local dir = TransformToParentVec(ct, Vec(0, 0, -1))
			local hit, dist, normal, shape = QueryRaycast(pos, dir, 500)
			if hit then
				local hitPoint = VecAdd(pos, VecScale(dir, dist))
    local radius = 0.4
				MakeHole(hitPoint, radius, radius, radius)
			end
		end
	end
end
