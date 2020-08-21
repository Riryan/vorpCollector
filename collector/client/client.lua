showcoords = false
hasCollected = false
ActiveShovel = false
ActiveMetal =  false

Citizen.CreateThread(function()
    SetupCollectPrompt()
    SetupDigPrompt()
    TriggerServerEvent("collector:AddPlayer") 
    while true do
        Wait(0)
        --copy paste of Getting coords not needed after debugging
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        if showcoords then 
          print(coords)
          Wait (10000)
        end

        for i, row in pairs(PickUps)do
            local myV = vector3(coords)
            local collectableV = vector3(PickUps[i]["x"], PickUps[i]["y"], PickUps[i]["z"])
            local dst = Vdist(collectableV, myV)
            if dst < 2 then
                if not hasCollected then
                    PromptSetEnabled(CollectPrompt, true)
                    PromptSetVisible(CollectPrompt, true)
                    if PromptHasHoldModeCompleted(CollectPrompt) then 
                        PromptSetEnabled(CollectPrompt, false)
                        PromptSetVisible(CollectPrompt, false)
                        hasCollected= true
                        pickupAnim()
                        item = PickUps[i]["name"]
                        type = PickUps[i]["type"]
                       --TriggerServerEvent("collector:AddXP")
                       TriggerEvent("vorp:TipRight", "+100 Collector XP", 2000)
                       TriggerServerEvent("collector:AddCollectable",item, type) -- Add to the Database Function here
                       break
                    end
                end
            else
                PromptSetEnabled(CollectPrompt, false)
                PromptSetVisible(CollectPrompt, false)
            end
        end
        --stage 2
        if ActiveShovel then
           -- TriggerEvent("vorp:getCharacter",source,function(user) end) --look for Shovel in users Inv
            for i, row in pairs(Shovel)do
                local myV = vector3(coords)
                local collectableV = vector3(Shovel[i]["x"], Shovel[i]["y"], Shovel[i]["z"])
                local dst = Vdist(collectableV, myV)
                if dst < 1 then
                    if not hasCollected then
                        PromptSetEnabled(DigPrompt, true)
                        PromptSetVisible(DigPrompt, true)
                        if PromptHasHoldModeCompleted(DigPrompt) then 
                            PromptSetEnabled(DigPrompt, false)
                            PromptSetVisible(DigPrompt, false)
                            hasCollected= true
                            shovelAnim()
                           -- TriggerServerEvent("collector:AddXP")
                           break
                        end
                    end
                else
                    PromptSetEnabled(DigPrompt, false)
                    PromptSetVisible(DigPrompt, false)
                end
            end
        end
        --stage 3
        if ActiveMetal then
        end
	end
end)
--pickup anims
function pickupAnim()
    -- world_human_bottle_pickup --maybe?!?
end
function shovelAnim()
    -- world_human_bottle_pickup --maybe?!?
end
--Prompt Setup here
function SetupCollectPrompt ()
	Citizen.CreateThread(function()
        local str = 'COLLECT'
        CollectPrompt  = PromptRegisterBegin()
        PromptSetControlAction(CollectPrompt , 0xDFF812F9) --[[E]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(CollectPrompt , str)
        PromptSetEnabled(CollectPrompt , false)
        PromptSetVisible(CollectPrompt , false)
        PromptSetHoldMode(CollectPrompt , true)
		PromptRegisterEnd(CollectPrompt )
    end)
end
function SetupDigPrompt ()
	Citizen.CreateThread(function()
        local str = 'Dig'
        DigPrompt  = PromptRegisterBegin()
        PromptSetControlAction(DigPrompt , 0xDFF812F9) --[[E]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(DigPrompt , str)
        PromptSetEnabled(DigPrompt , false)
        PromptSetVisible(DigPrompt , false)
        PromptSetHoldMode(DigPrompt , true)
		PromptRegisterEnd(DigPrompt )
    end)
end
-- Collected UI for Selling 
function showUI()
end
function closeUI()
end

