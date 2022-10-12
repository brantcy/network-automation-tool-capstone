#script to create a computer object in AD
Import-Module ActiveDirectory
Write-Host "Starting script to create a Desktop in Computer OU" -ForegroundColor Yellow

#put the DistinguishedName path for the OU you want to create the computer in
$OUPath = "Computer OU"
#prompt to input computername
$NewWS = Read-Host 'Please enter a computername'

#creates new computer
New-ADComputer -Name $NewWS -Path $OUPath

Write-Host "Computer $NewWS has been created!" -ForegroundColor Green