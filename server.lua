function QBCore.Functions.RemovePermission(source, permission)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    if permission then
        if IsPlayerAceAllowed(src, permission) then
            ExecuteCommand(('remove_principal identifier.%s qbcore.%s'):format(citizenid, permission))
            MySQL.Async.execute('DELETE FROM permissions WHERE citizenid = ?', { citizenid })
            QBCore.Commands.Refresh(src)
        end
    else
        for _, v in pairs(QBCore.Config.Server.Permissions) do
            if IsPlayerAceAllowed(src, v) then
                ExecuteCommand(('remove_principal identifier.%s qbcore.%s'):format(citizenid, v))
                MySQL.Async.execute('DELETE FROM permissions WHERE citizenid = ?', { citizenid })
                QBCore.Commands.Refresh(src)
            end
        end
    end
end

function QBCore.Functions.AddPermission(source, permission)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local citizenid = Player.PlayerData.citizenid
        QBCore.Config.Server.Permissions[citizenid] = {
            citizenid = citizenid,
            permission = permission:lower(),
        }

        MySQL.Async.execute('DELETE FROM permissions WHERE citizenid = ?', { citizenid })
        MySQL.Async.insert('INSERT INTO permissions (name, citizenid, permission) VALUES (?, ?, ?)', {
            GetPlayerName(src),
            citizenid,
            permission:lower()
        })
        ExecuteCommand(('add_principal identifier.%s qbcore.%s'):format(citizenid, permission))

        QBCore.Commands.Refresh(src)
        TriggerClientEvent('QBCore:Client:OnPermissionUpdate', src, permission)
    end
end


---command 

QBCore.Commands.Add('permission', 'Manage player permissions', {{name = 'action', help = 'add/remove'}, {name = 'id', help = 'Player ID'}, {name = 'permission', help = 'Permission level (admin/god)'}}, true, function(source, args)
    local src = source
    local action = args[1]
    local playerId = tonumber(args[2])
    local permission = args[3] and args[3]:lower() or nil
    
    if not QBCore.Functions.HasPermission(src, 'god') then
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have permission for this!', 'error')
        return
    end
    

    if action ~= 'add' and action ~= 'remove' then
        TriggerClientEvent('QBCore:Notify', src, 'Invalid action. Use add or remove', 'error')
        return
    end
    

    local targetPlayer = QBCore.Functions.GetPlayer(playerId)
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, 'Player not found', 'error')
        return
    end
    
  
    if permission and not (permission == 'admin' or permission == 'god' or permission == 'user') then
        TriggerClientEvent('QBCore:Notify', src, 'Invalid permission level. Use admin, god, or user', 'error')
        return
    end
    

    if action == 'add' then
        if not permission then
            permission = 'admin'
        end
        QBCore.Functions.AddPermission(playerId, permission)
        TriggerClientEvent('QBCore:Notify', src, ('Added %s permission to %s'):format(permission, GetPlayerName(playerId)), 'success')
        TriggerClientEvent('QBCore:Notify', playerId, ('You have been granted %s permissions'):format(permission), 'success')
    elseif action == 'remove' then
        QBCore.Functions.RemovePermission(playerId, permission)
        TriggerClientEvent('QBCore:Notify', src, ('Removed permissions from %s'):format(GetPlayerName(playerId)), 'success')
        TriggerClientEvent('QBCore:Notify', playerId, 'Your admin permissions have been removed', 'success')
    end
end, 'god')