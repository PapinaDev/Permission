# Admin Permissions Management Command Guide

## Command Overview
This command allows server administrators with `god` permissions to manage other players' access levels in-game.

## Basic Command Syntax
```
/admin [action] [playerID] [permission]
```

## Parameters
| Parameter    | Required | Description                                                                 | Possible Values          |
|-------------|----------|-----------------------------------------------------------------------------|--------------------------|
| `action`    | Yes      | Whether to add or remove permissions                                        | `add`, `remove`          |
| `playerID`  | Yes      | The server ID of the target player                                          | Any connected player ID  |
| `permission`| No       | The permission level to grant/revoke (defaults to 'admin' when adding)      | `user`, `admin`, `god`   |

## Usage Examples

### Adding Permissions
1. Grant basic admin access to player ID 15:
   ```
   /admin add 15 admin
   ```

2. Grant highest-level god permissions to player ID 22:
   ```
   /admin add 22 god
   ```

3. Grant default (admin) permissions without specifying level:
   ```
   /admin add 31
   ```

### Removing Permissions
1. Remove all permissions from player ID 15:
   ```
   /admin remove 15
   ```

2. Remove specific god permissions while keeping admin access:
   ```
   /admin remove 22 god
   ```

## Permission Hierarchy
1. **user** - Regular player (default)
2. **admin** - Basic administrator privileges
3. **god** - Highest-level access (required to use this command)

## System Messages
- Successful actions will show green notifications for both the admin and target player
- Errors (invalid syntax, missing permissions, etc.) will show red notifications
- Players receive notifications when their permissions change

## Requirements
- Only players with `god` permissions can use this command
- Target player must be online
- QBCore framework must be properly initialized

## Troubleshooting
- If command doesn't work:
  - Verify you have `god` permissions
  - Check target player is online (correct ID)
  - Ensure QBCore is fully loaded
  - Confirm no typos in the command

## Best Practices
- Always verify player identity before granting permissions
- Use specific permission removal when downgrading access
- Document permission changes for administrative records
- Consider using temporary permissions for testing