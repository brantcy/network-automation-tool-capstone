# Base OU for searching for expired accounts
$BaseSearchOU="OU=Users,DC=Domain,DC=Local"

# OU that the expired accounts will be moved to
$DestinationOU="OU=DisabledUsers,DC=Domain,DC=Local"

# Imports the PowerShell AD module **NOTE** RSAT needs to be installed on the system running the script
if (Get-Module -ListAvailable -Name ActiveDirectory) {

    Import-Module ActiveDirectory

#  If the module is not available write a message to the terminal and end the script   
} else {
    Write-Host "No Active Directory Module found. MS RSAT tools need to be installed, see https://www.microsoft.com/en-ca/download/details.aspx?id=45520" -ForegroundColor Red

    throw "Error"
}
