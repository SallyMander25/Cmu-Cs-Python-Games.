--changes the nil footbal player trait to the regular on
local function replaceNilFootballPlayer()
    local player = getPlayer()
    if not player then return end
    if not player:hasTrait(SalsFootballMod.CharacterTrait.FOOTBALL_PLAYER_NIL) then 
        Events.EveryOneMinute.Remove(replaceNilFootballPlayer)
        return 
    end
    sendClientCommand("SalsFootballMod","changeFootballPerk",{})
end
--does it every minute instead of oncreate plyaer because sometimes the server is offline by the time the character is
--considered created, leading to desync and errors, so just runs the code till it works every minute instead
Events.EveryOneMinute.Add(replaceNilFootballPlayer)
