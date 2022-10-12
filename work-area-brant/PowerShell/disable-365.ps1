######## READ ME #######

#Script must be run as a -A account
#Script will : Set Out of Office, set forwarding address, remove 365 and local AD memberships, disable both 365 and AD account

####


##Start Log Transcript
Start-Transcript –path "**ADD YOUR LOG DIRECTORY HERE *** Leavers.log” –Append -NoClobber

$ErrorActionPreference = "SilentlyContinue"

Connect-ExchangeOnline
sleep 10
Connect-AzureAD 
sleep 5
import-module ActiveDirectory

##SELECT USER TO DECOMISSION
$leaver = read-host "enter user email address"

##FORMAT USERNAME FOR EMAIL OOO
$username = get-aduser -Filter {EmailAddress -eq $leaver} | Select-Object -ExpandProperty Name 

##FORMAT USERNAME FOR AD
$disusername = get-aduser -Filter {EmailAddress -eq $leaver} | Select-Object -ExpandProperty SamAccountName 

###SET OOO *
Set-MailboxAutoReplyConfiguration -Identity $leaver -AutoReplyState  Enabled -InternalMessage "$username has left ***company name***" -ExternalMessage "$username is not currently available. For urgent enquiries please contact ***AN EMAIL ADDRESS***"

##CREATE FORWARDING RULE
New-InboxRule "LEAVERS" -Mailbox $leaver -RedirectTo @('***LEAVERS EMAIL GROUP***')

##REMOVE 365 GROUP MEMBERSHIPS
$AADGroups = Get-AzureADMSGroup -Filter "groupTypes/any(c:c eq 'Unified')" -All:$true
$AADUser  = Get-AzureADUser -Filter "UserPrincipalName eq '$leaver'"
ForEach ($Group in $AADGroups) 
{
    $GroupMembers = (Get-AzureADGroupMember -ObjectId $Group.id).UserPrincipalName
    If ($GroupMembers -contains $leaver)
    {
        Remove-AzureADGroupMember -ObjectId $Group.Id -MemberId $AADUser.ObjectId 
        Write-Output "$leaver was removed from $($Group.DisplayName)"
    }
}

#REMOVE LOCAL AD GROUPS
Get-Aduser -filter {mail -eq $leaver} | Remove-ADPrincipalGroupMembership -memberof ***LIST OF GROUP NAMES*** -Confirm $false

#DISABLE 365 ACCOUNT
Set-AzureADUser -ObjectID $leaver -AccountEnabled $false

##DISABLE LOCAL AD ACCOUNT
Disable-ADAccount -Identity $disusername


Stop-Transcript