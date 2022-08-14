#Pull wasted licenses on test or fake users.
#Useful for badly maintained environments
#Needs reformatting and rationalisation ideally but works as is.

$usercredential = get-credential

Connect-AzureAD -Credential $usercredential
Connect-MsolService -Credential $usercredential
Connect-ExchangeOnline -Credential $usercredential

$all = get-azureaduser -All $true #Can be filtered down dependent on requirements but for my environment the wide range was needed.

#filter users for common attributes ie Test,fake,temp,testuser, etc
$testortempusers = $all |where {($_.DisplayName -like '*temp*' -or $_.name -like '*temp*'-or $_.userprincipalname -like '*temp*' -or $_.extensionproperty -like '*temp*') `
                -or ($_.DisplayName -like '*test*' -or $_.name -like '*test*' -or $_.userprincipalname -like '*test*'-or $_.extensionproperty -like '*test*') `
                -or ($_.DisplayName -like '*leaver*' -or $_.name -like '*leaver*' -or $_.userprincipalname -like '*leaver*'-or $_.extensionproperty -like '*leaver*') `
                 -or ($_.DisplayName -like '*(old*' -or $_.name -like '*(old*' -or $_.userprincipalname -like '*(old*' -or $_.extensionproperty -like '*old*' ) `
                 -or ($_.DisplayName -like '*fake*' -or $_.name -like '*fake*' -or $_.userprincipalname -like '*fake*' -or $_.extensionproperty -like '*fake*' ) `
               
                
                } 
$accountID = ('') #tenantID

$ConsumedFirstpass = @()

$i =0
$testortempusers| foreach {
    $i++
    Write-Host "$($i) of $($testortempusers.Count)" -ForegroundColor Cyan

    $licenses = $null
    $user= $null

    $licenses = $_|select -ExpandProperty assignedlicenses |select SkuId|foreach{Get-AzureADSubscribedSku -ObjectId ($accountID+$_.skuid)}
    $user= $_ 

    foreach($license in $licenses){
        $ConsumedFirstpass += @(
                        [pscustomobject]@{
                        "Userprincipalname"=$user.userprincipalname
                        "LicenseName"=$license.skupartnumber
                        "LicenseSkuID"=($license.objectid)

                        })}
}


foreach($licensetype in (Get-AzureADSubscribedSku)){

    $firstreport += @(
                    [pscustomobject]@{
                    "License technical name" = $licensetype.SkuPartNumber
                    "License Sku ID" = $licensetype.Skuid
                    "License Potentially freed" = ($ConsumedFirstpass|where LicenseName -like $licensetype.SkuPartNumber).Count

                })

}
$firstreport|Out-GridView

$firstreport|export-csv -Path "$($onedrive)\WastedLicensereport.csv" -NoTypeInformation