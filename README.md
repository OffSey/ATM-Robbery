# OffSey ATM Robbery

- Preview Video : https://youtu.be/lNlXhBCLWKE
- CFX Forum : Soon
- Resmon 0.00 ms

## Configuration

```lua
Config = {}
-- Framework
Config.Framework = "ESX" -- ESX or Qb
Config.AccountGain = "black_money" -- black_money/money/bank // For ESX || Cash for QbCore

Config.Fiveguard = false -- Use fiveguard ? For Ban 
Config.FiveguardName = "fiveguard" -- The name of your fiveguard file

-- MiniGame
Config.MiniGame = "thermite" -- Options: "digital", "thermite", "number_maze"

-- Target
Config.Target = "ox_target" -- ox_target or qb-target

-- Dispatch & Police
Config.Dispatch = "default" -- cd_dispatch | qs-dispatch | rcore_dispatch | ps-dispatch | default
Config.PoliceJob = {'police', 'sheriff'}

-- Item
Config.ItemRequire = "hacking_computer"
Config.RemoveItem = true -- true or false

-- Gain Stolen
Config.GainStolen = math.random(10000, 15000)

Config.WebhooksLinks = "WebhooksLinks"
```

## Items to Create

### Hacking Computer

Item for:

Quasar:

```lua
['hacking_computer'] = {
    ['name'] = 'hacking_computer',
    ['label'] = 'Hacking Computer',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'hacking_computer.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = true,
    ['description'] = 'A computer equipped with software for hacking.',
}
```

Ox:

```lua
['hacking_computer'] = {
    label = 'Hacking Computer',
    weight = 100,
    stack = true,
    close = false,
    description = 'A computer equipped with software for hacking.',
}
```

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [qtarget](https://github.com/overextended/qtarget)
- [Utk_fingerprint](https://github.com/utkuali/Finger-Print-Hacking-Game)
