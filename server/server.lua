local RSGCore = exports['rsg-core']:GetCoreObject()

-- check player has the ingredients
RSGCore.Functions.CreateCallback('rsg-blacksmith:server:checkingredients', function(source, cb, ingredients)
    local src = source
    local hasItems = false
    local icheck = 0
    local Player = RSGCore.Functions.GetPlayer(src)
    for k, v in pairs(ingredients) do
        if Player.Functions.GetItemByName(v.item) and Player.Functions.GetItemByName(v.item).amount >= v.amount then
            icheck = icheck + 1
            if icheck == #ingredients then
                cb(true)
            end
        else
            TriggerClientEvent('RSGCore:Notify', src, Lang:t('lang_12'), 'error')
            cb(false)
            return
        end
    end
end)

-- finish crafting
RegisterServerEvent('rsg-blacksmith:server:finishcrafting')
AddEventHandler('rsg-blacksmith:server:finishcrafting', function(ingredients, receive, giveamount, job)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    -- remove ingredients
    for k, v in pairs(ingredients) do
        if Config.Debug == true then
            print(v.item)
            print(v.amount)
        end
        Player.Functions.RemoveItem(v.item, v.amount)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[v.item], "remove")
    end
    -- add stock to weaponsmith
    MySQL.query('SELECT * FROM blacksmith_stock WHERE blacksmith = ? AND item = ?',{job, receive} , function(result)
        if result[1] ~= nil then
            local stockadd = result[1].stock + giveamount
            MySQL.update('UPDATE blacksmith_stock SET stock = ? WHERE blacksmith = ? AND item = ?',{stockadd, job, receive})
        else
            MySQL.insert('INSERT INTO blacksmith_stock (`blacksmith`, `item`, `stock`) VALUES (?, ?, ?);', {job, receive, giveamount})
        end
    end)
end)
