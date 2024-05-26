# OffSey ATM Robbery

- Preview Video : https://youtu.be/lNlXhBCLWKE
- CFX Forum : Soon
- Resmon 0.00 ms

## Configuration

```lua
Config = {}
-- Framework
Config.Framework = "ESX" -- ESX or Qb
Config.AccountGainESX = "black_money" -- black_money/money/bank // For ESX
Config.AccountGainQB = "cash" -- cash/bank // For QbCore

-- Target
Config.Target = "ox_target" -- ox_target or qb-target

-- Dispatch & Police
Config.Dispatch = "qs-dispatch" -- cd_dispatch | qs-dispatch | rcore_dispatch | default
Config.PoliceJob = {'police', 'sheriff'}

-- Item
Config.ItemRequire = "hacking_computer"
Config.RemoveItem = "false" -- true or false

-- Gain Stolen
Config.GainStolen = math.random(10000, 15000)
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
