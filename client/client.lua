local QBCore = exports['qb-core']:GetCoreObject()

local closetobin = false
Citizen.CreateThread(function()
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
end)



function displaybin(objpp, _closestobj)
    Citizen.CreateThread(function()
        local closestobj = _closestobj
        local objpos = objpp
        while closetobin do

                if Config.Use3DText then
                    QBCore.Functions.DrawText3D(objpos.x, objpos.y, objpos.z + 1, Config.Text)
                else
                    ShowHelpNotification(Config.Text)
                end
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

function GetClosestBin()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, machine in pairs(Config.Bins) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 0.75, GetHashKey(machine), 0, 0, 0)
        if ClosestObject ~= 0 then
            if object == nil then
                object = ClosestObject
            end
        end
    end
    return object
end



function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, 50)
end





