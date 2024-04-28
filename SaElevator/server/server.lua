

ESX = exports['es_extended']:getSharedObject()


admins = {
    'license:xxxx',
    'license:xxxx',
    'license:xxxx'
}


function isAllowedToChange(player)
    local allowed = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if debugprint then print('admin id: ' .. id .. '\nplayer id:' .. pid) end
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

RegisterCommand('SaElevator', function(source, args)
    if isAllowedToChange(source) then
        TriggerClientEvent('SAM_Elevator:OpenMenu', source)
    end
end)

RegisterServerEvent('SAM:LoadElevator')
AddEventHandler('SAM:LoadElevator', function()
    local _src = source
    local allElevator = {}
    local allElevator_name = {}
    MySQL.Async.fetchAll("SELECT * FROM SaElevator_Points", {}, function(data)
        for i = 1, #data, 1 do
            table.insert(allElevator, {
                id = data[i].id,
                name = data[i].name,
                label = data[i].label,
                coords = json.decode(data[i].coords),
                job = data[i].job
            })
        end
        TriggerClientEvent('SAM:RefreshElevator_Points',-1,allElevator)
    end)
    MySQL.Async.fetchAll("SELECT * FROM SaElevator_Name", {}, function(data)
        for i = 1, #data, 1 do
            table.insert(allElevator_name, {
                id = data[i].id,
                name = data[i].name
            })
        end
        TriggerClientEvent('SAM:RefreshElevator_Name',-1,allElevator_name)
    end)
end)

Citizen.CreateThread(function()
    while true do
        local allElevator = {}
        local allElevator_name = {}
            MySQL.Async.fetchAll("SELECT * FROM SaElevator_Points", {}, function(data)
                for i = 1, #data, 1 do
                    table.insert(allElevator, {
                        id = data[i].id,
                        name = data[i].name,
                        label = data[i].label,
                        coords = json.decode(data[i].coords),
                        job = data[i].job
                    })
                end
                TriggerClientEvent('SAM:RefreshElevator_Points',-1,allElevator)
            end)
            MySQL.Async.fetchAll("SELECT * FROM SaElevator_Name", {}, function(data)
                for i = 1, #data, 1 do
                    table.insert(allElevator_name, {
                        id = data[i].id,
                        name = data[i].name
                    })
                end
                TriggerClientEvent('SAM:RefreshElevator_Name',-1,allElevator_name)
            end)
    Citizen.Wait(5000)
    end
end)


RegisterServerEvent('SAM:addElevatorN')
AddEventHandler('SAM:addElevatorN', function(NameElevator)
    local _src = source
    MySQL.Async.execute('INSERT INTO SaElevator_Name (name) VALUES (@name)',{
        ['@name'] = NameElevator
    })
    TriggerClientEvent('esx:showNotification', _src, "Vous avez créé un elevateur !")
end)

RegisterServerEvent('SAM:addElevator')
AddEventHandler('SAM:addElevator', function(NameElevator,Pos,Label,Job)
    local _src = source
    MySQL.Async.execute('INSERT INTO SaElevator_Points (name, label, coords, job) VALUES (@name, @label, @coords, @job)',{
        ['@name'] = NameElevator,
        ['@label'] = Label,
        ['@coords'] = json.encode(Pos),
        ['@job'] = Job
    })
    --TriggerClientEvent('esx:showNotification', _src, "Vous avez créé un elevateur !")
end)


RegisterServerEvent('SAM:updateElevatorlabel')
AddEventHandler('SAM:updateElevatorlabel', function(label,id)
    local _src = source
    MySQL.Async.execute('UPDATE SaElevator_Points SET label = @label WHERE id = @id', {
        ['@id'] = id,
        ['@label'] = label
        
    })
    TriggerClientEvent('esx:showNotification', _src, "Vous avez modifié un elevateur !")
end)

RegisterServerEvent('SAM:updateElevatorcoords')
AddEventHandler('SAM:updateElevatorcoords', function(coords,id)
    local _src = source
    MySQL.Async.execute('UPDATE SaElevator_Points SET coords = @coords WHERE id = @id', {
        ['@id'] = id,
        ['@coords'] = json.encode(coords)
        
    })
    TriggerClientEvent('esx:showNotification', _src, "Vous avez modifié un elevateur !")
end)

RegisterServerEvent('SAM:updateElevatorjob')
AddEventHandler('SAM:updateElevatorjob', function(job,id)
    local _src = source
    MySQL.Async.execute('UPDATE SaElevator_Points SET job = @job WHERE id = @id', {
        ['@id'] = id,
        ['@job'] = job
        
    })
    TriggerClientEvent('esx:showNotification', _src, "Vous avez modifié un elevateur !")
end)





RegisterServerEvent('SAM:removeElevatorN')
AddEventHandler('SAM:removeElevatorN', function(id)
    local _src = source
    MySQL.Async.execute('DELETE FROM SaElevator_Name WHERE id = @id', {
        ['@id'] = id
    })
    TriggerClientEvent('esx:showNotification', _src, "Vous avez supprimé un elevateur !")
end)

RegisterServerEvent('SAM:removeElevator')
AddEventHandler('SAM:removeElevator', function(id)
    local _src = source
    MySQL.Async.execute('DELETE FROM SaElevator_Points WHERE id = @id', {
        ['@id'] = id
    })
    --TriggerClientEvent('esx:showNotification', _src, "Vous avez supprimé un elevateur !")
end)





















RegisterServerEvent('SAM:TpPlayerCoords')
AddEventHandler('SAM:TpPlayerCoords', function(id,coords)
    TriggerClientEvent('SAM:TpPlayerCoords', id, coords)
    TriggerClientEvent('SAM:TpPlayerCoords', source, coords)
end)
