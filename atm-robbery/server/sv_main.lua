lib.locale()
if Config.Framework then
    if Config.Framework == "ESX" then
        ESX = exports['es_extended']:getSharedObject()
    elseif Config.Framework == "Qb" then
        local QBCore = exports['qb-core']:GetCoreObject()
    end
end

local function formatMessage(template, variables)
    return (template:gsub("{{(.-)}}", function(key)
        return tostring(variables[key] or key)
    end))
end

local lastRobbedTime = 0
local cooldownTime = 900
local reward = Config.GainStolen

RegisterServerEvent("OffSeyATM:AttemptRob")
AddEventHandler("OffSeyATM:AttemptRob", function()
    local currentTime = os.time()
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerName = xPlayer.getName()
    local playerId = source
    local playerIdentifier = xPlayer.identifier

    if currentTime - lastRobbedTime >= cooldownTime then
        lastRobbedTime = currentTime
        TriggerClientEvent("OffSey:AtmRob", source)

        if Config.RemoveItem then
            framework.removeItem({ player = source, item = Config.ItemRequire, count = 1 })
        else
            print('no remove item')
        end

        webhooks(formatMessage(locale('logs_success'), {playerName = playerName, playerId = playerId, playerIdentifier = playerIdentifier}), 3066993)
    else
        local timeLeft = math.ceil((cooldownTime - (currentTime - lastRobbedTime)) / 60)
        TriggerClientEvent('OffSey:showNotification', source, locale('notification_title'), locale('notification_timeleft_partone') .. timeLeft .. locale('notification_timeleft_parttwo'), 'error')
        
        webhooks(formatMessage(locale('logs_failure'), {playerName = playerName, playerId = playerId, playerIdentifier = playerIdentifier, timeLeft = timeLeft}), 15158332)
    end
end)

RegisterServerEvent("OffSeyATM:Recompense")
AddEventHandler("OffSeyATM:Recompense", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerName = xPlayer.getName()
    local playerId = source
    local playerIdentifier = xPlayer.identifier

    if Config.Framework then
        if Config.Framework == "ESX" then
            framework.addMoneyATM({ player = source, amount = reward })
            TriggerClientEvent('OffSey:showNotification', source, locale('notification_title'), locale('notification_stolen_gain') .. reward, 'info')
        elseif Config.Framework == "Qb" then
            framework.addMoneyATM({ player = source, amount = reward })
            TriggerClientEvent('OffSey:showNotification', source, locale('notification_title'), locale('notification_stolen_gain') .. reward, 'info')
        end
    end

    webhooks(formatMessage(locale('logs_gain'), {playerName = playerName, playerId = playerId, playerIdentifier = playerIdentifier, reward = reward}), 3066993)
end)

RegisterServerEvent('OffSey:Server:PoliceAlert')
AddEventHandler('OffSey:Server:PoliceAlert', function(coords)
    if Config.Framework then
        if Config.Framework == "ESX" then
            local players = ESX.GetPlayers()
            for i = 1, #players do
                local player = ESX.GetPlayerFromId(players[i])
                for k, v in pairs(Config.PoliceJob) do
                    if player.job.name == v then
                        TriggerClientEvent('OffSey:Client:PoliceAlert', players[i], coords)
                    end
                end
            end
        elseif Config.Framework == "Qb" then
            local players = QBCore.Functions.GetPlayers()
            for i = 1, #players do
                local player = QBCore.Functions.GetPlayer(players[i])
                for k, v in pairs(Config.PoliceJob) do
                    if player.job.name == v then
                        TriggerClientEvent('OffSey:Client:PoliceAlert', players[i], coords)
                    end
                end
            end
        end
    end
end)

lib.callback.register('OffSeyATM:HasItem', function(source)
    return framework.hasItems({ player = source, items = Config.ItemRequire })
end)
