# RexshackGaming
- discord : https://discord.gg/eW3ADkf4Af
- youtube : https://www.youtube.com/channel/UCikEgGfXO-HCPxV5rYHEVbA
- github : https://github.com/Rexshack-RedM

# Dependancies
- rsg-core
- ox_lib

# Installation
- ensure that the dependancies are added and started
- add the following table to your database : rsg-blacksmith.sql
- add rsg-blacksmith to your resources folder

# add to shared jobs
```lua
    ['valblacksmith'] = { --valentine
        label = 'Valentine Blacksmith',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Trainee', payment = 25 },
            ['1'] = { name = 'Master', isboss = true, payment = 75 },
        },
    },
```

# Starting the resource
- add the following to your server.cfg file : ensure rsg-blacksmith
