#Searches for Computers first that are enabled, in a specific OU, not logged in for 120 days. Exports to txt.
Get-ADComputer -Filter {Enabled -eq "true"} -Searchbase "OU=Computers,DC=COMPANY,DC=COM" -Properties * | ?{($_.LastLogonDate -lt (Get-Date).AddDays(-120)) -and ($_.LastLogonDate -ne $NULL)} | Select Name | Out-File C:\users\cormiera\Desktop\DisabledPcs.txt

#gets the computers from the step above and disables them and changes descriptions. Only works with TXT file.
$computers = get-content C:\users\andrew.c.cormier\Desktop\Disabledpcs.txt
Foreach ($computer in $computers){
  $ADComputer = $null
  $ADComputer = Get-ADComputer $Computer -Properties Description
  if ($ADComputer) {
    Write-Host "Found $Computer, inactive for 120 days, disabling" -ForegroundColor Green
    Set-ADComputer $ADComputer -Description "Not logged in for > 120 days. Disabled $(Get-Date)" -Enabled $false
   Write-Host "$Computer has been disabled and updated" -ForegroundColor Cyan
} else {
    Write-Host "$Computer not in Active Directory"
}
}