# This code uninstalls Teams from all Profiles installed on the local computer.  

  $TeamsInstallLocation = [System.IO.Path]::Combine($env:LOCALAPPDATA, 'Microsoft', 'Teams')  

$TeamsUpdateExeLocation = [System.IO.Path]::Combine($env:LOCALAPPDATA, 'Microsoft', 'Teams', 'Update.exe')  

    try  

{  

    if (Test-Path -Path $TeamsInstallLocation) {  

                # Uninstall app  

        $TeamsProcess = Start-Process -FilePath $TeamsUpdateExeLocation -ArgumentList "-uninstall -s" -PassThru  

        $TeamsProcess.WaitForExit()  

    }  

    if (Test-Path -Path $TeamsInstallLocation) {  

               Remove-Item -Path $TeamsInstallLocation -Recurse                 

    }  

}  

catch  

{  

     exit /b 1  # If you catch an error , exit  

}  

# Now get rid of the Machine-Wide installer   

   

 $MachineWide = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Teams Machine-Wide Installer"}   

   $MachineWide.Uninstall()      