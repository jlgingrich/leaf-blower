function init()
	RegisterTool("blower", "Leaf Blower", "MOD/vox/blower.vox")
	SetBool("game.tool.blower.enabled", true)
	SetInt("game.tool.blower.ammo", 100)
	snd = LoadLoop("leafblower.ogg")
	
	strength = GetFloat("savegame.mod.strength")
	if strength == 0 then strength = 1.25 end
	maxMass = GetFloat("savegame.mod.maxMass")
	if maxMass == 0 then maxMass = 300 end
	maxDist = GetFloat("savegame.mod.maxDist")
	if maxDist == 0 then maxDist = 10 end
	
	ready = 0
end

function tick()
	--Only active when holding the leaf blower
	if GetString("game.player.tool") == "blower" then
	
		--Check if tool is firing
		if GetBool("game.player.canusetool") and InputDown("lmb") then

			--Get all physical and dynamic bodies in front of camera
			local t = GetCameraTransform()
			local c = TransformToParentPoint(t, Vec(0, 0, -maxDist/2))
			local mi = VecAdd(c, Vec(-maxDist/2, -maxDist/2, -maxDist/2))
			local ma = VecAdd(c, Vec(maxDist/2, maxDist/2, maxDist/2))
			QueryRequire("physical dynamic")
			local bodies = QueryAabbBodies(mi, ma)

			--Loop through bodies and push them
			for i=1,#bodies do
				local b = bodies[i]

				--Compute body center point and distance
				local bmi, bma = GetBodyBounds(b)
				local bc = VecLerp(bmi, bma, 0.5)
				local dir = VecSub(bc, t.pos)
				local dist = VecLength(dir)
				dir = VecScale(dir, 1.0/dist)

				--Get body mass
				local mass = GetBodyMass(b)
				
				--Check if body is should be affected
				if dist < maxDist and mass < maxMass then
					--Make sure direction is always pointing slightly upwards
					dir[2] = 0.5
					dir = VecNormalize(dir)
			
					--Compute how much velocity to add
					local massScale = 1 - math.min(mass/maxMass, 1.0)
					local distScale = 1 - math.min(dist/maxDist, 1.0)
					local add = VecScale(dir, strength * massScale * distScale)
					
					--Add velocity to body
					local vel = GetBodyVelocity(b)
					vel = VecAdd(vel, add)
					SetBodyVelocity(b, vel)
				end
			end

			--Play sound effect
			PlayLoop(snd, t.pos, 0.5)
		end
		local t = Transform()
		t.pos = Vec(0.3, 0, 0)
		SetToolTransform(t)
	end
end


