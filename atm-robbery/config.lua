Config = {}
-- Framework
Config.Framework = "ESX" -- ESX or Qb
Config.AccountGainESX = "black_money" -- black_money/money/bank // For ESX
Config.AccountGainQB = "cash" -- cash/bank // For QbCore


-- Target
Config.Target = "ox_target" -- ox_target or qb-target

-- Dispatch & Police
Config.Dispatch = "default" -- cd_dispatch | qs-dispatch | rcore_dispatch | default
Config.PoliceJob = {'police', 'sheriff'}

-- Item
Config.ItemRequire = "hacking_computer"
Config.RemoveItem = "true" -- true or false

-- Gain Stolen
Config.GainStolen = math.random(10000, 15000)
