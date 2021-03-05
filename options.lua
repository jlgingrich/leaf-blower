function init()
	strength = GetFloat("savegame.mod.strength")
	if strength == 0 then strength = 1.25 end
	maxMass = GetFloat("savegame.mod.maxMass")
	if maxMass == 0 then maxMass = 300 end
	maxDist = GetFloat("savegame.mod.maxDist")
	if maxDist == 0 then maxDist = 10 end
end

function draw()
	UiTranslate(UiCenter(), 350)
	UiAlign("center middle")

	UiFont("bold.ttf", 48)
	UiText("Leaf Blower")
	UiFont("regular.ttf", 26)
	UiTranslate(0, 70)
	UiPush()
		UiText("Blower strength")
		UiAlign("right")
		UiTranslate(95, 40)
		strength = optionsSlider(strength, 0.1, 10.0)
		UiTranslate(-75, 20)
		UiColor(0.2, 0.6, 1)
		UiText(strength)
		SetFloat("savegame.mod.strength", strength)
	UiPop()

	UiTranslate(0, 110)
	UiPush()
		UiText("Debris threshold")
		UiAlign("right")
		UiTranslate(95, 40)
		maxMass = optionsSlider(maxMass, 0, 500)
		UiTranslate(-75, 20)
		UiColor(0.2, 0.6, 1)
		UiText(maxMass)
		SetFloat("savegame.mod.maxMass", maxMass)
	UiPop()

	UiTranslate(0, 110)
	UiPush()
		UiText("Blower range")
		UiAlign("right")
		UiTranslate(95, 40)
		maxDist = optionsSlider(maxDist, 0, 20)
		UiTranslate(-75, 20)
		UiColor(0.2, 0.6, 1)
		UiText(maxDist)
		SetFloat("savegame.mod.maxDist", maxDist)
	UiPop()
	UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)

	UiTranslate(0, 120)
	if UiTextButton("Close", 80, 40) then
		Menu()
	end
end

function optionsSlider(val, min, max)
	UiColor(0.2, 0.6, 1)
	UiPush()
		UiTranslate(0, -8)
		val = (val-min) / (max-min)
		local w = 195
		UiRect(w, 3)
		UiAlign("center middle")
		UiTranslate(-195, 1)
		val = UiSlider("ui/common/dot.png", "x", val*w, 0, w) / w
		val = round((val*(max-min)+min), 2)
	UiPop()
	return val
end

function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end