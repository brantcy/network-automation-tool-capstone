<#
Strip-Groups.ps1
This script will strip membership of all but the current Primary (default) Group, for any Disabled Users.

Call it with a User Name or comma-separated list to only process that/those User(s), Disabled or not.
#>
$DefaultGroup = "Domain Users"

# Open a Session with Exchange Server if needed
If (!(Get-PSSession)){
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://scserver.ramjacksc.local/PowerShell/ -Authentication Kerberos
	Import-PSSession $Session
}  # End if we've already imported the Session

# Get Target Username by command-line or prompt
If ($Args[0]){$UserList = $Args.Split(',').Trim(' ')}  # Allow command-line input
Else {  #  If no command arguments, interact with console
	Write-Host "`t`t`t$(([io.fileinfo]$MyInvocation.MyCommand.Definition).BaseName) -- Remove all Group Memberships except the Default.`n`n" -ForeGround Green
	$UserList = (Read-Host "`n`tEnter User Name(s); [Enter] for all Disabled Users").split(',').trim(' ')  # Separate names with ',' no quotes, trim spaces
	If (!$UserList){$UserList=(Get-ADUser -Filter {(Enabled -eq $False)} -Properties SAMAccountName, PrimaryGroup, Enabled | Sort)}  #  If none entered, get them all
	}  # End, parse command line

# Pull all extra Groups per User(s)
ForEach ($TargetUser in $UserList){

# If User(s) entered at command line or prompt, load the variable with details
	If (!$TargetUser.SAMAccountName){$TargetUser = (Get-ADUser $TargetUser -Properties SAMAccountName, PrimaryGroup, Enabled)}  # End If Username entered directly
# Inform.
	$pct = [System.Math]::Abs(($UserList.IndexOf($User) * 100 / $UserList.Count))  # Fix upcoming error if one User entered
	Write-Progress -Activity "Stripping Excess Group Assignments" -Status "Checking $($TargetUser.Name)" -CurrentOperation "Enabled = $($TargetUser.Enabled)" -PercentComplete $pct

# Get this User's Primary Group membership, to leave it in place.
	$DefaultGroup = Get-ADPrincipalGroupMembership $TargetUser |
	 Where {$_.DistinguishedName -eq $TargetUser.PrimaryGroup}

# Get all this User's Group memberships - If not the Default Group, remove the membership
	ForEach ($ExtraGroup in (Get-ADPrincipalGroupMembership $TargetUser)){
		If ($ExtraGroup.DistinguishedName -notlike $DefaultGroup){
			Write-Host "`t$($DefaultGroup.Name)`tClearing $($ExtraGroup.Name) from $($TargetUser.Name)" -ForeGround Yellow
			Remove-ADPrincipalGroupMembership -Identity $TargetUser -MemberOf $ExtraGroup.SAMAccountName -confirm:$false -ErrorAction SilentlyContinue
		}  # End if not the Default Group
	}  # End For Each ExtraGroup
Write-Host "$($TargetUser.SAMAccountName) now exists in:" ((Get-ADPrincipalGroupMembership $TargetUser).Name | Sort) -ForeGround Green
}  # End For Each Target User