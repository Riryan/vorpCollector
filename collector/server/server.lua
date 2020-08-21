RegisterServerEvent('collector:AddPlayer')
    AddEventHandler('collector:AddPlayer',function(src)
        local identifiers = ExtractIdentifiers()
        local steam = identifiers.steam
        exports.ghmattimysql:scalar("SELECT `identifier` FROM collectables WHERE identifier = @identifier",
        { ['@identifier'] = steam}, function (results)
            if results == steam then
                -- Add Welcome Back Message 
            else
                exports.ghmattimysql:execute("INSERT INTO collectables (identifier, xp, lvl) VALUES (@identifier, @xp, @lvl)",
                { ['@identifier'] = steam, ['@xp'] = 1, ['@lvl'] = 0})
                -- send a Welcome to Collectables message 
            end
    end)
end)

RegisterServerEvent('collector:AddXP') -- this updates XP
    AddEventHandler('collector:AddXP', function(src)
        local identifiers = ExtractIdentifiers()
        local steam = identifiers.steam
        exports.ghmattimysql:scalar("SELECT `xp` FROM collectables WHERE identifier = @identifier",
        { ['@identifier'] = steam}, function (results)
            oldXP = results
            AddXP = results + 100
            CheckLevel = AddXP / 2000 -- this is the leveling system for now
                --add a Check for Item useage
            VORP.addNewCallBack("CollectorLevel", function(src, call) -- Not sure about this being right.
            local _source = src
            call(CheckLevel)
        end)

        if CheckLevel < 20 then  --20 is cap for now
            exports.ghmattimysql:execute("UPDATE collectables SET `xp` = @xp WHERE identifier = @identifier", 
            { ['@identifier'] = steam, ['@xp'] = AddXP})
        end
    end)
end)

RegisterServerEvent('collector:AddCollectable')
    AddEventHandler('collector:AddCollectable', function(item, type)
        local identifiers = ExtractIdentifiers()
        local steam = identifiers.steam
        DBType = type
        exports.ghmattimysql:scalar("SELECT `"..DBType.."` FROM collectables WHERE identifier = @identifier",
        { ['@identifier'] = steam}, function (results)
            AppendItems =  results,item --I need to take the old item and Add it with the new item 
            exports.ghmattimysql:execute("UPDATE collectables SET `"..DBType.."` = @"..DBType.." WHERE identifier = @identifier", 
            { ['@identifier'] = steam, ['@'..DBType..''] = item})
            print(type, AppendItems)
        end)
end)

function ExtractIdentifiers()
    local identifiers = {steam = ""}
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        end
    end
    return identifiers
end



