AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
       if Config.AutoDelete then
        MySQL.Async.execute('DELETE FROM stashitems WHERE stash like "%bin%"', {})
       end
    end
end)
