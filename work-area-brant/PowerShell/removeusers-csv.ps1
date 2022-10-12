#4/19/2010 
#script to modify termed users 
#1.pull termed users from CSV 
#remove user group membership 
#2.Clear Manager property 
#3.Hide from GAL 
#4.move to disabed OU 
#5.rename csv to completed date, move to completed 
$groupmembershiplog="c:\removeADAttributes\group_membership_log.csv" 
$erroractionpreference = "SilentlyContinue" 
$termfile=Test-Path -Path "C:\removeADAttributes\termed_employees.csv" 
 
 
If ($termfile -eq "True") { 
$inputcsv="C:\removeADAttributes\termed_employees.csv" 
$completeddir="C:\removeADAttributes\completed\" 
$date=Get-Date -format d 
 
import-CSV $inputcsv | foreach-object { 
$username=$_.account 
 
#export groups to file 
$groups=(Get-QADUser $username).memberof 
Add-Content $groupmembershiplog $username","$groups 
 
#remove groups 
$groups | Get-QADGroup | where {$_.name -ne "domain users"} | Remove-QADGroupMember -Member $name 
 
 
Set-QADUser -Identity $username -objectattributes @{"Manager"="$null"} 
$currentuser=Get-QADUser -Identity $username -SizeLimit 1 
$currentOU=$currentuser.parentcontainer 
$currentOU = $currentOU.Split('/') 
$currentOU = $currentOU[1] 
Move-QADObject -identity $username -NewParentContainer "domainname.com/$ou/Disabled Accounts" 
} 
 
import-CSV $inputcsv | foreach-object { 
$username=$_.account 
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin 
Set-Mailbox -Identity $username -HiddenFromAddressListsEnabled $true 
} 
import-CSV $inputcsv | foreach-object { 
$username=$_.account 
Add-Content "C:\removeADAttributes\removeADAttributes_log.csv" $date","$username 
} 
 
Move-Item $inputcsv -Destination $completeddir 
$todaydate=$date.replace("/","_") 
$newfilename=$todaydate+".csv" 
Rename-Item "C:\removeADAttributes\completed\termed_employees.csv" -NewName $newfilename 
 
} 
else { 
$date=Get-Date -format d 
Add-Content "C:\removeADAttributes\removeADAttributes_log.csv" $date",no term user, no term user" 
exit 
} 