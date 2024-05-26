lib.locale()

if Config.Framework then
    if Config.Framework == "ESX" then
        ESX = exports['es_extended']:getSharedObject()
    elseif Config.Framework == "Qb" then
        local QBCore = exports['qb-core']:GetCoreObject()
        end
    end


local atmProps = {
    "prop_atm_01",
    "prop_atm_02",
    "prop_atm_03",
    "prop_fleeca_atm",
    "v_5_b_atm1",
    "v_5_b_atm2",
    "amb_prop_pine_atm" -- RoxWood Atm Maps - https://ambitioneers.tebex.io/package/5349456
}

if Config.Target then
    if Config.Target == "ox_target" then
        exports.ox_target:addModel(atmProps, {
            {
                name = 'hackingATM',
                icon = 'fa-solid fa-mobile-retro',
                label = locale('target_rob_atm'),
                onSelect = function()
                    local hasItem = lib.callback.await('OffSeyATM:HasItem', Config.ItemRequire)
                        if hasItem then
                        TriggerServerEvent("OffSeyATM:AttemptRob")
                    else
                        utils.OffSeyNotify(locale('notification_title'), locale('notification_noobeject_message'), 'error')
                    end
                end
            }
        })
    elseif Config.Target == "qb-target" then
        exports['qb-target']:AddTargetModel(atmProps, {
            options = {
                {
                    num = 1,
                    type = "client",
                    icon = 'fa-solid fa-mobile-retro',
                    label = locale('target_rob_atm'),
                    action = function()
                        local hasItem = lib.callback.await('OffSeyATM:HasItem', Config.ItemRequire)
                            if hasItem then
                            TriggerServerEvent("OffSeyATM:AttemptRob")
                        else
                            utils.OffSeyNotify(locale('notification_title'), locale('notification_noobeject_message'), 'error')
                        end
                    end
                }
            },
            distance = 2.5,
        })
    end
end

RegisterNetEvent('OffSey:AtmRob')
AddEventHandler('OffSey:AtmRob', function()
            utils.OffSeyNotify(locale('notification_title'), locale('notification_startatm_message'), 'info')
            local progressbar = lib.progressCircle({
                duration = 3000,
                label = locale('progress_insertion_card'),
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
            if Config.Framework then
                if Config.Framework == "ESX" then
                    local src = source
                        utils.OffSeyPoliceAlert(coords)
                elseif Config.Framework == "Qb" then
                    local src = source
                        utils.OffSeyPoliceAlert(coords)
                    end
                end

            TriggerEvent("utk_fingerprint:Start", 3, 2, 2, function(outcome, reason)
            if outcome == true then
                    Wait(3500)
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
                    TriggerServerEvent("OffSeyATM:Recompense")
                    print("succes")
                else
                Wait(4000)
                print("no succes, reason : "..reason)
                    utils.OffSeyNotify(locale('notification_title'), locale('notification_not_completed_atm_message'), 'error')
            end
        end)
    end)
