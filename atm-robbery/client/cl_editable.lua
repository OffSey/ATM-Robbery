lib.locale()
utils = {}

function utils.OffSeyNotify(title, msg, type)
    lib.notify({
        title = title,
        description = msg,
        type = type,
        position = 'top-right',
    })
end

RegisterNetEvent('OffSey:showNotification', utils.OffSeyNotify)

    RegisterNetEvent('OffSey:Client:PoliceAlert')
    AddEventHandler('OffSey:Client:PoliceAlert', function(coords)
    utils.OffSeyNotify(locale('notification_title'), locale('police_alert'), 'info')

    local coords = GetEntityCoords(PlayerPedId())

    local alphatengo = 250
    local BlipsPolice = AddBlipForRadius(coords.x, coords.y, coords.z, 50.0)

    SetBlipHighDetail(BlipsPolice, true)
    SetBlipColour(BlipsPolice, 1)
    SetBlipAlpha(BlipsPolice, alphatengo)
    SetBlipAsShortRange(BlipsPolice, true)

    while alphatengo ~= 0 do
        Citizen.Wait(500)
        alphatengo = alphatengo - 1
        SetBlipAlpha(BlipsPolice, alphatengo)

        if alphatengo == 0 then
            RemoveBlip(BlipsPolice)
            return
        end
    end
end)


function utils.OffSeyPoliceAlert(coords)
    if Config.Dispatch == "default" then
        TriggerServerEvent('OffSey:Server:PoliceAlert', coords)
    elseif Config.Dispatch == "cd_dispatch" then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.PoliceJob,
            coords = coords,
            title = locale('police_alert_title'),
            message = locale('police_alert') .. data.street_1.. ", ".. data.street_2,
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 161, -- number -> The blip sprite: Find them here (https://docs.fivem.net/docs/game-references/blips/#blips)
                scale = 1.5, -- number -> The blip scale
                colour = 3, -- number -> The blip colour: Find them here (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
                flashes = false, 
                text = locale('blips_alert_police'),
                time = 5,
                radius = 0,
            }
        })
    elseif Config.Dispatch == "qs-dispatch" then
        local data = exports['qs-dispatch']:GetPlayerInfo()
            TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
                job = Config.PoliceJob,
                callLocation = data.coords,
                callCode = { code = 'Robbery ATM', snippet = '10-50' },
                message = locale('police_alert') .. data.street_1.. ", ".. data.street_2,
                flashes = false,
                blip = {
                    sprite = 161, -- number -> The blip sprite: Find them here (https://docs.fivem.net/docs/game-references/blips/#blips)
                    scale = 1.5, -- number -> The blip scale
                    colour = 3, -- number -> The blip colour: Find them here (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
                    flashes = true,
                    text = locale('blips_alert_police'),
                    time = 5 * 60 * 1000,
                }
            })
    elseif Config.Dispatch == "rcore_dispatch" then
        local data = {
            code = '10-50', -- string -> The alert code, can be for example '10-64' or a little bit longer sentence like '10-64 - Shop robbery'
            default_priority = 'medium', -- 'low' | 'medium' | 'high' -> The alert priority
            coords = coords, -- vector3 -> The coords of the alert
            job = Config.PoliceJob, -- string | table -> The job, for example 'police' or a table {'police', 'ambulance'}
            text = locale('police_alert'), -- string -> The alert text
            type = 'alerts', -- alerts | shop_robbery | car_robbery | bank_robbery -> The alert type to track stats
            blip_time = 5, -- number (optional) -> The time until the blip fades
            blip = { -- Blip table (optional)
                sprite = 161, -- number -> The blip sprite: Find them here (https://docs.fivem.net/docs/game-references/blips/#blips)
                colour = 3, -- number -> The blip colour: Find them here (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
                scale = 1.5, -- number -> The blip scale
                text = locale('blips_alert_police'), -- number (optional) -> The blip text
                flashes = false, -- boolean (optional) -> Make the blip flash
                radius = 0, -- number (optional) -> Create a radius blip instead of a normal one
            }
        }
        TriggerServerEvent('rcore_dispatch:server:sendAlert', data)
    elseif Config.Dispatch == "ps-dispatch" then
        exports['ps-dispatch']:SuspiciousActivity()
    end
end

function utils.StartAnimation(dict, anim)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, -1, 49, 0, false, false, false)
end

function utils.StopAnimation()
    ClearPedTasks(PlayerPedId())
end

local atmProps = {
    "prop_atm_01",
    "prop_atm_02",
    "prop_atm_03",
    "prop_fleeca_atm",
    "v_5_b_atm1",
    "v_5_b_atm2",
    "amb_prop_pine_atm"
}

local function isNearATMClient()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local isNear = false

    for _, atmProp in ipairs(atmProps) do
        local atmObject = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 1.5, GetHashKey(atmProp), false, false, false)
        if atmObject ~= 0 then
            isNear = true
            break
        end
    end

    return isNear
end

function utils.OnSuccess()
    if isNearATMClient() then
        utils.OffSeyNotify(locale('notification_title'), locale('notification_success_rob'), 'info')
        local progressbar = lib.progressCircle({
            duration = 5000,
            label = locale('progress_money_recovery'),
            position = 'bottom',
            disable = {
                car = true,
                combat = true,
                move = true,
            },
            anim = {
                dict = 'anim@amb@prop_human_atm@interior@male@enter',
                clip = 'enter'
            }
        })

        if progressbar then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            TriggerServerEvent("OffSeyATM:Recompense", playerCoords)
            print("sucess robbery")
        else
            print("robbery stopped")
        end
    else
        print("cheat client")
    end
end


function utils.OnFailure(reason)
    Wait(4000)
    print("no success, reason : "..reason)
    utils.OffSeyNotify(locale('notification_title'), locale('notification_not_completed_atm_message'), 'error')
end
