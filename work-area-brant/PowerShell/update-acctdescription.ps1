#script to update user description field

Import-Module ActiveDirectory

#enter username
$user = Read-Host -Prompt 'Enter User Account'

#enter description
$desc = Read-Host -Prompt 'Enter new Description'

Write-Host "The user is $user" -ForegroundColor Yellow
Write-Host "This will be the new description: $desc" -ForegroundColor Magenta

#sets new description
Set-ADUser -Identity $user -Description $desc

Write-Host "Description for $user in AD has been updated to $desc" -ForegroundColor Green