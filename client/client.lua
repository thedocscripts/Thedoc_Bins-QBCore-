local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    if Config.UseQBTarget then
        exports['qb-target']:AddTargetModel(Config.Bins, {
            options = {
                {
                    type = "client",
                    event = "qb-client:GetClosestBin",
                    icon = "fas fa-trash",
                    label = Config.Text,
                },
            },
            distance = 2.5
        })
    end
end)


local closetobin = false
Citizen.CreateThread(function()
    if not Config.UseQBTarget then
        local sleep = 1000
        while true do
            local closestobj = GetClosestBin()
            local objpos = GetEntityCoords(closestobj)
            if closestobj ~= nil then
                if not closetobin then
                    displaybin(objpos, closestobj)
                    closetobin = true
                end
            else
                closetobin = false
            end
            Wait(sleep)
        end
    end
end)

RegisterNetEvent('qb-client:GetClosestBin', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, machine in pairs(Config.Bins) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, GetHashKey(machine), 0, 0, 0)
        if ClosestObject ~= 0 then
            if object == nil then
                object = ClosestObject
                DisplayBin(ClosestObject)
            end
        end
    end
    return object
end)


function GetClosestBin()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, machine in pairs(Config.Bins) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, GetHashKey(machine), 0, 0, 0)
        if ClosestObject ~= 0 then
            if object == nil then
                object = ClosestObject
            end
        end
    end
    return object
end

function DisplayBin(obj)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "bin" .. tostring(obj), {
        maxweight = Config.Binmaxweight,
        slots = Config.Binslots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "bin" .. tostring(obj))
end


function displaybin(objpp, _closestobj)
    Citizen.CreateThread(function()
        local closestobj = _closestobj
        local objpos = objpp
        while closetobin do
                QBCore.Functions.DrawText3D(objpos.x, objpos.y, objpos.z + 1, Config.Text)
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", "bin" .. tostring(closestobj), {
                        maxweight = Config.Binmaxweight,
                        slots = Config.Binslots,
                    })
                    TriggerEvent("inventory:client:SetCurrentStash", "bin" .. tostring(closestobj))
                end
            Wait(0)
        end
    end)
end
