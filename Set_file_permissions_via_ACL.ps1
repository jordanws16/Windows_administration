#WARNING: Extremely Memory intensive but very effective, use sparingly.


$path = Read-Host "Path? LocalPath ONLY No SMBshares"
$user = Read-Host "user? Domain\username format"


Function Set-FolderPermissions($path,$user){
    $dir = Get-ChildItem -Path $path -Recurse
    foreach ($item in $dir) {
        Write-Host "Opening file $($item.fullname)...." -ForegroundColor Yellow    
        try{
            $ACL = $item.GetAccessControl('Access')

            $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(($user),"modify","Allow")

            $acl.SetAccessRule($AccessRule)

            $acl | Set-Acl $item
            Write-Host "Successfully applied permissions to $($item.fullname)" -ForegroundColor Cyan

        } catch{
            Write-Host "Failed to apply permissions to $($item.fullname) Error: $($_.exception.message)" -ForegroundColor Red
        }
    }

}

Set-FolderPermissions -path $path -user $user