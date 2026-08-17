--code fixes protien over 300 not giving a buff, and makes it give a 100% buff instead
local isChangingStrength = false
local function fixProtienProblem(char,perk,x)
	--need debounce value to prevent infinite loop
	if isChangingStrength then return end
	local charProtein = char:getNutrition():getProteins()
	local perkName = perk:getName()
	if perkName == "Strength" and charProtein>300 then
		--print(char:getXp():getXP(perk))
		--since x equals the already gained xp amount for strength, addding it again would double it
		isChangingStrength = true
		char:getXp():AddXP(perk, x)
		isChangingStrength = false
		--print(char:getXp():getXP(perk))
	end
end
Events.AddXP.Add(fixProtienProblem)