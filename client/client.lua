local QBCore = exports['qb-core']:GetCoreObject()
local closetobin = false

CreateThread(function()
    if Config.UseQBTarget then
        exports['qb-target']:AddTargetModel(Config.Bins, {
            options = {
                {
                    type = "client",
                    event = "qb-client:targetbin",
                    icon = "fas fa-trash",
                    label = Config.Text,
                },
            },
            distance = 2.5
        })
    end
end)

CreateThread(function()
    if not Config.UseQBTarget then
        while true do
            local sleep = 1250
            local closestobj = GetClosestBin()
            local objpos = GetEntityCoords(closestobj)
            if closestobj ~= nil then
                if not closetobin then
                    DisplayBin(objpos, closestobj)
                    closetobin = true
                end
            else
                closetobin = false
            end
            Wait(sleep)
        end
    end
end)

RegisterNetEvent('qb-client:targetbin', function()
    local targetobj = GetClosestBin()
    if targetobj ~= nil then
        StashBin(targetobj)
    end
end)

function GetClosestBin()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, bins in pairs(Config.Bins) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, GetHashKey(bins), 0, 0, 0)
        if ClosestObject ~= 0 then
            if object == nil then
                object = ClosestObject
            end
        end
    end
    return object
end

function DisplayBin(objpos, closestobj)
    CreateThread(function()
        while closetobin do
            QBCore.Functions.DrawText3D(objpos.x, objpos.y, objpos.z + 1, "~b~[E]~w~ - " ..Config.Text)
            if IsControlJustPressed(0, 38) then
                StashBin(closestobj)
            end
        Wait(5)
        end
    end)
end

function StashBin(obj)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "bin" .. tostring(obj), {
        maxweight = Config.Binmaxweight,
        slots = Config.Binslots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "bin" .. tostring(obj))
end
