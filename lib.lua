local QBCore = exports['qb-core']:GetCoreObject()

local bl_lib = {}

-- Notification Wrapper
function bl_lib.Notify(message, type)
    TriggerEvent('QBCore:Notify', message, type or 'primary')
end

-- Localization Helper
function bl_lib.Localize(key)
    return Locales and Locales[key] or key
end

-- Find the nearest vehicle to a player
function bl_lib.GetNearbyVehicle(ped, maxDistance)
    local coords = GetEntityCoords(ped)
    local vehicles = GetGamePool("CVehicle")

    for _, vehicle in pairs(vehicles) do
        if #(coords - GetEntityCoords(vehicle)) < (maxDistance or 5.0) then
            return vehicle
        end
    end
    return nil
end

-- Server-side: Check if player has key item
function bl_lib.HasVehicleKey(source, config)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end

    if not config.RequireKeyItem then return true end

    if config.Inventory == "ox" then
        local count = exports.ox_inventory:Search(source, 'count', config.KeyItemName)
        return count and count > 0
    elseif config.Inventory == "qb" then
        local item = Player.Functions.GetItemByName(config.KeyItemName)
        return item ~= nil
    elseif config.Inventory == "qs" then
        local qs = exports['qs-inventory']
        local count = qs:GetItemCount(source, config.KeyItemName)
        return count and count > 0
    end

    return false
end

return bl_lib
