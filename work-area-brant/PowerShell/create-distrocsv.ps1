#%# Section for designating any "$"

	## Assigning the CSV filepath under the name of "$ImportLocation"
	
$ImportLocation = 'C:\examplepath\emailList.csv'



#%# Main Script Being Run

	## Import the CSV and do the following for each item within the CSV file

Import-Csv $ImportLocation | ForEach {

	## If able to match the item in the pipeline with anything in AD then do following (below in { })

if ( Get-ADUser -Filter "EmailAddress -eq '$($_.Email)'" ) 

{

	## Add the designated Distribution Group to the current item in the pipeline

Add-DistributionGroupMember -Id "#Example Distribution List" -Member $_.Email

}

	## If unable to match the current item in the pipeline with anything in AD then do following

else

{

	## Create a new Mailcontact for the current Item in the Pipeline and place the new contact in the designated AD file path

New-MailContact -OrganizationalUnit "%%%Active Directory Path For Contacts%%%" -Name $_.Email -DisplayName $_.Email -ExternalEmailAddress $_.Email;

	## Add the designated Distribution Group to the new Mailcontact

Add-DistributionGroupMember -Id "#Example Distribution List" -Member $_.Email

}

}