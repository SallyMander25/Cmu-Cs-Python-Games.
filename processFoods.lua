local MOD_VERSION = 2
--cache global variables for later
local math = math
local pairs = pairs
local table = table
local max, min = math.max, math.min
--translate them into a specific food type so all the different varients will be treated as the same
local foodMasterKey = {
	--stews
	["StewBowl"] = "StewBowl",
	["StewBowlClay"] = "StewBowl",
	["BucketOfStew"] = "StewBowl",
	["PotForgedStew"] = "StewBowl",
	["PotOfStew"] = "StewBowl",
	--["PotOfStewRecipe"] = "Stew",
	--["PotForgedStewRecipe"] = "Stew",
	--soups
	["SoupBowl"] = "SoupBowl",
	["SoupBowlClay"] = "SoupBowl",
	["BucketOfSoup"] = "SoupBowl",
	["PotForgedSoup"] = "SoupBowl",
	["PotOfSoup"] = "SoupBowl",
	["PotOfSoupRecipe"] = "SoupBowl",
	["PotForgedSoupRecipe"] = "SoupBowl",
	--Pastas, there is a pasta in game may need rename, same with rice
	["PastaBowl"] = "PastaBowl",
	["PastaBowlClay"] = "PastaBowl",
	["WaterPotPasta"] = "PastaBowl",
	["WaterPotForgedPasta"] = "PastaBowl",
	["WaterSaucepanPastaCopper"] = "PastaBowl",
	["PastaPan"] = "PastaBowl",
	["PastaPanCopper"] = "PastaBowl",
	["PastaPot"] = "PastaBowl",
	["PastaPotForged"] = "PastaBowl",
	["WaterSaucepanPasta"] = "PastaBowl",
	["salPasta"] = "PastaBowl",
	--rice
	["RiceBowl"] = "RiceBowl",
	["RiceBowlClay"] = "RiceBowl",
	["WaterPotRice"] = "RiceBowl",
	["WaterPotForgedRice"] = "RiceBowl",
	["WaterSaucepanRiceCopper"] = "RiceBowl",
	["RicePan"] = "RiceBowl",
	["RicePanCopper"] = "RiceBowl",
	["RicePot"] = "RiceBowl",
	["RicePotForged"] = "RiceBowl",
	["WaterSaucepanRice"] = "RiceBowl",
	["salRice"] = "RiceBowl",
	--pizza
	["PizzaWhole"] = "Pizza",
	["PizzaRecipe"] = "Pizza",
	["Pizza"] = "Pizza",
	--salads
	["FruitSalad"] = "FruitSalad",
	["FruitSaladClay"] = "FruitSalad",
	["Salad"] = "Salad",
	["SaladClay"] = "Salad",
	--cakes
	["CakePrep"] = "CakeRaw",
	["CakeRaw"] = "CakeRaw",
	["CakeSlice"] = "CakeRaw",
	--pies
	["PiePrep"] = "Pie",
	["PieWholeRaw"] = "Pie",
	["PieWholeRawSweet"] = "Pie",
	["Pie"] = "Pie",
	--ChocChipCookies
	["CookieChocolateChipDough"] = "CookiesChocolateChip",
	["CookiesChocolateChip"] = "CookiesChocolateChip",
	--sugarCookies
	["CookiesSugarDough"] = "CookiesSugar",
	["CookiesSugar"] = "CookiesSugar",
	--oatmealCookies
	["CookiesOatmealDough"] = "CookiesOatmeal",
	["CookiesOatmeal"] = "CookiesOatmeal",
	--ChoclateCookies
	["CookiesChocolateDough"] = "CookiesChocolate",
	["CookiesChocolate"] = "CookiesChocolate",
	--ShortbreadCookies
	["CookiesShortbreadDough"] = "CookiesShortbread",
	["CookiesShortbread"] = "CookiesShortbread",
    --homemadeMuffins
    ["MuffinGeneric"] = "MuffinGeneric",
    ["BakingTray_Muffin"] = "MuffinGeneric",
    ["BakingTray_Muffin_Recipe"] = "MuffinGeneric",
	--StirFrys
	["PanFriedVegetables"] = "PanFriedVegetables",
	["GriddlePanFriedVegetables"] = "PanFriedVegetables",
	["PanFriedVegetablesForged"] = "PanFriedVegetables",
	--Omelettes
	["EggOmelette"] = "EggOmelette",
	["OmeletteRecipeForged"] = "EggOmelette",
	["OmeletteRecipe"] = "EggOmelette",
	--pancakes
	["Pancakes"] = "Pancakes",
	["PancakesRecipe"] = "Pancakes",
	--burgers
	["BurgerRecipe"] = "Burger",
	["Burger"] = "Burger",
	--roasts
	["PanFriedVegetables2"] = "PanFriedVegetables2",
	--Ice cream cones
	["ConeIcecream"] = "ConeIcecream",
	["ConeIcecreamToppings"] = "ConeIcecream",
	["ConeIcecreamMelted"] = "ConeIcecream",
	-- Hot Drinks
	["HotDrink"] = "HotDrink",
	["HotDrinkSpiffo"] = "HotDrink",
	["HotDrinkCopper"] = "HotDrink",
	["HotDrinkGold"] = "HotDrink",
	["HotDrinkMetal"] = "HotDrink",
	["HotDrinkSilver"] = "HotDrink",
	["HotDrinkTumbler"] = "HotDrink",
	["TestHotDrink"] = "HotDrink",
	["HotDrinkRed"] = "HotDrink",
	["HotDrinkWhite"] = "HotDrink",
	["HotDrinkTeaCeramic"] = "HotDrink",
	["HotDrinkTea"] = "HotDrink",
	["HotDrinkClay"] = "HotDrink",
	--for the plate mod all of the plate stuff,
	--this mod does not track spices and so food thathas spices in it
	--will not work with the plates
	["PlateOmelette"] = "EggOmelette",
	["ClayPlateOmelette"] = "EggOmelette",
	["ClayPlateRoasted"] = "PanFriedVegetables2",
	["PlateRoasted"] = "PanFriedVegetables2",
	["ClayPlateStirFry"] = "PanFriedVegetables",
	["PlateStirFry"] = "PanFriedVegetables"
  }
 --helper function finds if food name is in master key table, the correct name
local function findFoodName(type)
	--print(foodMasterKey[type])
	if foodMasterKey[type] then
		return foodMasterKey[type]
	end
	return type
end
--helper function checks if 2 lists are identical 
local function areListsIdentical(list1,list2)
	if list1 == nil then list1 = {} end
	if list2 == nil then list2 = {} end
	if #list1 ~= #list2 then return false end
	table.sort(list1)
	table.sort(list2)
	for i = 1, #list1 do
		if list1[i]~=list2[i]then 
			return false
		end
	end
	return true
end
--helper function checks if the food is already within the specified modData table
local function foodAlreadyIn(player,newFood)
	local modData = player:getModData()
	--foodDatas are in order to prioritize the first in list 
	local foodDatas = {modData.salsOriginalFav,modData.salsFavoritedFood,modData.salsQueuedFood}
	for i,v in ipairs(foodDatas) do
		--print(v, "is for all datas")
		for j, k in pairs(v) do
			--print(k, "is for indiviual")
			if k.name == newFood.name then
				local identicalSpice = areListsIdentical(k.spices,newFood.spices)
				local identicalIngre = areListsIdentical(k.ingredients,newFood.ingredients)
				--print(identicalIngre, "are ingredients identical")
				--print(identicalSpice, "are spices identical")
				if identicalIngre and identicalSpice then
					return true , j, i
				end
			end
		end
	end
	return false , nil , nil
end
--helper function converts userData and nil into tables, for java conversion
local function convertIntoTable(list)
	--print(type(list))
	if  list == nil then return {} end
	if type(list)=="userdata" then
		local newList={}
		for i=0, list:size()-1 do
			--print(list:get(i))
			table.insert(newList,list:get(i))
		end
		return newList
	else
		return list
	end
end
--helper function returns true if the food has high fats OR carbs AND gives happiness by default
local function isFoodTasty(item)
	local nutrientValue = SandboxVars.ComfortFoodMod.NutrientLevel
	local needFoodHappy = SandboxVars.ComfortFoodMod.BaseHappiness
	local sameAsMenu = SandboxVars.ComfortFoodMod.ReplicateMenuSettings
	local uniqueIngredients = SandboxVars.ComfortFoodMod.NoRepeatIngredients
	local mustBeEvolved = SandboxVars.ComfortFoodMod.MustEvolvedRecipe
	local minimumIngre = SandboxVars.ComfortFoodMod.MinimumIngreidentsNeeded
	if sameAsMenu then
		if mustBeEvolved and item:getExtraItems():size()<=0 then
			return false
		elseif (item:getExtraItems():size() + item:getSpices():size())<= minimumIngre then
			return false
		elseif uniqueIngredients then
			local seenList = {}
			local realList = convertIntoTable(item:getExtraItems())
			for i,v in pairs(realList) do
				if seenList[v]then
					--print("Ingreidents of the same name found")
					return false
				else
					seenList[v] = true
				end
			end
		end
	end
	local hungerChange = math.abs(item:getHungerChange()) * 100
	if not needFoodHappy or item:getUnhappyChange()<=0 then
		if (item:getCarbohydrates()*nutrientValue>=hungerChange or item:getLipids()*nutrientValue>=hungerChange) then
			return true
		end
	end
	return false
end

local allRecipes = getScriptManager():getAllEvolvedRecipes()
--helper function used to reset lists with F5 in debug mode to debug
local function debugLists(key)
	local player = getPlayer()
	if not player then return end
	if getDebug() and key == 63 then
		player:getModData().salsQueuedFood = {}
		player:getModData().salsFavoritedFood = {}
		player:getModData().salsOriginalFav = {}
		player:getModData().salsCFModVersion = nil
		player:getModData().salsFoodMemory = {}
		print("COMFORTFOODMOD: Food memories have been wiped.")
		player:transmitModData()
	end
end
local PerformFoodOG = ISEatFoodAction.perform
-- function that activates when a food item is consumed, used to activate all other parts of code.
--Mecahanic 1 --> Item data fetching, categorizing, and sorting:
--food item Found using the functions in build self.item and pz's own methods to get all the required ingredients and spices, 
--then finds if they belong in a specific list based on if the item is already present and if not present, if the item passes 
--the isFoodTasty helper function test.
--Mechanic 2 --> Unhappiness and stress recovery from listed food:
-- food item that is inside favoritedFood or Original will use the items last time it was eaten, and rank to determine 
--the effectiveness of its stress and unhappiness recovery, with the rank being an exponetal increase and the
--time being linear.
-- Mechanic 3 --> Memory System for Rank Reseting:
--if a favorited item is eaten consecutivly for the amount of times needed for a rankreset, as seen in the sandbox variable,
-- The favorited item will go up to number 1 (incoded equals 0), and push all the others on top of it down by one.
--Mechanic 4 --> Queued Food Addiction Meter:
--queued foods have a addiction meter which fills up based on how unhappy or hungry they are, whatevers worse, and dynamically
--via a linear equation increase the addiction level intill it reaches at or over 100, when it is placed in favorited foods
--Mechanic 5 --> Favorited Food Excess Pruning:
--if the favorited food list gets more added to it than what rankMax is equal to, then it will remove the last variable
--in that table, making the character completely forget about it and removing it from the system.
function ISEatFoodAction:perform()
	local foodList = {}
	local playerObj=self.character
	local modData = playerObj:getModData()
	--checks if the modDatas are made and makes them if not, also sets the modData to only work under the Sally parent, for organization
	modData.salsQueuedFood = modData.salsQueuedFood or {}
	modData.salsFavoritedFood = modData.salsFavoritedFood or {}
	modData.salsFoodMemory = modData.salsFoodMemory or {}
	
	local rankEffect = SandboxVars.ComfortFoodMod.RankMultiplier
	local rankMax = SandboxVars.ComfortFoodMod.RankMax
	local timeEffect = SandboxVars.ComfortFoodMod.TimeMultiplier
	local desperation = SandboxVars.ComfortFoodMod.DesperationMin
	local rankReset = SandboxVars.ComfortFoodMod.RankResetInt
	local remeberanceTalk = SandboxVars.ComfortFoodMod.MemoryTalk
	local favoritedTalk = SandboxVars.ComfortFoodMod.FavTalk
	local realizeTalk = SandboxVars.ComfortFoodMod.RealizationTalk

	local playerStats = playerObj:getStats()
	local playerUnhappiness = playerStats:get(CharacterStat.UNHAPPINESS)
	local playerStress = playerStats:get(CharacterStat.STRESS)
	local playerHunger = playerStats:get(CharacterStat.HUNGER)

    local item = self.item
    local percentEaten = self.percentage
	local newIngredients = convertIntoTable(item:getExtraItems())
	local newSpices = convertIntoTable(item:getSpices())
	local newFood = findFoodName(item:getType())
	local currentTime = getGameTime():getWorldAgeHours()
	--performs the act of eating, without this the food never gets consumed
	PerformFoodOG(self)
	--stops the program if the player ate a dangerous food item, to not incentivise that
	if (item:isbDangerousUncooked() and not item:isCooked()) or item:isRotten() then return end

	local addictionIncrease = 0.0
	--calculates addiction based on either hunger or unhappiness, whatevers worse, hunger goes from 1 to 0 while 
	--unhappiness goes from 100 to 0, so hunger is mutiplied by 100 to calibrate, -20 & /2 are balance decisions
	if (playerUnhappiness>=desperation or playerHunger>=(desperation/100)) then
		addictionIncrease = max((playerUnhappiness-20)/2,(((playerHunger-(20/100))/2)*100),1)
		--print(addictionIncrease, "is the level in which the addiction is increasing")
	end
	--creates the Table to be used for adding the item to the favorated table, when the time comes
	local FavoritedFoodData = { name = newFood, ingredients = newIngredients, spices = newSpices, rankInQueue = 0, lastTimeEaten = currentTime}
	--creates the Table to be used to add the item to the queue of food, if the item is considered tasty and not dangerously uncooked and not in
	--favorates then it will be added to a queue to later become a favorate if it amasses enough "addiction"
	local queuedFoodData = {name=newFood, ingredients=newIngredients, spices = newSpices, addictionLevel = addictionIncrease}
	--if the player picked an original food item from the menu then this will activate if the food is
	--said original food item
	local inData, foodIndex, tableIndex = foodAlreadyIn(playerObj, FavoritedFoodData) 
	--inData is a boolean connected to if the food item is in the general modData of the player
	--foodIndex is the specific index the food is in, inside its particular table
	--tableIndex maps to the specific table that you want to lookup with,
	--1 being originalFav, 2 being favoritedFood, and 3 being queuedFood
	--print(tableIndex)
	--print(foodIndex)
	if inData then
		if SandboxVars.ComfortFoodMod.SeperateOriginalFav and tableIndex == 1 then
			--because the modData may have the same name and or ingredients per food, need to check if the 
			--spices and ingreidents are the same again before proceeding as to not encounter errors.
				local v = modData.salsOriginalFav[foodIndex]
				local timeElapsed
				if v.lastTimeEaten then
					timeElapsed = (currentTime-v.lastTimeEaten)
				else
					timeElapsed = timeEffect
				end
				--calculates the mental refresh based on the time since the lastTimeEaten, with a max value 
				-- of 1 for the time scaler menaing a max value of 100 for mentalRefresh
				local mentalRefresh = 100*min(timeElapsed,timeEffect)/timeEffect
				--note if the character eats a food item with higher happiness than the player may recieve by the
				--mental refresh, it cancels the metal refres and just uses that happiness gain
				playerStats:set(CharacterStat.UNHAPPINESS,max(min(playerUnhappiness-mentalRefresh,playerUnhappiness+(item:getUnhappyChange()*percentEaten)),0))
				playerStats:set(CharacterStat.STRESS,max(playerStress-(mentalRefresh/100),0))
				v.lastTimeEaten = currentTime
				--both custom variables the player can pick, put together for the hell of it and so the player cant
				--spam the food item to keep saying his line
				if mentalRefresh>=desperation then playerObj:Say(remeberanceTalk) end
		--if the food is in the favorited food list then this will go 
		elseif tableIndex==2 then
			local v = modData.salsFavoritedFood[foodIndex]
			local timeElapsed
			if v.lastTimeEaten then
				timeElapsed = (currentTime-v.lastTimeEaten)
			else
				timeElapsed = timeEffect
			end
			--uses the rank in queue on top of the timeElapsed to determine the amount of 
			--mental Refresh the character may receive
			local mentalRefresh = (100/(rankEffect^v.rankInQueue))*(min(timeElapsed,timeEffect))/timeEffect
			playerStats:set(CharacterStat.UNHAPPINESS,max(min(playerUnhappiness-mentalRefresh,playerUnhappiness+(item:getUnhappyChange()*percentEaten)),0))
			playerStats:set(CharacterStat.STRESS,max((playerStress-mentalRefresh)/100,0))
			v.lastTimeEaten = currentTime
			if mentalRefresh>=desperation then 	playerObj:Say(favoritedTalk) end
			--makes code slightly cleaner by creating memory data variable
			local memoryData = modData.salsFoodMemory
			local memoryList = {name = newFood, ingredients = newIngredients, spices = newSpices, memory = 0}
			if newFood==memoryData.name and areListsIdentical(newIngredients,memoryData.ingredients) and areListsIdentical(newSpices,memoryData.spices) then
				--print("this is the amount needed to reset rank ", rankReset," vs the amount currently ", modData.salsFoodMemory.memory)
				if v.rankInQueue>0 then
					modData.salsFoodMemory.memory = (memoryData.memory + 1) or 1
				end
			else
				modData.salsFoodMemory = memoryList
			end

				if modData.salsFoodMemory.memory>=rankReset-1 then
					--sorts table by rank to make the for loop work 
					table.sort(modData.salsFavoritedFood, function(a,b) return a.rankInQueue < b.rankInQueue end)
					for j =1, v.rankInQueue+1 do
						local rankChecker=modData.salsFavoritedFood[j]
						rankChecker.rankInQueue=(rankChecker.rankInQueue or 0)+1
					end
					modData.salsFoodMemory.memory = 0
					v.rankInQueue = 0
				end
		elseif tableIndex==3 then
				modData.salsQueuedFood[foodIndex].addictionLevel = (modData.salsQueuedFood[foodIndex].addictionLevel or 0)+addictionIncrease
				--print(qCheck.addictionLevel)
				if modData.salsQueuedFood[foodIndex].addictionLevel>=100 then
					--counts backwards to ensure variables are not skipped after deletion
					for j = #modData.salsFavoritedFood,1,-1 do
						local rankChecker=modData.salsFavoritedFood[j]
						rankChecker.rankInQueue=(rankChecker.rankInQueue or 0)+1
						if rankChecker.rankInQueue>=rankMax then
							table.remove(modData.salsFavoritedFood , j)
						end
					end
					--takes the queued Food and places it in favorated food, then sets the players
					--stress or unhappiness down, max to 0 needed to not get any negative values.
					table.insert(modData.salsFavoritedFood,FavoritedFoodData)
					table.remove(modData.salsQueuedFood,foodIndex)
					playerStats:set(CharacterStat.UNHAPPINESS,max(playerUnhappiness-80,0))
					playerStats:set(CharacterStat.STRESS,max(playerStress-80,0))
					playerObj:Say(realizeTalk)
				end
			end
	elseif isFoodTasty(item) and addictionIncrease>0 then
		table.insert(modData.salsQueuedFood,queuedFoodData)
		--print("new food item", addictionIncrease)
	end
	playerObj:transmitModData()
end
-- Code for changing the sdata on the screen in the character screen
--used in debug more to reset lists
Events.OnKeyPressed.Add(debugLists)

--function used to automatically wipe the previous versions data to ensure no fatal errors
local function ensureNoVersionBugs(i,plr)
	local modData = plr:getModData()
	if (modData.salsCFModVersion or nil) ~= MOD_VERSION  then
		modData.salsQueuedFood = {}
		modData.salsFavoritedFood = {}
		modData.salsFoodMemory = {}
		modData.salsOriginalFav = nil
		modData.salsCFModVersion = MOD_VERSION
		print("COMFORTFOODMOD: Moddata has been reset to ensure no fatal errors on switching versions")
		plr:transmitModData()
	end
end
Events.OnCreatePlayer.Add(ensureNoVersionBugs)