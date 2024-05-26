lib.locale()

local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil

if not ESX then return end

framework = {}

function framework.addMoneyATM(data)
    local xPlayer = ESX.GetPlayerFromId(data.player)
    xPlayer.addAccountMoney(Config.AccountGainESX, data.amount)
end


function framework.hasItems(data)
    local xPlayer = ESX.GetPlayerFromId(data.player)

    if type(data.items) == "table" then
        for _, item in pairs(data.items) do
            local hasItem = xPlayer.getInventoryItem(item.item)
            if not hasItem then return false end

            if hasItem.count >= item.quantity then return true end
        end
    else
        return xPlayer.getInventoryItem(data.items).count > 0
    end
end

function framework.removeItem(data)
    local xPlayer = ESX.GetPlayerFromId(data.player)
    xPlayer.removeInventoryItem(data.item, 1)
end