#Designed for creating MS Team classes from a list of CSVs and students within.
$usercredential = get-credential

Connect-MicrosoftTeams -Credential $usercredential
Connect-AzureAD -credential $usercredential

$teamslist = @()

$owner  = ''
#$Secondaryowners  = '' #separate with comma's #uncomment to add more owners


$classfolder = #Array or similar of CSVs (ie get-childitem -path )


foreach ($class in $classfolder) {
    
    #Template means the teams will be classes rather than standard teams, this is specific to my environment.
    
    $team = new-team -Template EDU_Class -DisplayName $class.basename.Replace(' ','-')  -Owner $owner

    if ($Secondaryowners -ne $null) {
        foreach ($Secondaryowner in $Secondaryowners.split(',')) {

            Add-TeamUser -GroupId $class.objectid -User (Get-MsolUser -UserPrincipalName  $Secondaryowner| select UserPrincipalName,DisplayName,objectid,firstname,lastname).objectid -Role Owner

        } else {write-host "No Secondary owners to add, Skipping." -ForegroundColor cyan}

    } else {Write-host "No extra users to add as owners other than main owner, Skipping secondary owner process for $($class.basename)" -ForegroundColor cyan

    $Classlist = import-csv -Path $class.FullName


    foreach ($user in $Classlist){
        #Student/csv Iteration
        add-azureadgroupmember -ObjectId $team.objectid -RefObjectId (Get-MsolUser -UserPrincipalName $user.emailaddress | select UserPrincipalName,DisplayName,objectid,firstname,lastname).objectid
        
        }
    
    $teamslist += @(
                    [pscustomobject]@{
                    "User" = $user.EmailAddress
                    "Team-Objectid" =  $team.groupid
                    "Team" =  $team.Displayname
                    "Team-Owner" =  $OWNER
                    "Team-secowner" =  $Secondaryowner

                    }
                    )

    }



}

$teamslist | Out-GridView