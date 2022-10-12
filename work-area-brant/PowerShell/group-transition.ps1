#script to get members of a group, remove from the group, & add to a new group
Import-Module ActiveDirectory

#gets all members of the old group and exports to a CSV
$oldgroup = Read-Host -Prompt "Enter old group"
Get-ADGroupMember -Identity $oldgroup | select name | Export-Csv C:\GroupMembers.csv -NoTypeInformation

#gets all current members of the new group
$newgroup = Read-Host -Prompt "Enter new group"
Get-ADGroupMember -Identity $newgroup | select name | Export-Csv C:\NewGroupBeforeChange.csv -NoTypeInformation

#variable to get all members of the old group
$members = Get-ADGroupMember -Identity $oldgroup -Recursive | Select -ExpandProperty samaccountname

#loop to remove members from old group & add members to the new group
Foreach ($account in $members)
{
    Write-Host "Account is $account" -ForegroundColor Yellow

    Remove-ADGroupMember $oldgroup -Members $account -Verbose -confirm:$false
    Write-Host "$account removed from $oldgroup" -ForegroundColor Red

    Add-ADGroupMember $newgroup -Members $account -Verbose
    Write-Host "$account added to $newgroup" -ForegroundColor Green
}

Write-Host "All accounts from $oldgroup are now members of $newgroup"