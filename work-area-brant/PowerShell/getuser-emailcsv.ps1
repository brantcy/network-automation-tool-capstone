#script to use name to export email addresses to CSV
Import-Module ActiveDirectory

$CSV = Import-Csv -Path C:\EmployeeNames.csv

$count = 0
$count2 = $CSV.Count

#loops through names & exports email address to CSV
foreach ($num in $CSV)
{
    $name = $num.name
    Get-ADUser -Filter {name -eq $name} -Properties name,EmailAddress | Select-Object EmailAddress | Export-Csv -Path C:\emailaccounts.csv -NoTypeInformation -Append

    $count++
    Write-Progress -Activity "Script is running" -status "Getting Email Addresses from names..." -percentComplete ($count / $count2 *100)
}
Write-Host "Email Addresses exported to CSV" -ForegroundColor Magenta