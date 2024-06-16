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
        TriggerServerEvent("dispatch:server:notify",{
            dispatchcodename = "speeding", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
            dispatchCode = "10-11",
            firstStreet = locationInfo,
            model = vehdata.name, -- vehicle name
            plate = vehdata.plate, -- vehicle plate
            priority = 2, 
            firstColor = vehdata.colour, -- vehicle color
            heading = heading, 
            automaticGunfire = false,
            origin = {
                x = currentPos.x,
                y = currentPos.y,
                z = currentPos.z
            },
            dispatchMessage = "Speeding Vehicle",
            job = Config.PoliceJob
        })
    end
end



local function ATMRobbery(vehicle)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "speeding", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-11",
        firstStreet = locationInfo,
        model = vehdata.name, -- vehicle name
        plate = vehdata.plate, -- vehicle plate
        priority = 2, 
        firstColor = vehdata.colour, -- vehicle color
        heading = heading, 
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Speeding Vehicle",
        job = {"police"}
    })
end exports('ATMRobbery', ATMRobbery)
