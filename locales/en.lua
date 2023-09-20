local Translations = {

    lang_0 = 'Open Blacksmith Menu',
    lang_1 = 'Blacksmith Menu',
    lang_2 = 'Crafting Menu',
    lang_3 = 'craft items to add to your stock',
    lang_4 = 'Blacksmith Storage',
    lang_5 = 'storage for blacksmith',
    lang_6 = 'Boss Menu',
    lang_7 = 'open boss menu',
    lang_8 = 'you are not authorised!',
    lang_9 = 'Craft Item',
    lang_10 = 'Explore the crafing options for ',
    lang_11 = 'Crafting : ',
    lang_12 = "You don\'t have the required items!",

}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

-- Lang:t('lang_0')