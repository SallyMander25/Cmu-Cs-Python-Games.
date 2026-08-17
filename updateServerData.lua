
print("Loaded Server Script")
local max = math.max
local min = math.min
local Server = isServer()
local relevantMoodles = {MoodleType.WET,MoodleType.HYPOTHERMIA,MoodleType.HYPERTHERMIA}
local function handleFootballPlayer(player)
    --need to get all body locaitons for clothing, tally up the discomfort from said clothing on all locations, and then remove it
    if not player:hasTrait(SalsFootballMod.CharacterTrait.FOOTBALL_PLAYER) then return end
    local stats = player:getStats()
    --redos the discomfort equation and purposefully discludes clothingDiscomfort
    --local clothingDiscomfort = player:getClothingDiscomfortModifier()*100
    local currentDiscomfort = stats:get(CharacterStat.DISCOMFORT)
    if currentDiscomfort > 0 then
        local otherDiscomfort = player:getVehicleDiscomfortModifier()*100
        local playerMoodles = player:getMoodles()
        for i=1, #relevantMoodles do
            otherDiscomfort = otherDiscomfort + playerMoodles:getMoodleLevel(relevantMoodles[i])*10
        end
        if currentDiscomfort > otherDiscomfort then
            stats:set(CharacterStat.DISCOMFORT,min(100,max(0,otherDiscomfort)))
        end
    end
end


local function makeCorrectFootballPerk(module,command,player,args)
    if module ~= "SalsFootballMod" then return end
    if command == "changeFootballPerk" then
        if not player:hasTrait(SalsFootballMod.CharacterTrait.FOOTBALL_PLAYER) then
            player:getCharacterTraits():remove(SalsFootballMod.CharacterTrait.FOOTBALL_PLAYER_NIL)
            player:getCharacterTraits():add(SalsFootballMod.CharacterTrait.FOOTBALL_PLAYER)
        end
    end
end

Events.OnPlayerUpdate.Add(handleFootballPlayer)

Events.OnClientCommand.Add(makeCorrectFootballPerk)