CreateThread(function()
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

function DisplayBin(obj)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "bin" .. tostring(obj), {
        maxweight = Config.Binmaxweight,
        slots = Config.Binslots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "bin" .. tostring(obj))
end
