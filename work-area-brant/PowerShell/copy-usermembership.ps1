# Import AD commands
import-Module ActiveDirectory

# Login name of user to copy FROM
$copyfrom = Read-host "Enter username to copy from: "

# Login name of user to copy TO
$pasteto  = Read-host "Enter username to copy to: "

# Get membership of FROM and add to TO
get-ADuser -identity $copyfrom -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $pasteto