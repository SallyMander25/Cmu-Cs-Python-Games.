local lastFallAttempt = {}
local max = math.max
local min = math.min

local function charFallChance(plr)
    local plrNum = plr:getPlayerNum()
    local nimbleCoef = SandboxVars.footballMod.nimbleCoef
    local chance = plr:getPerkLevel(PerkFactory.Perks.Nimble)*nimbleCoef
    local time = getTimestampMs()
    --debounce delay to make sure that if it triggers it cant be untriggered by hitting another zmbie
    if lastFallAttempt[plrNum] and time - lastFallAttempt[plrNum] < 2700 then return true end

    local footballMulti = SandboxVars.footballMod.fallChance
    if plr:hasTrait(SalsFootballMod.CharacterTrait.FOOTBALL_PLAYER) then
        chance = max(footballMulti,chance*footballMulti)
    end
    local isFall = ZombRand(100)>chance
    ---print("is he gonna fall? ", isFall)
    if isFall then lastFallAttempt[plrNum] = time end
    return isFall
end
local function zombieDirectionPushed(plr,zomb)
    --if the zomboid is not a sprinter and sprinters only is turned on 
    if zomb:getSpeedType()~=1 and SandboxVars.footballMod.SprinterDif then return true end
    local closePercentage = SandboxVars.footballMod.headOnAmount-0.5
    local dx = zomb:getX() - plr:getX()
    local dy = zomb:getY() - plr:getY()
    local moveVec = plr:getMovementLastFrame()
    local dotProduct = (moveVec:getX() * dx) + (moveVec:getY() * dy)
    --print(dotProduct)
    --ensures that all sprinters that activate the bump logic are being ran at by the player
    --for balancing and such
    return dotProduct>closePercentage
end
local function zombieFall(char,zomb)
    if instanceof(char,"IsoPlayer") and zomb:isZombie() then
        --allows the fall to be canceled in charfallchance allows it
        if char:isBumpFall() then char:setBumpFall(charFallChance(char)) end
        --char:setBumpFall(false)
        --print(zombieDirectionPushed(char,zomb))
        if char:isRunning() and SandboxVars.footballMod.NeedSprint then return end
        local plrFitness = char:getPerkLevel(PerkFactory.Perks.Fitness)
        local fitnessSubtractor = SandboxVars.footballMod.FitnessSub
        local enduranceTaken = SandboxVars.footballMod.EnduranceBase/max(1,plrFitness-fitnessSubtractor)
        local stats = char:getStats()
        local currentEndurance = stats:get(CharacterStat.ENDURANCE)
        local EnduranceOnHit = SandboxVars.footballMod.EnduranceOnSuccess
        if (char:isRunning() or char:isSprinting()) and zombieDirectionPushed(char,zomb) then
            --if zomb:getSpeedType()==1 then print("uh oh") end  ---the sprinter zomboid
            if not EnduranceOnHit then stats:set(CharacterStat.ENDURANCE,max(0.001,currentEndurance-enduranceTaken)) end
            local isBaseKnockNumber = SandboxVars.footballMod.setBaseKnock
            local strength = char:getPerkLevel(PerkFactory.Perks.Strength)
            local pushOverPotential = 0
            if isBaseKnockNumber > 0 then
                pushOverPotential = isBaseKnockNumber
            else
                local strengthCoef = SandboxVars.footballMod.StrengthCoef
                local strengthSubtract = SandboxVars.footballMod.StrengthSub
                local sprintingCoef = SandboxVars.footballMod.SprintingCoef
                local playerAmount = SandboxVars.footballMod.playerPushAmount
                local footballObjectAdd = SandboxVars.footballMod.footballObject
                pushOverPotential = (strength-strengthSubtract)*strengthCoef
                if char:hasTrait(SalsFootballMod.CharacterTrait.FOOTBALL_PLAYER) then pushOverPotential = pushOverPotential + playerAmount end
                if char:isSprinting() then pushOverPotential = max(1,pushOverPotential)*sprintingCoef end
                -- need to check the hand for if anythings their before I try to get type else it will give errors and not run
                if footballObjectAdd > 0 and 
                ((char:getPrimaryHandItem() and char:getPrimaryHandItem():getType()=="Football") or
                 (char:getSecondaryHandItem() and char:getSecondaryHandItem():getType()=="Football")) then
                    pushOverPotential = pushOverPotential + footballObjectAdd
                end
            end
            local willPushOver = ZombRand(100)<pushOverPotential
            zomb:setKnockedDown(willPushOver)
            if willPushOver and EnduranceOnHit then stats:set(CharacterStat.ENDURANCE,max(0.001,currentEndurance-enduranceTaken)) end
            if willPushOver then zomb:setBumpStaggered(false) end
            --doesnt work, seems like will need to wait till a bug fix to allow stats to be modded
            --sendPlayerStat(char,CharacterStat.ENDURANCE)
            --syncPlayerStats(char,SyncPlayerStatsPacket.getBitMaskForStat(CharacterStat.ENDURANCE));
        end
    end
end
Events.OnCharacterCollide.Add(zombieFall)