Import-Module ActiveDirectory

$users = get-aduser -SearchBase "OU" -Filter * -Properties thumbnailPhoto| where thumbnailPhoto -notlike $null
$PicturePath = "Path to download pictures to"

foreach($user in $users) {

    try{Write-Host ("Downloading $($user.DistinguishedName)'s Profile photo...)") -ForegroundColor Cyan

        $user.thumbnailPhoto | Set-Content "$($PicturePath)\$($user.SamAccountName).jpg" -Encoding byte
    
    }catch {Write-Host ("Failed to download $($user.DistinguishedName)'s Profile photo $($_.exception.message)") -ForegroundColor Red}
}