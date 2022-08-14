Import-Module ActiveDirectory

$users = get-aduser -SearchBase "" -Filter * -Properties thumbnailPhoto | where thumbnailPhoto -notlike $null

foreach($user in $users) {
try{Write-Host ("Removing $($user.DistinguishedName)'s Profile photo...)") -ForegroundColor cyan
Set-ADUser "user" -Clear thumbnailPhoto
}catch {Write-Host ("Failed to remove $($user.DistinguishedName)'s Profile photo $($_.exception.message)") -ForegroundColor Red}
}