import-module activedirectory

$csv = Import-Csv "" #Givenname,Surname,EmployeeID,OU

foreach ($user in $csv){

try 
    {
    get-aduser -Filter {givenname -like $user.Givenname -and surname -like $user.Surname} -SearchBase ($user.OU)| Set-ADUser -EmployeeID $user.EmployeeID #-WhatIf
    }
catch
    {
    Write-Host "Failed to assign EmployeeID/personal reference to $($givenname, $Surname) with EmployeeID: $($user.EmployeeID), Error: $($_.exception.message)" -ForegroundColor Red
    }

}