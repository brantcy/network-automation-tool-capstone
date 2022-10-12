#Script to bulk Disable AD, remove group memberships, and move to Disabled Users OU
$csv = Import-Csv -Path C:\samAccountNames.csv
Write-Host "CSV has been imported" -ForegroundColor Magenta

Import-Module ActiveDirectory
$server = "ServerFQDN"

#user account to be disabled
#$user = Read-Host -Prompt 'Enter the User account name'
foreach ($account in $csv)
{
    $user = $account.samaccountname
    Write-Host "The user is $user"  -ForegroundColor Green

    #disable AD account and set date for when the account was disabled
    Disable-ADAccount -Identity $user -Server $server
    $date = Get-Date -Format "MM/dd/yyyy"
    Set-ADUser -Identity $user -Description "Disabled $date" -Server $server
    Write-Host "$user has been disabled on $date"  -ForegroundColor Yellow

    #remove group memberships that are not Domain Users
    $DomainUsers = "Domain Users"
    $Groups = Get-ADPrincipalGroupMembership -Identity $user -Server $server | Where- 
    Object {$_.name -ne $DomainUsers}
     
    #loop removes group memberships except for Domain Users
    foreach ($group in $groups)
    {
	    Remove-ADPrincipalGroupMembership -Identity $user -server $server -MemberOf $group -Confirm:$false
    }

    #move account to Disabled Users OU, edit this to the distinguishedName path for the OU 
    #you want to move the account to
    $DisabledOU = "Disabled Users OU"
    Get-ADuser $user -server $server -Properties DistinguishedName | Move-ADObject -TargetPath $DisabledOU
}
Write-Host "Accounts from CSV have been moved to the Disabled Users OU"  -ForegroundColor Green