Config = {}

-- blip settings
Config.Blip = {
    blipName = 'Blacksmith Shop', -- Config.Blip.blipName
    blipSprite = 'blip_shop_blacksmith', -- Config.Blip.blipSprite
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

}