local RSGCore = exports['rsg-core']:GetCoreObject()
local options = {}
local jobaccess

-------------------------------------------------------------------------------------------
-- prompts and blips if needed
-------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    for _, v in pairs(Config.BlacksmithCraftingPoint) do
        exports['rsg-core']:createPrompt(v.location, v.coords, RSGCore.Shared.Keybinds[Config.Keybind], Lang:t('lang_0'), {
            type = 'client',
            event = 'rsg-blacksmith:client:mainmenu',
            args = { v.job },
        })
        if v.showblip == true then
            local CraftMenuBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(CraftMenuBlip,  joaat(Config.BlacksmithBlip.blipSprite), true)
            SetBlipScale(Config.BlacksmithBlip.blipScale, 0.2)
            Citizen.InvokeNative(0x9CB1A1623062F402, CraftMenuBlip, Config.BlacksmithBlip.blipName)
        end
    end
end)

------------------------------------------------------------------------------------------------------
-- weapon main menu
------------------------------------------------------------------------------------------------------

RegisterNetEvent('rsg-blacksmith:client:mainmenu', function(job)
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local playerjob = PlayerData.job.name
    jobaccess = job
    if playerjob == jobaccess then
        lib.registerContext({
            id = 'blacksmith_mainmenu',
            title = Lang:t('lang_1'),
            options = {
                {
                    title = Lang:t('lang_2'),
                    description = Lang:t('lang_3'),
                    icon = 'fa-solid fa-screwdriver-wrench',
                    event = 'rsg-blacksmith:client:craftingmenu',
                    arrow = true
                },
                {
                    title = Lang:t('lang_4'),
                    description = Lang:t('lang_5'),
                    icon = 'fas fa-box',
                    event = 'rsg-blacksmith:client:storage',
                    arrow = true
                },
                {
                    title = Lang:t('lang_6'),
                    description = Lang:t('lang_7'),
                    icon = 'fa-solid fa-user-tie',
                    event = 'rsg-bossmenu:client:mainmenu',
                    arrow = true
                },
            }
        })
        lib.showContext("blacksmith_mainmenu")
    else
        RSGCore.Functions.Notify(Lang:t('lang_8'), 'error')
    end
end)

------------------------------------------------------------------------------------------------------
-- crafting menu
------------------------------------------------------------------------------------------------------

-- create a table to store menu options by category
local CategoryMenus = {}

-- iterate through recipes and organize them by category
for _, v in ipairs(Config.BlacksmithCrafting) do
    local IngredientsMetadata = {}
    local setheader = RSGCore.Shared.Items[tostring(v.receive)].label
    local itemimg = "nui://"..Config.img..RSGCore.Shared.Items[tostring(v.receive)].image
    for i, ingredient in ipairs(v.ingredients) do
        table.insert(IngredientsMetadata, { label = RSGCore.Shared.Items[ingredient.item].label, value = ingredient.amount })
    end
    local option = {
        title = setheader,
        icon = itemimg,
        event = 'rsg-blacksmith:client:checkingredients',
        metadata = IngredientsMetadata,
        args = {
            title = setheader,
            category = v.category,
            ingredients = v.ingredients,
            crafttime = v.crafttime,
            receive = v.receive,
            giveamount = v.giveamount
        }
    }

    -- check if a menu already exists for this category
    if not CategoryMenus[v.category] then
        CategoryMenus[v.category] = {
            id = 'crafting_menu_' .. v.category,
            title = v.category,
            menu = 'blacksmith_mainmenu',
            onBack = function() end,
            options = { option }
        }
    else
        table.insert(CategoryMenus[v.category].options, option)
    end
end

-- log menu events by category
for category, MenuData in pairs(CategoryMenus) do
    RegisterNetEvent('rsg-blacksmith:client:' .. category)
    AddEventHandler('rsg-blacksmith:client:' .. category, function()
        lib.registerContext(MenuData)
        lib.showContext(MenuData.id)
    end)
end

-- main event to open main menu
RegisterNetEvent('rsg-blacksmith:client:craftingmenu')
AddEventHandler('rsg-blacksmith:client:craftingmenu', function()
    -- show main menu with categories
    local Menu = {
        id = 'crafting_menu',
        title = Lang:t('lang_9'),
        menu = 'blacksmith_mainmenu',
        onBack = function() end,
        options = {}
    }

    for category, MenuData in pairs(CategoryMenus) do
        table.insert(Menu.options, {
            title = category,
            description = Lang:t('lang_10') .. category,
            icon = 'fa-solid fa-pen-ruler',
            event = 'rsg-blacksmith:client:' .. category,
            arrow = true
        })
    end

    lib.registerContext(Menu)
    lib.showContext(Menu.id)
end)

------------------------------------------------------------------------------------------------------
-- do crafting stuff
------------------------------------------------------------------------------------------------------

-- check player has the ingredients to craft
RegisterNetEvent('rsg-blacksmith:client:checkingredients', function(data)
    RSGCore.Functions.TriggerCallback('rsg-blacksmith:server:checkingredients', function(hasRequired)
    if (hasRequired) then
        if Config.Debug == true then
            print("passed")
        end
        TriggerEvent('rsg-blacksmith:client:craftitem', data.title, data.category, data.ingredients, tonumber(data.crafttime), data.receive, data.giveamount)
    else
        if Config.Debug == true then
            print("failed")
        end
        return
    end
    end, data.ingredients)
end)

-- do crafting
RegisterNetEvent('rsg-blacksmith:client:craftitem', function(title, category, ingredients, crafttime, receive, giveamount)
    RSGCore.Functions.Progressbar('do-crafting', Lang:t('lang_11')..title..' '..category, crafttime, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('rsg-blacksmith:server:finishcrafting', ingredients, receive, giveamount, jobaccess)
    end)
end)

------------------------------------------------------------------------------------------------------
-- blacksmith storage
------------------------------------------------------------------------------------------------------

RegisterNetEvent('rsg-blacksmith:client:storage', function()
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local playerjob = PlayerData.job.name
    if playerjob == jobaccess then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", jobaccess, {
            maxweight = Config.StorageMaxWeight,
            slots = Config.StorageMaxSlots,
        })
        TriggerEvent("inventory:client:SetCurrentStash", jobaccess)
    end
end)
