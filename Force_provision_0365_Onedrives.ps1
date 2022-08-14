#Force Provision 0365 OneDrive.

Import-Module Microsoft.Online.SharePoint.PowerShell
Connect-SPOService -Url "Sharepoint tenant url"

$csvstore = import-csv "Path" #Path of CSV with column of SAMACCOUNTNAME's

foreach ($user in $csvstore) {

    $adinfo = Get-ADUser -Server $domaincontroller -Properties UserPrincipalName -Identity $user.SAMACCOUNTNAME
    
    Request-SPOPersonalSite -UserEmails $adinfo.UserPrincipalName

}