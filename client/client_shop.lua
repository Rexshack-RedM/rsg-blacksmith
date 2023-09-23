local RSGCore = exports['rsg-core']:GetCoreObject()
local currentblacksmithshop = nil
local currentjob = nil
local isboss = nil

-------------------------------------------------------------------------------------------
-- prompts and blips
-------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    for _, v in pairs(Config.BlacksmithShops) do
        exports['rsg-core']:createPrompt(v.shopid, v.coords, RSGCore.Shared.Keybinds[Config.Keybind], Lang:t('lang_s1'), {
            type = 'client',
            event = 'rsg-blacksmith:client:blacksmithshopMenu',
            args = { v.jobaccess, v.shopid },
        })
        if v.showblip == true then
            local BlacksmithShopBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(BlacksmithShopBlip,  joaat(Config.ShopBlip.blipSprite), true)
            SetBlipScale(Config.ShopBlip.blipScale, 0.2)
            Citizen.InvokeNative(0x9CB1A1623062F402, BlacksmithShopBlip, Config.ShopBlip.blipName)
        end
    end
end)

-------------------------------------------------------------------------------------------
-- Menu
-------------------------------------------------------------------------------------------

RegisterNetEvent('rsg-blacksmith:client:blacksmithshopMenu', function(jobaccess, shopid)
    local PlayerData = RSGCore.Functions.GetPlayerData()
    currentblacksmithshop = shopid
    currentjob = PlayerData.job.name
    isboss = PlayerData.job.isboss
    if currentjob == jobaccess and isboss == true then
        lib.registerContext({
            id = 'blacksmith_owner_shop_menu',
            title = Lang:t('lang_s2'),
            options = {
                {
                    title = Lang:t('lang_s3'),
                    description = Lang:t('lang_s4'),
                    icon = 'fa-solid fa-store',
                    serverEvent = 'rsg-blacksmithshop:server:GetShopItems',
                    args = { id = shopid },
                    arrow = true
                },
                {
                    title = Lang:t('lang_s5'),
                    description = Lang:t('lang_s6'),
                    icon = 'fa-solid fa-boxes-packing',
                    event = 'rsg-blacksmithshop:client:InvReFull',
                    args = { },
                    arrow = true
                },
                {
                    title = Lang:t('lang_s7'),
                    description = Lang:t('lang_s8'),
                    icon = 'fa-solid fa-sack-dollar',
                    event = 'rsg-blacksmithshop:client:CheckMoney',
                    args = { },
                    arrow = true
                },
            }
        })
        lib.showContext("blacksmith_owner_shop_menu")
    else
        lib.registerContext({
            id = 'blacksmith_customer_shop_menu',
            title = Lang:t('lang_s9'),
            options = {
                {
                    title = Lang:t('lang_s10'),
                    description = Lang:t('lang_s11'),
                    icon = 'fa-solid fa-store',
                    serverEvent = 'rsg-blacksmithshop:server:GetShopItems',
                    args = { id = shopid  },
                    arrow = true
                },
            }
        })
        lib.showContext("blacksmith_customer_shop_menu")
    end
end)

-------------------------------------------------------------------------------------------
-- get shop items
-------------------------------------------------------------------------------------------
RegisterNetEvent('rsg-blacksmithshop:client:ReturnStoreItems')
AddEventHandler('rsg-blacksmithshop:client:ReturnStoreItems', function(data2, data3)
    store_inventory = data2
    Wait(100)
    TriggerEvent('rsg-blacksmithshop:client:Inv', store_inventory, data3)
end)

-- weaponshop inventory
RegisterNetEvent("rsg-blacksmithshop:client:Inv", function(store_inventory, data)
    RSGCore.Functions.TriggerCallback('rsg-blacksmithshop:server:shopS', function(result)
        local options = {}
        for k, v in ipairs(store_inventory) do
            if store_inventory[k].stock > 0 then
                options[#options + 1] = {
                    title = RSGCore.Shared.Items[store_inventory[k].items].label,
                    description = 'Stock: '..store_inventory[k].stock..' | '..Lang:t('lang_s12')..string.format("%.2f", store_inventory[k].price),
                    icon = 'fa-solid fa-box',
                    event = 'rsg-blacksmithshop:client:InvInput',
                    args = store_inventory[k],
                    arrow = true,
                }
            end
        end
        lib.registerContext({
            id = 'blacksmith_shopinv_menu',
            title = Lang:t('lang_s13'),
            position = 'top-right',
            options = options
        })
        lib.showContext('blacksmith_shopinv_menu')
    end, currentblacksmithshop)
end)

-------------------------------------------------------------------------------------------
-- weaponshop refill
-------------------------------------------------------------------------------------------
RegisterNetEvent("rsg-blacksmithshop:client:InvReFull", function()
    RSGCore.Functions.TriggerCallback('rsg-blacksmithshop:server:Stock', function(result)
        if result == nil then
            lib.registerContext({
                id = 'blacksmith_no_inventory',
                title = Lang:t('lang_s14'),
                menu = 'blacksmith_owner_shop_menu',
                onBack = function() end,
                options = {
                    {
                        title = Lang:t('lang_s29'),
                        description = Lang:t('lang_s30'),
                        icon = 'fa-solid fa-box',
                        disabled = true,
                        arrow = false
                    }
                }
            })
            lib.showContext("blacksmith_no_inventory")
        else
            local options = {}
            for k, v in ipairs(result) do
                options[#options + 1] = {
                    title = RSGCore.Shared.Items[result[k].item].label,
                    description = 'inventory amount : '..result[k].stock,
                    icon = 'fa-solid fa-box',
                    event = 'rsg-blacksmithshop:client:InvReFillInput',
                    args = {
                        item = result[k].item,
                        label = RSGCore.Shared.Items[result[k].item].label,
                        stock = result[k].stock
                    },
                    arrow = true,
                }
            end
            lib.registerContext({
                id = 'blacksmith_inv_menu',
                title = Lang:t('lang_s14'),
                menu = 'blacksmith_owner_shop_menu',
                onBack = function() end,
                position = 'top-right',
                options = options
            })
            lib.showContext('blacksmith_inv_menu')
        end
    end, currentjob)
end)

-------------------------------------------------------------------------------------------
-- weaponshop add items from inventory
-------------------------------------------------------------------------------------------
RegisterNetEvent('rsg-blacksmithshop:client:InvReFillInput', function(data)
    local item = data.item
    local label = data.label
    local stock = data.stock
    local input = lib.inputDialog(Lang:t('lang_s31').." : "..label, {
        { 
            label = Lang:t('lang_s15'),
            description = Lang:t('lang_s16'),
            type = 'number',
            required = true,
            icon = 'hashtag'
        },
        { 
            label = Lang:t('lang_s17'),
            description = Lang:t('lang_s18'),
            default = '0.10',
            type = 'input',
            required = true,
            icon = 'fa-solid fa-dollar-sign'
        },
    })
    
    if not input then
        return
    end
    
    if stock >= tonumber(input[1]) and tonumber(input[2]) ~= nil then
        TriggerServerEvent('rsg-blacksmithshop:server:InvReFill', currentblacksmithshop, item, input[1], tonumber(input[2]), currentjob)
    else
        RSGCore.Functions.Notify(Lang:t('lang_s19'), 'error')
    end
end)

-------------------------------------------------------------------------------------------
-- buy weaponshop items
-------------------------------------------------------------------------------------------
RegisterNetEvent('rsg-blacksmithshop:client:InvInput', function(data)
    local name = data.items
    local price = data.price
    local stock = data.stock
    local input = lib.inputDialog(RSGCore.Shared.Items[name].label.." | $"..string.format("%.2f", price).." | Stock: "..stock, {
        { 
            label = Lang:t('lang_s15'),
            type = 'number',
            required = true,
            icon = 'hashtag'
        },
    })
    
    if not input then
        return
    end
    
    if stock >= tonumber(input[1]) then
        TriggerServerEvent('rsg-blacksmithshop:server:PurchaseItem', currentblacksmithshop, name, input[1])
    else
        RSGCore.Functions.Notify((Lang:t('lang_s20')), 'error')
    end
end)

-------------------------------------------------------------------------------------------
-- weaponshop money
-------------------------------------------------------------------------------------------
RegisterNetEvent("rsg-blacksmithshop:client:CheckMoney", function()
    RSGCore.Functions.TriggerCallback('rsg-blacksmithshop:server:GetMoney', function(checkmoney)
        RSGCore.Functions.TriggerCallback('rsg-blacksmithshop:server:shopS', function(result)
            lib.registerContext({
                id = 'money_menu',
                title = Lang:t('lang_s21') ..string.format("%.2f", checkmoney.money),
                menu = 'blacksmith_owner_shop_menu',
                onBack = function() end,
                options = {
                    {
                        title = Lang:t('lang_s22'),
                        description = Lang:t('lang_s23'),
                        icon = 'fa-solid fa-money-bill-transfer',
                        event = 'rsg-blacksmithshop:client:Withdraw',
                        args = checkmoney,
                        arrow = true
                    },
                }
            })
            lib.showContext("money_menu")
        end, currentblacksmithshop)
    end, currentblacksmithshop)
end)

-------------------------------------------------------------------------------------------
-- weaponshop withdraw money
-------------------------------------------------------------------------------------------
RegisterNetEvent('rsg-blacksmithshop:client:Withdraw', function(checkmoney)
    local money = checkmoney.money
    local input = lib.inputDialog(Lang:t('lang_s24')..string.format("%.2f", money), {
        { 
            label = Lang:t('lang_s25'),
            type = 'input',
            required = true,
            icon = 'fa-solid fa-dollar-sign'
        },
    })
    
    if not input then
        return
    end
    
    if tonumber(input[1]) == nil then
        return
    end

    if money >= tonumber(input[1]) then
        TriggerServerEvent('rsg-blacksmithshop:server:Withdraw', currentblacksmithshop, tonumber(input[1]))
    else
        RSGCore.Functions.Notify((Lang:t('lang_s20')), 'error')
    end
end)
