lib.locale()

local ESX = nil
local QBCore = nil
local activeRobberies = {}

if Config.Framework == "ESX" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "Qb" then
    QBCore = exports['qb-core']:GetCoreObject()
end

local function formatMessage(template, variables)
    return (template:gsub("{{(.-)}}", function(key)
        return tostring(variables[key] or key)
    end))
end

local lastRobbedTime = 0
local cooldownTime = 900

local function getPlayerFromId(source)
    if Config.Framework == "ESX" then
        return ESX.GetPlayerFromId(source)
    elseif Config.Framework == "Qb" then
        return QBCore.Functions.GetPlayer(source)
    end
    return nil
end

local function startRobbery(playerId)
    activeRobberies[playerId] = true
    print('start robbery atm playerid:' ..playerId)
end

local function endRobbery(playerId)
    activeRobberies[playerId] = nil
    print('end robbery atm playerid:' ..playerId)
end

local function isRobberyActive(playerId)
    return activeRobberies[playerId] ~= nil
end

RegisterServerEvent("OffSeyATM:AttemptRob")
AddEventHandler("OffSeyATM:AttemptRob", function()
    local currentTime = os.time()
    local playerId = source
    local xPlayer = getPlayerFromId(playerId)

    if not xPlayer then
        print("Error: Player data not found.")
        return
    end

    if isRobberyActive(playerId) then
        TriggerClientEvent('OffSey:showNotification', playerId, locale('notification_title'), locale('robbery_active'), 'error')
        return
    end

    local playerName = xPlayer.getName and xPlayer.getName() or xPlayer.PlayerData.name
    local playerIdentifier = xPlayer.identifier or xPlayer.PlayerData.citizenid

    if currentTime - lastRobbedTime >= cooldownTime then
        lastRobbedTime = currentTime
        startRobbery(playerId)
        TriggerClientEvent("OffSey:AtmRob", playerId)

        if Config.RemoveItem then
            framework.removeItem({ player = playerId, item = Config.ItemRequire, count = 1 })
        else
            print('no remove item')
        end

        webhooks(formatMessage(locale('logs_success'), {playerName = playerName, playerId = playerId, playerIdentifier = playerIdentifier}), 3066993)
    else
        local timeLeft = math.ceil((cooldownTime - (currentTime - lastRobbedTime)) / 60)
        TriggerClientEvent('OffSey:showNotification', playerId, locale('notification_title'), locale('notification_timeleft_partone') .. timeLeft .. locale('notification_timeleft_parttwo'), 'error')

        webhooks(formatMessage(locale('logs_failure'), {playerName = playerName, playerId = playerId, playerIdentifier = playerIdentifier, timeLeft = timeLeft}), 15158332)
    end
end)

RegisterServerEvent("OffSeyATM:Recompense")
AddEventHandler("OffSeyATM:Recompense", function(playerCoords)
    local playerId = source
    local xPlayer = getPlayerFromId(playerId)

    if not xPlayer then
        print("Error: Player data not found.")
        return
    end

    if not isRobberyActive(playerId) then
        local playerName = xPlayer.getName and xPlayer.getName() or xPlayer.PlayerData.name
        local playerIdentifier = xPlayer.identifier or xPlayer.PlayerData.citizenid

        print("Cheat Detect: "..playerName.."("..playerIdentifier..") attempted to receive money without active heist.")
        
        if Config.Fiveguard then
            exports[Config.FiveguardName]:fg_BanPlayer(playerId, "Cheating attempt detected (reward without active heist).", true)
        else
            DropPlayer(playerId, "Cheating attempt detected.")
        end
        return
    end

    local playerName = xPlayer.getName and xPlayer.getName() or xPlayer.PlayerData.name
    local playerIdentifier = xPlayer.identifier or xPlayer.PlayerData.citizenid
    local reward = Config.GainStolen

    if playerCoords then
        framework.addMoneyATM({ player = playerId, amount = reward })

        TriggerClientEvent('OffSey:showNotification', playerId, locale('notification_title'), locale('notification_stolen_gain') .. reward, 'info')
        print(playerName .. " pulled off a heist and won " .. reward)

        endRobbery(playerId)
    else
        print("Cheat Detect: ".. playerName.." (".. playerIdentifier..") attempted to use the trigger with invalid coordinates.")

        if Config.Fiveguard then
            exports[Config.FiveguardName]:fg_BanPlayer(playerId, "Cheating attempt detected (invalid coordinates during the heist).", true)
        else
            DropPlayer(playerId, "Cheating attempt detected.")
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
                    if player.PlayerData.job.name == v then
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
