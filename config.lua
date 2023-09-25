Config = {}

-- blacksmith blip settings
Config.BlacksmithBlip = {
    blipName = 'Blacksmith Crafting', -- Config.Blip.blipName
    blipSprite = 'blip_shop_blacksmith', -- Config.Blip.blipSprite
    blipScale = 0.2 -- Config.Blip.blipScale
}

-- blacksmith shop blip settings
Config.ShopBlip = {
    blipName = 'Blacksmith Shop', -- Config.Blip.blipName
    blipSprite = 'blip_shop_store', -- Config.Blip.blipSprite
    blipScale = 0.2 -- Config.Blip.blipScale
}

-- settings
Config.StorageMaxWeight = 4000000
Config.StorageMaxSlots = 48
Config.Debug = false
Config.Keybind = 'J'

-- blacksmith crafting locations
Config.BlacksmithCraftingPoint = {

    {   -- valentine
        name = 'Blacksmith Crafting',
        location = 'valblacksmith',
        coords = vector3(-369.3893, 796.19067, 116.19599),
        job = 'valblacksmith',
        showblip = true
    },
    
}

-- blacksmith shops
Config.BlacksmithShops = {

    {
        shopid = 'valblacksmithshop',
        shopname = 'Valentine Blacksmith Shop',
        coords = vector3(-364.1691, 799.62487, 116.25514),
        jobaccess = 'valblacksmith',
        showblip = true
    },
    
}

-- blacksmith crafting
Config.BlacksmithCrafting = {

    -- tools
    {
        title =  'Shovel',
        category = 'Tools',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "steel", amount = 1 },
            [2] = { item = "wood",  amount = 1 },
            [3] = { item = "coal",  amount = 1 },
        },
        receive = "shovel",
        giveamount = 1
    },
    {
        title =  'Axe',
        category = 'Tools',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "steel", amount = 1 },
            [2] = { item = "wood",  amount = 1 },
            [3] = { item = "coal",  amount = 1 },
        },
        receive = "axe",
        giveamount = 1
    },
    {
        title =  'Pickaxe',
        category = 'Tools',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "steel", amount = 1 },
            [2] = { item = "wood",  amount = 1 },
            [3] = { item = "coal",  amount = 1 },
        },
        receive = "pickaxe",
        giveamount = 1
    },
    {
        title =  'Gold Pan',
        category = 'Tools',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "steel", amount = 3 },
            [2] = { item = "coal",  amount = 1 },
        },
        receive = "goldpan",
        giveamount = 1
    },

    -- melee
    {
        title =  'Knife',
        category = 'Melee',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "steel", amount = 1 },
            [2] = { item = "wood",  amount = 1 },
            [3] = { item = "coal",  amount = 1 },
        },
        receive = "weapon_melee_knife",
        giveamount = 1
    },

}
