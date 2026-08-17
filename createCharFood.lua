local MOD_VERSION = 2

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
--local FONT_HGT_LARGE = getTextManager():getFontHeight(UIFont.Large)
local allRecipes = getScriptManager():getAllEvolvedRecipes()
local allItems = getScriptManager():getAllItems()

local allEvolvedRecipes = {}
local avaIngredientsList = {}
local avaSpicesList = {}
local staticIngredientList = {}
local staticSpicesList = {}
local usedSpiceList = {}
local usedIngredientsList = {}
local allFoods = {}

local currentFood = "nothing"

local maxIngredients = 5

local minimumMet = false
local EvolvedFood = false

local table = table
local pairs = pairs
local ipairs = ipairs
local max =  math.max
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
  --creates all the recipes names and types to store
local function organizeRecipes()
    --uses seperate table to find repeat types from the food master key to reduce redundancy in the dropdown
    local repeatTable = {}
    for i = 0, allRecipes:size() - 1 do
        local recipe = allRecipes:get(i)
        local type = recipe:getResultItem()
        local food = instanceItem(type)
        if food and instanceof(food,"Food") then
            local found = false
            for i,v in pairs(repeatTable) do
                if (foodMasterKey[v] or v) == (foodMasterKey[type] or type) then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(allEvolvedRecipes, {type = recipe:getUntranslatedName(),name = food:getDisplayName()})
                table.insert(repeatTable,type)
            end
        end
        --pie gets skipped over so have to manually overcorrect, need to make the name different cus of code
        if recipe:getUntranslatedName()== "Pie" then
            table.insert(allEvolvedRecipes, {type = "Pie",name = food:getType()})
        end
    end
    --local missingPie = instanceItem(getScriptManager():getEvolvedRecipe("Pie"):getResultItem())
    --table.insert(allEvolvedRecipes,{type = getScriptManager():getEvolvedRecipe("Pie"):getUntranslatedName(),name = missingPie:getDisplayName()})
    table.sort(allEvolvedRecipes, function(a,b)
        return a.name < b.name
    end)
end
organizeRecipes()
--helper function determines if a food is worthy of being placed in the get every item list, based on its tastiness
--tastiness is the ratio of total hunger reduction to carbohydrates or lipids
local function isFoodTasty(item)
local nutrientValue = SandboxVars.ComfortFoodMod.NutrientLevel
local needFoodHappy = SandboxVars.ComfortFoodMod.BaseHappiness
local hungerChange = math.abs(item:getHungerChange()) * 100
	if not needFoodHappy or item:getUnhappyChange()<0 then
		if (item:getCarbohydrates()*nutrientValue>=hungerChange or item:getLipids()*nutrientValue>=hungerChange) then
			return true
		end
	end
	return false
end
--helper function fetchs every food type item that pases the tasty test and isnt poisonous, then sorts it alphabetically
-- and returns it as a table
local function getEveryItem()
    local allFood = {}
    for j = 0, allItems:size() - 1 do
        local scriptItem = allItems:get(j)
        local fullName = scriptItem:getFullName()
        -- 1. Create the physical item so isFoodTasty can check nutrients
        local v = instanceItem(fullName)
        -- 2. Validate it is actually a Food item
        if v and instanceof(v, "Food") then
            -- 3. Check your safety and taste criteria
            if v:getDisplayCategory() == "Food" and v:getHungerChange() < 0 and v:getPoisonPower() <= 0 then
                if isFoodTasty(v) then
                    -- 4. Get the Type (e.g., "Apple") and put it in the list
                    table.insert(allFood, {type = v:getType(), name = v:getDisplayName()}) 
                end
            end
        end
    end
    table.sort(allFood, function(a, b)
        if a.name ~= b.name then
            return a.name < b.name
        else
            return a.type < b.type -- Sort by type if names are identical
        end
    end)
    return allFood
end
--helper function finds the type from the display name so it can be used in code
local function lookupType(name,list)
    for i,v in pairs(list) do
        if name == v.name then
            return v.type
        end
    end
    return name
end
--helper function resets all the ingredients adnd spices when a diffferent food is picked, then sorts them
--notice how ingreidents use getfulltype while food gettype, this is due to it having to match
-- the getSpices and GetExtraItems commands, which get the strings as a fulltype.
local function createIngredientandSpiceList(foodName)
    avaIngredientsList = {}
    avaSpicesList = {}
    staticIngredientList = {}
    staticIngredientList = {}
    local showDisplayName = SandboxVars.ComfortFoodMod.tranCharName
    local recipeName = lookupType(foodName, allEvolvedRecipes)
    --local recipe = getScriptManager():getEvolvedRecipe(recipeName)
    local realIngredients = getScriptManager():getEvolvedRecipe(recipeName):getPossibleItems()
    for i=0, realIngredients:size()-1 do
        local item = realIngredients:get(i)
        local checkItem = instanceItem(item:getFullType())
        if checkItem:isSpice() then
            if showDisplayName then
                table.insert(staticSpicesList,{type = checkItem:getFullType(),name = checkItem:getDisplayName()})
                table.insert(avaSpicesList,checkItem:getDisplayName())
            else
                table.insert(staticSpicesList,{type = checkItem:getFullType(),name = checkItem:getType()})
                table.insert(avaSpicesList,checkItem:getType())
            end
        else
             if showDisplayName then
                table.insert(staticIngredientList, {type = checkItem:getFullType(),name = checkItem:getDisplayName()})
                table.insert(avaIngredientsList, checkItem:getDisplayName())
             else
                table.insert(staticIngredientList, {type = checkItem:getFullType(),name = checkItem:getType()})
                table.insert(avaIngredientsList, checkItem:getType())
             end
        end
    end
    --gets the maximum amount of ingredients that can be put into a recipe
    maxIngredients = getScriptManager():getEvolvedRecipe(recipeName):getMaxItems()
    table.sort(avaIngredientsList)
    table.sort(avaSpicesList)
end
--helper function changes the preview text of the parameters provided
local function createPreivewText(ingre,spice)
    local text = ""
    for i,v in pairs(usedIngredientsList) do
        text = text .. "  " .. v
    end
    ingre:setName(text)
    text = ""
    for i,v in pairs(usedSpiceList) do
        text = text .. "  " .. v
    end
    spice:setName(text)
end
local translations ={
    "IGUI_SelectComfortFood",
    "IGUI_RecipeMoreIngre",
    "IGUI_ToggleItem",
    "IGUI_UndoSelect",
    "IGUI_RandomFood",
    "IGUI_MinimumMet",
    "IGUI_NeedIngre"
}
--function creats every single button and interactable in the menu
function CharacterCreationMain:MakeFoodDropdowns()
    self.favLabel = ISLabel:new(5, 605, FONT_HGT_MEDIUM, getText("IGUI_SelectComfortFood"), 1, 1, 1, 1, UIFont.Medium, true);
    self.favLabel:initialise();
    self.favLabel:instantiate();
    self.previewFoodText = ISLabel:new(5, 777, FONT_HGT_SMALL, "", 1, 1, 1, 1, UIFont.Small, true);
    self.previewFoodText:initialise();
    self.previewFoodText:instantiate();
    self.previewIngreText = ISLabel:new(10, 797, FONT_HGT_SMALL, "", 1, 1, 1, 1, UIFont.Small, true);
    self.previewIngreText:initialise();
    self.previewIngreText:instantiate();
    self.previewSpiceText = ISLabel:new(10, 812, FONT_HGT_SMALL, "", 1, 1, 1, 1, UIFont.Small, true);
    self.previewSpiceText:initialise();
    self.previewSpiceText:instantiate()
    self.foodWarningLabel = ISLabel:new(10,620,FONT_HGT_MEDIUM,getText("IGUI_RecipeMoreIngre"),1,1,1,1,UIFont.Small,true)
    self.foodWarningLabel:initialise()
    self.foodWarningLabel:instantiate()
    self:addChild(self.foodWarningLabel);
    self:addChild(self.previewFoodText);
    self:addChild(self.previewIngreText);
    self:addChild(self.previewSpiceText);
    self:addChild(self.favLabel); 
    local undoText = getText("IGUI_UndoSelect")
    local randomText = getText("IGUI_RandomFood")
    local undoTextSize = getTextManager():MeasureStringX(UIFont.Small,undoText)
    local randomTextSize = getTextManager():MeasureStringX(UIFont.Small,randomText)
    local randomX = 300
    local undoX = 180
    local toggleText = getText("IGUI_ToggleItem")
    local toggleTextSize = getTextManager():MeasureStringX(UIFont.Small,toggleText)
    self.unEvoCombo = ISComboBox:new(180, 600, 258, 40, self,self.SalonFavoriteFoodSelected);
    self.EvoCombo = ISComboBox:new(180, 600, 258, 40, self,self.SalUpdateEvolvedFoodDropdowns);
        --determines where the random buttons x placement will be based on if space for it is avalible 
    if undoTextSize+randomTextSize>248 then
        randomX = undoX + undoTextSize + 10
    else
        --dont know why but it works so ill leave it
        randomX = 470 - randomTextSize
    end
    self.SalUndoButton = ISButton:new(undoX,650, 100, 20, undoText, self, self.SalDeleteUsedItem)
    self.SalUndoButton:initialise()
    self.SalUndoButton:instantiate()
    self.characterPanel:addChild(self.SalUndoButton)
    self.toggleBtn = ISButton:new(max(0,(self.SalUndoButton:getX()/2)-(toggleTextSize/2)),695, 100, 20, toggleText, self, self.SalonToggleCombo)
    self.SalRandomFoodButton = ISButton:new(randomX,650,randomTextSize,20,randomText,self,self.SalRandomizeFoodOption)
    self.SalRandomFoodButton:initialise()
    self.SalRandomFoodButton:instantiate()
    self.characterPanel:addChild(self.SalRandomFoodButton);

    --makes the evolved recipes by their names.
    for i,v in pairs(allEvolvedRecipes) do
        self.EvoCombo:addOption(v.name)
    end


    self.IngreCombo = ISComboBox:new(180, 675, 35, 35, self,self.SalUpdateIngredientDropdown);
    self.IngreCombo:initialise();
    self.IngreCombo:instantiate();
    self.characterPanel:addChild(self.IngreCombo);
    self.SpiceCombo = ISComboBox:new(180, 710, 35, 35, self,self.SalUpdateSpiceDropdown);
    self.SpiceCombo:initialise();
    self.SpiceCombo:instantiate();
    self.characterPanel:addChild(self.SpiceCombo);
    self.EvoCombo:initialise();
    self.EvoCombo:instantiate();
    self.characterPanel:addChild(self.EvoCombo);
    table.insert(self.characterPanel.comboResizeTable, self.EvoCombo)
    table.insert(self.characterPanel.comboResizeTable, self.SpiceCombo)
    table.insert(self.characterPanel.comboResizeTable, self.IngreCombo)
    -- does the calculation after the code has run for a little to make sure script manager is fully loaded
    allFoods = getEveryItem()
    for _, food in ipairs(allFoods) do
		self.unEvoCombo:addOption(food.name);
	end
    self.unEvoCombo:initialise();
    self.unEvoCombo:instantiate();
    self.toggleBtn:initialise()
    self.toggleBtn:instantiate()
    table.insert(self.characterPanel.comboResizeTable, self.unEvoCombo)
    self.characterPanel:addChild(self.unEvoCombo);
    self:addChild(self.toggleBtn)
    self.toggleBtn:setVisible(false)
    self.unEvoCombo:setVisible(false) 
end
--function activates on evolved dropdown press, and activates the ingredient and spices function, while also putting all
--of the ingredients and spices intot here respective combo boxes
function CharacterCreationMain:SalUpdateEvolvedFoodDropdowns()
    local selectedEvolvedFood = self.EvoCombo:getOptionText(self.EvoCombo.selected)
    currentFood = tostring(selectedEvolvedFood)
    self.previewFoodText:setName(currentFood)
    self.IngreCombo:clear()
    self.SpiceCombo:clear()
    self.IngreCombo:setVisible(true)
    self.SpiceCombo:setVisible(true)
    createIngredientandSpiceList(currentFood)
    for i,v in ipairs(avaIngredientsList) do
        self.IngreCombo:addOption(v)
    end
    for i,v in ipairs(avaSpicesList) do
        self.SpiceCombo:addOption(v)
    end
    usedIngredientsList = {}
    usedSpiceList = {}
    -- kinda janky way to make sure the toggle button comes on if the evolved recipes setting is off
    if SandboxVars.ComfortFoodMod.MustEvolvedRecipe then
        self.toggleBtn:setVisible(false)
    else 
        self.toggleBtn:setVisible(true)
    end
    self.foodWarningLabel:setName(getText("IGUI_RecipeMoreIngre"))
    minimumMet = false
    EvolvedFood = true
    createPreivewText(self.previewIngreText,self.previewSpiceText)
end
--function updates the spice dropdown and spice list on clicking the spice combo box
function CharacterCreationMain:SalUpdateSpiceDropdown()
    local selectedSpice = self.SpiceCombo:getOptionText(self.SpiceCombo.selected)
    local minimumNeeded = SandboxVars.ComfortFoodMod.MinimumIngreidentsNeeded
    if #usedIngredientsList > 0 and EvolvedFood then
        table.insert(usedSpiceList, selectedSpice)
        if #usedIngredientsList + #usedSpiceList >= minimumNeeded then
            self.foodWarningLabel:setName(getText("IGUI_MinimumMet"))
            minimumMet = true
        end
        self.SpiceCombo:clear()
        local count = 0
        if #usedSpiceList >= 5 then
            self.SpiceCombo:setVisible(false)
        else
            self.SpiceCombo:setVisible(true)
        end
        for i,v in pairs(avaSpicesList) do
            local found = false
            for k, u in pairs(usedSpiceList) do
                if v == u then
                    table.remove(avaSpicesList, i)
                    found = true
                    break
                end
            end
            if not found then
                self.SpiceCombo:addOption(v)
            end
        end
        createPreivewText(self.previewIngreText,self.previewSpiceText)
    else
        self.previewSpiceText:setName(getText("IGUI_NeedIngre"))   
    end
end
--function deletes the last used item in the list, starting with spices then ingredients
function CharacterCreationMain:SalDeleteUsedItem()
    self.SpiceCombo:clear()
    self.IngreCombo:clear()
    local minimumNeeded = SandboxVars.ComfortFoodMod.MinimumIngreidentsNeeded
    if #usedSpiceList > 0 then
        table.insert(avaSpicesList, usedSpiceList[#usedSpiceList])
        table.remove(usedSpiceList, #usedSpiceList)
    elseif #usedIngredientsList > 0 then
        table.insert(avaIngredientsList, usedIngredientsList[#usedIngredientsList])
        table.remove(usedIngredientsList, #usedIngredientsList)
    end
    if #usedIngredientsList + #usedSpiceList <= minimumNeeded then
        self.foodWarningLabel:setName(getText("IGUI_RecipeMoreIngre"))
        minimumMet = false
    end
    for i,v in ipairs(avaSpicesList) do
        self.SpiceCombo:addOption(v)
    end
    for i,v in ipairs(avaIngredientsList) do
        self.IngreCombo:addOption(v)
    end 
    if #usedIngredientsList >= maxIngredients then
        self.IngreCombo:setVisible(false)
    else
        self.IngreCombo:setVisible(true)
    end
    if #usedSpiceList >= 5 then
        self.SpiceCombo:setVisible(false)
    else
        self.SpiceCombo:setVisible(true)
    end
    createPreivewText(self.previewIngreText,self.previewSpiceText)
end
--function updates the ingredients dropdown and ingredients list on clicking its combo box, 
--also checks if the no repeat ingredients setting is turned on to reset the combo box if so
function CharacterCreationMain:SalUpdateIngredientDropdown()
    local selectedIngredient = self.IngreCombo:getOptionText(self.IngreCombo.selected)
    local minimumNeeded = SandboxVars.ComfortFoodMod.MinimumIngreidentsNeeded
    if EvolvedFood then
        table.insert(usedIngredientsList, selectedIngredient)
        if #usedIngredientsList + #usedSpiceList >= minimumNeeded then
            self.foodWarningLabel:setName(getText("IGUI_MinimumMet"))
            minimumMet = true
        end
        if #usedIngredientsList >= maxIngredients then
            self.IngreCombo:setVisible(false)
        else
            self.IngreCombo:setVisible(true)
        end
        if SandboxVars.ComfortFoodMod.NoRepeatIngredients then
            self.IngreCombo:clear()
            for i,v in pairs(avaIngredientsList) do
                local found = false
                for k, u in pairs(usedIngredientsList) do
                    if v == u then
                        table.remove(avaIngredientsList, i)
                        found = true
                        break
                    end
                end
                if not found then
                    self.IngreCombo:addOption(v)
                end
            end
        end
    end
    createPreivewText(self.previewIngreText,self.previewSpiceText)
end
--function toggles on and off the standerd food types and the recipe food types and their respective UI
function CharacterCreationMain:SalonToggleCombo()
    if self.EvoCombo:isVisible() and (not SandboxVars.ComfortFoodMod.MustEvolvedRecipe) then
        self.unEvoCombo:setVisible(true)
        self.EvoCombo:setVisible(false)
        self.IngreCombo:setVisible(false)
        self.SpiceCombo:setVisible(false)
        self.SalRandomFoodButton:setVisible(false)
        self.SalUndoButton:setVisible(false)
    else
        self.unEvoCombo:setVisible(false)
        self.EvoCombo:setVisible(true)
        self.IngreCombo:setVisible(true)
        self.SpiceCombo:setVisible(true)
        self.SalRandomFoodButton:setVisible(true)
        self.SalUndoButton:setVisible(true)
    end
    usedIngredientsList = {}
    usedSpiceList = {}
    createPreivewText(self.previewIngreText,self.previewSpiceText)
end
--function activates on non recipe foods being selected, and sets the food to said food
function CharacterCreationMain:SalonFavoriteFoodSelected(combo)
    -- This gets the text of the option you clickeda
    
    currentFood = combo:getOptionText(combo.selected)
    usedIngredientsList = {}
    usedSpiceList = {}
    self.foodWarningLabel:setName("")
    minimumMet = true
    EvolvedFood = false
    self.previewFoodText:setName(currentFood)
    createPreivewText(self.previewIngreText,self.previewSpiceText)
end
--function activates on randomize button to randomize the food type given to the player
function CharacterCreationMain:SalRandomizeFoodOption()
    local minimumNeeded = SandboxVars.ComfortFoodMod.MinimumIngreidentsNeeded
    local mustEvo = SandboxVars.ComfortFoodMod.MustEvolvedRecipe
    local randomRec = {}
    usedIngredientsList = {}
    usedSpiceList = {}
    self.IngreCombo:setVisible(false)
    self.SpiceCombo:setVisible(false)
    if ZombRand(2) == 1 and (not mustEvo) then
        --heresal
        EvolvedFood = false
        currentFood = allFoods[ZombRand(#allFoods)+1].name
        self.foodWarningLabel:setName("")
    else
        for i, v in pairs(allEvolvedRecipes) do
            table.insert(randomRec, v.name)
        end
        --lists in lua start from one, this rand function starts at 0, so I need to add one after it to calibrate correctly
        --heresal
        EvolvedFood = true
        currentFood = randomRec[ZombRand(#randomRec)+1]
        createIngredientandSpiceList(currentFood)
        --have to add spice calibration ebcause some recipes dont have 5 seperate spices
        local SpiceCali = 5
        if #avaSpicesList<5 then
            SpiceCali = #avaSpicesList
        end
        --Safety killswitch incase bad roles happen or a bug sneaks through with while statement
        local killSwitch = 0
        while killSwitch<20 do
            local total = #usedIngredientsList + #usedSpiceList
            killSwitch = killSwitch + 1
            if total<minimumNeeded or ZombRand(3)<2 then
                if ZombRand(2)==1 or #usedIngredientsList<1 then
                    if #usedIngredientsList < maxIngredients then
                        local chosenVar = ZombRand(#avaIngredientsList)+1
                        --heresal
                        table.insert(usedIngredientsList,avaIngredientsList[chosenVar])
                        table.remove(avaIngredientsList,chosenVar)
                    end
                else
                    if #avaSpicesList > 0 and #usedSpiceList<5 then
                        local chosenVar = ZombRand(#avaSpicesList)+1
                        --heresal
                        table.insert(usedSpiceList,avaSpicesList[chosenVar])
                        table.remove(avaSpicesList,chosenVar)
                    end
                end
            else
                break
            end
            if total>maxIngredients+SpiceCali then
                break
            end
        end
        self.foodWarningLabel:setName(getText("IGUI_MinimumMet"))
    end
    --local randomRecipe
    --createIngredientandSpiceList(selectedEvolvedFood)
    self.previewFoodText:setName(currentFood)
    createPreivewText(self.previewIngreText,self.previewSpiceText)
    minimumMet = true
end
--function runs on the game creating the UI, directly after lua has loaded essentially, and activates the
--make food dropdowns function
local OGCharacterCreationMainCreate = CharacterCreationMain.create
function CharacterCreationMain:create()
    OGCharacterCreationMainCreate(self);
	self:MakeFoodDropdowns();
end
--helper function creates the modData for the player and properly formats it using the []
local function setPlayerModData()
    local player = getPlayer()
    local modData = player:getModData()
    --food organizers, convert the names into the types to be stored
    if EvolvedFood then
        currentFood = lookupType(currentFood,allEvolvedRecipes) 
        currentFood = foodMasterKey[getScriptManager():getEvolvedRecipe(currentFood):getResultItem()] or getScriptManager():getEvolvedRecipe(currentFood):getResultItem()
    else
        currentFood = lookupType(currentFood,allFoods)
    end
    for i,v in pairs(usedIngredientsList) do
        local type = lookupType(v,staticIngredientList)
        usedIngredientsList[i] = getScriptManager():getItem(type):getFullName()
    end
    for i,v in pairs(usedSpiceList) do
        local type = lookupType(v,staticSpicesList)
        usedSpiceList[i] = getScriptManager():getItem(type):getFullName()
    end
    --stores the food data
    if minimumMet then
        if SandboxVars.ComfortFoodMod.SeperateOriginalFav  then
            modData.salsOriginalFav = modData.salsOriginalFav or {}
            modData.salsOriginalFav[1] = {name = currentFood, ingredients = usedIngredientsList, spices = usedSpiceList}
        else
            modData.salsFavoritedFood = modData.salsFavoritedFood or {}
            modData.salsFavoritedFood[1] = {name = currentFood, ingredients = usedIngredientsList, spices = usedSpiceList, rankInQueue = 0}
        end
    end
	modData.salsQueuedFood = modData.salsQueuedFood or {}
	modData.salsFavoritedFood = modData.salsFavoritedFood or {}
	modData.salsFoodMemory = modData.salsFoodMemory or {}
	modData.salsCFModVersion = MOD_VERSION
    player:transmitModData()
end
--once the player is created, gives the player the modData from the helper function
Events.OnCreatePlayer.Add(setPlayerModData)