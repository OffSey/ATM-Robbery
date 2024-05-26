lib.locale()

local QBCore = GetResourceState('qb-core'):find('start') and exports['qb-core']:GetCoreObject() or nil

if not QBCore then return end

framework = {}

function framework.addMoneyATM(data)
    local xPlayer = QBCore.Functions.GetPlayer(data.player)
    xPlayer.Functions.AddMoney(Config.AccountGainQB, data.amount)
end

function framework.hasItems(data)
    local xPlayer = QBCore.Functions.GetPlayer(data.player)

    if type(data.items) == "table" then
        for _, item in pairs(data.items) do
            local hasItem = xPlayer.Functions.GetItemByName(item.item)
            if not hasItem then return false end

            if hasItem?.amount >= item.quantity then return true end
        end
    else
        return xPlayer.Functions.GetItemByName(data.items)?.amount > 0
    end
end

function framework.removeItem(data)
    local xPlayer = QBCore.Functions.GetPlayer(data.player)
    xPlayer.Functions.RemoveItem(data.item, 1)
end