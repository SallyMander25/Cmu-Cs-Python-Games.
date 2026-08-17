local MOD_VERSION = 2
--cache big global functions to use later 
local string = string
local table = table
local ipairs = ipairs
local pairs = pairs
local scriptManager = getScriptManager()
--colors to change the text color 
local goldColor = "<RGB:0.73,0.64,0.24>"
local silverColor = "<RGB:0.40,0.64,0.84>" -- more like a blue/diamond but whatever
local bronzeColor = "<RGB:0.8,0.5,0.2>"
local whiteColor = "<RGB:1,1,1>"
--helper function formats the Ingredients and spices properly to be presented in the outputText
local function formatIngredients(foodItem)
	local trueIng = {}
	local trueSpi = {}
	--gets the names of the Ingredients/spices from the modData and converts it
	--into names which are easier for the player to understand
	--print(foodItem.name)
	local trueName = getScriptManager():getItem(foodItem.name):getDisplayName()
	for i,v in ipairs(foodItem.ingredients) do
		trueIng[i] = scriptManager:getItem(v):getDisplayName()
	end
	for i,v in ipairs(foodItem.spices) do
		trueSpi[i] = scriptManager:getItem(v):getDisplayName()
	end
	--checks if the ingredients/spices tables have anything in them then converts them respectivly
	local ingString = (#trueIng > 0) and (getText("IGUI_Char_With") .. table.concat(trueIng, ", ")) or ""
	local spiString = (#trueSpi > 0) and (", " .. table.concat(trueSpi,", ")) or ""
	return trueName, ingString, spiString
end
local translations = {
	"IGUI_Char_Hours",
	"IGUI_Char_OGCom",
	"IGUI_Char_AdaptCom",
	"IGUI_Char_ComFood",
	"IGUI_Char_Rank",
	"IGUI_Char_HourSince",
	"IGUI_Char_FoodQueue",
	"IGUI_Char_NoComFood",
	"IGUI_Char_CurComFood",
	"IGUI_Char_With",
	"IGUI_Char_ComfortFoodInfo",
}
--helper function compiles all the nesscary strings to create the final presented text
local function prepareInfo()
	--modData variables
	local player = getPlayer()
	local modData = player:getModData()
	--checks if the verison is up to date, and reset everything if not to avoid bugs
	-- checks if OGFav is there, tkhen if it is it replaces the local variable with the first and only list in the modData
	--which is in [1]
	local OGFav = modData.salsOriginalFav
	if OGFav then OGFav = OGFav[1] end
	-- the or {} is used to make sure that the code is prepared in case of a nil value, as it will crash
	--if the value is nil and # tries to calculate the table length
    local FavList = modData.salsFavoritedFood or {}
	local queuedList = modData.salsQueuedFood or {}
	--helper variables to create return text
	local outputText = ""
	--current time in hours variable
	local currentTime = getGameTime():getWorldAgeHours()
	--the sandbox Variable determining if queuedFood will be shown
	local showQueue = SandboxVars.ComfortFoodMod.ShowQueuedFood
	--ifs check if the player has the modData
	if OGFav then
		local foodName, ingString, spiString = formatIngredients(OGFav)
		--checks if it has a lastTimeEaten variable, if not since the defult is max effectiveness, just informed the player,
		-- A lot of hours have passed, if there is a variable, it calcuates the time past and returns it,
		--rounding to the nearest hundredths place with "%.2f"
		local timeElapsed
		if OGFav.lastTimeEaten then
			timeElapsed = string.format("%.2f",currentTime - OGFav.lastTimeEaten)
		else
			timeElapsed = getText("IGUI_Char_Hours")
		end
		--adds all the data together in a string.format function.
		outputText = goldColor .. getText("IGUI_Char_OGCom") .. whiteColor..  string.format("%s %s%s\n%s %s\n",
		foodName,ingString,spiString,getText("IGUI_Char_HourSince"),timeElapsed)
		--checks if the favList has any items to add an addtional title based on if the player has an original food
		--or not, if so they will have the title of Adapted comfort foods for their comfort foods, elseif no original
		--food was made but favList still exists, it makes a title called Comfort Foods, else nothing is added
		if #FavList>0 then
			outputText = outputText .. silverColor .. getText("IGUI_Char_AdaptCom") ..  whiteColor
		end
	elseif #FavList>0 then
		outputText = outputText .. silverColor .. getText("IGUI_Char_ComFood") .. whiteColor
	end	
	if #FavList>0 then
		--sorts the table by rank in queue, so the player sees his most powerful comfort food first
		table.sort(FavList, function(a,b)
			return a.rankInQueue< b.rankInQueue 
			end)
		for _,v in pairs(FavList)do
			local foodName, ingString, spiString = formatIngredients(v)
			local timeElapsed
			if v.lastTimeEaten then
				timeElapsed = string.format("%.2f",currentTime - v.lastTimeEaten)
			else
				timeElapsed = getText("IGUI_Char_Hours")
			end
			local foodRank
			if v.rankInQueue then
				foodRank = v.rankInQueue + 1
			else
				foodRank = 1
			end
			outputText = outputText .. getText("IGUI_Char_Rank")..tostring(foodRank) ..   string.format(": %s %s%s\n%s %s\n",
			foodName,ingString,spiString,getText("IGUI_Char_HourSince"),timeElapsed)
			end
		end
	if #queuedList>0 and showQueue then
		table.sort(queuedList, function(a,b)
			return a.addictionLevel > b.addictionLevel 
			end)
		outputText = outputText .. bronzeColor .. getText("IGUI_Char_FoodQueue") .. whiteColor
		for _,v in ipairs(queuedList)do
			if _>5 then
				break
			end
			local foodName,ingString, spiString = formatIngredients(v)
			outputText = outputText ..  string.format("%s %s%s\n%s %s\n",
			foodName,ingString,spiString,getText("IGUI_Char_CurComFood"),(tostring(v.addictionLevel)or tostring(0)))
		end
	end
	--if outputText was never interacted with, the outpit will be whats below
	--print(queuedList,showQueue)
	if outputText == "" then
		outputText = getText("IGUI_Char_NoComFood")
	end
	return outputText
end
local function findWeaponTextSize(weapon)
	local textWid1 = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_char_Favourite_Weapon"))
    local textWid2 = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_char_Zombies_Killed"))
    local textWid3 = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_char_Survived_For"))
    local x = 35 + math.max(textWid1, math.max(textWid2, textWid3)) + getTextManager():MeasureStringX(UIFont.Small, weapon)
	return x
end
--used to activate the original code in the function, so that the game still runs normally while using said function
local genuine_ISCharacterScreen_render = ISCharacterScreen.render
local genuine_ISCharacterScreen_create = ISCharacterScreen.create
local genuine_ISCharacterScreen_loadTraits = ISCharacterScreen.loadTraits
--function runs on the character screen being created once the game starts running, used to fetch the texture of the info panel
-- and add it as a child to the ISCharacterScreen function, the rest is done on render
function ISCharacterScreen:create()
	genuine_ISCharacterScreen_create(self)
	local x = 150
	local y = 200
	local CFTexture = getTexture("media/textures/ComfortFoodBackground1.png")
	self.CFInfoImage = ISImage:new(x,y,CFTexture:getWidthOrig(),CFTexture:getHeightOrig()+10,CFTexture)
	self:addChild(self.CFInfoImage)
	-- variable used for the debounce delay in the render function
	self.salsUpdateTime = -500
	--boolean makes sure render function runs one time once its avalible to the player to properly calibrate everything
	self.salsInitiation = true
	self.salsComfortFoodText = getText("IGUI_Char_ComfortFoodInfo")
	if #self.salsComfortFoodText > 20 then
		self.salsInfoFont = UIFont.Small
		self.salsTextYOffset = 3
	else
		self.salsInfoFont = UIFont.Medium
		self.salsTextYOffset = 6
	end
end
-- function runs as long as the character screen is being displayed to the player
function ISCharacterScreen:render()
	genuine_ISCharacterScreen_render(self)
	if (self.CFInfoImage:isMouseOver()) or self.salsInitiation then
		--timestamp makes code only run every half second when the mouse is over/initiation is on
		local currentTime = getTimestampMs()
		if currentTime-self.salsUpdateTime >=500 then
			--because prepareInfo is such a large function, it should only run exclusivly once its needed, as to not 
			--impact performace unnesscarily
			self.CFInfoImage:setMouseOverText(prepareInfo())
			self.salsUpdateTime = currentTime
			self.salsInitiation = false
		end
	end
	local imageY = self.literatureButton:getY() + self.literatureButton:getHeight()+5
	if self.CFInfoImage:getY() ~= imageY then
		self.CFInfoImage:setY(imageY)
	end
	self:drawTextCentre(self.salsComfortFoodText, self.CFInfoImage:getX()+(self.CFInfoImage:getWidth()/2), self.CFInfoImage:getY()-self.salsTextYOffset,0.83, 0.48, 0.00,1,self.salsInfoFont)
	--changes the x offset if the y is too close to the favroited weapon text
	if self.CFInfoImage:getY()>270 then
		--copied from the other code block in the source, finds the favorite weapons x and uses that
		if self.favouriteWeapon ~= self.salsWeaponMemory then
			self.CFInfoImage:setX(findWeaponTextSize(self.favouriteWeapon))
			self.salsWeaponMemory = self.favouriteWeapon
		end
	elseif self.CFInfoImage:getX() ~= 155 then
		self.CFInfoImage:setX(155)
	end
	--all that optimization to help little timmy with his grandpas computer play PZ
end




--function activates when traits load, which is when the panel is first opened and when the amount traits increase,
--used to set the Y access of the info panel because the literature button needs to be rendered first in able to
--piggyback off their Y and create the nesscary offset, so it stays where it should perfectly 
--seems redundant npw given the code in here runs in render now....
--function ISCharacterScreen:loadTraits()
--	genuine_ISCharacterScreen_loadTraits(self)
--	if self.CFInfoImage then
--		self.CFInfoImage:setY(self.literatureButton:getY() + self.literatureButton:getHeight()+5)
--		print(self.CFInfoImage:getY())
--		if self.CFInfoImage:getY()>270 then
--			self.CFInfoImage:setX(210)
--		else
--			self.CFInfoImage:setX(155)
--		end
--	end
--end