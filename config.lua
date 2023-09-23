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
        coords = vector3(-363.9674, 795.75189, 116.19718),
        jobaccess = 'valblacksmith',
        showblip = true
    },
    
}

-- blacksmith crafting
Config.BlacksmithCrafting = {

    {
        title =  'Shovel',
        category = 'Tools',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "steel", amount = 1 },
            [2] = { item = "wood",  amount = 1 },
        },
        receive = "shovel",
        giveamount = 1
    },
    {
        title =  'Knife',
        category = 'Melee',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "steel", amount = 1 },
            [2] = { item = "wood",  amount = 1 },
        },
        receive = "weapon_melee_knife",
        giveamount = 1
    },

}