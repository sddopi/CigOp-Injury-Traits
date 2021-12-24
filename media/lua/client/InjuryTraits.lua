require('NPCs/MainCreationMethods');

Suspendevasive = false;

local function initTraits()
    local injured = TraitFactory.addTrait("injured", getText("UI_trait_injured"), -4, getText("UI_trait_injureddesc"), false, false);
    local broke = TraitFactory.addTrait("broke", getText("UI_trait_broke"), -8, getText("UI_trait_brokedesc"), false, false);
end

local function initTraitsPerks(_player)
    local player = _player;
    local damage = 20;
    local bandagestrength = 5;
    local splintstrength = 0.9;
    local fracturetime = 20;
    local scratchtimemod = 15;
    local bleedtimemod = 5;

    if player:HasTrait("injured") then
        Suspendevasive = true;
        local bodydamage = player:getBodyDamage();
        local itterations = ZombRand(1, 4) + 1;
        for i = 0, itterations do
            local randompart = ZombRand(0, 16);
            local b = bodydamage:getBodyPart(BodyPartType.FromIndex(randompart));
            local injury = ZombRand(0, 5);
            local skip = false;
            if b:HasInjury() then
                itterations = itterations + 1;
                skip = true;
            end
            if skip == false then
                if injury <= 1 then
                    b:AddDamage(damage);
                    b:setScratched(true, true);
                    b:setBandaged(true, bandagestrength, true, "Base.AlcoholBandage");
                end
                if injury == 2 then
                    b:AddDamage(damage);
                    b:setBurned();
                    b:setBandaged(true, bandagestrength, true, "Base.AlcoholBandage");
                end
                if injury == 3 then
                    b:AddDamage(damage);
                    b:setCut(true, true);
                    b:setBandaged(true, bandagestrength, true, "Base.AlcoholBandage");
                end
                if injury >= 4 then
                    b:AddDamage(damage);
                    b:setDeepWounded(true);
                    b:setStitched(true);
                    b:setBandaged(true, bandagestrength, true, "Base.AlcoholBandage");
                end
            end
        end
        bodydamage:setInfected(false);
    end
    if player:HasTrait("broke") then
        --print("Broke Leg.");
        Suspendevasive = true;
        local bodydamage = player:getBodyDamage();
        bodydamage:getBodyPart(BodyPartType.LowerLeg_R):AddDamage(damage);
        bodydamage:getBodyPart(BodyPartType.LowerLeg_R):setFractureTime(fracturetime);
        bodydamage:getBodyPart(BodyPartType.LowerLeg_R):setSplint(true, splintstrength);
        bodydamage:getBodyPart(BodyPartType.LowerLeg_R):setSplintItem("Base.Splint");
        bodydamage:getBodyPart(BodyPartType.LowerLeg_R):setBandaged(true, bandagestrength, true, "Base.AlcoholBandage");
        bodydamage:setInfected(false);
    end
end

Events.OnNewGame.Add(initTraitsPerks);
Events.OnGameBoot.Add(initTraits);