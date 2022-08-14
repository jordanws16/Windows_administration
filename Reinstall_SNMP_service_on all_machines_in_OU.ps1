
$machines = Get-ADComputer -filter * -searchbase "OUDN"|select dnshostname
foreach($machine in $machines){
        

        Invoke-Command -ComputerName $machine.dnshostname -ScriptBlock {
        try{Uninstall-WindowsFeature -Name 'SNMP-Service','RSAT-SNMP'
            Write-Host "Removed Windows feature successfully.." -ForegroundColor Cyan
            Restart-Computer -Force

        } 
        catch 
        {Write-Host "Failed to Uninstall Services $($_.exception.message)" -ForegroundColor cyan}


        }-ArgumentList $Monitoringsystems,$strings,$machine
    
        Start-Sleep -Seconds 15
   
        while((Test-NetConnection -ComputerName $machine.dnshostname -InformationLevel Quiet) -notmatch $true) {}
    
        Invoke-Command -ComputerName  $machine.dnshostname -ScriptBlock {
         $Monitoringsystem = 'Monitoring.dixonsat.com'
         $strings = @(
        @{
            Name = 'Public'
            Rights = 'Read Only'
        }
        ) 
         $i=2
        
        try{Install-WindowsFeature -Name 'SNMP-Service','RSAT-SNMP'
        if (get-wmiobject -computer LocalHost win32_computersystem|where model -notmatch "Virtual"){}
            Write-Host "Re-installed Windows feature successfully.." -ForegroundColor Cyan



            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers"  -Name $i -Value $Monitoringsystem
            

        foreach ($string in $strings) 
            {
                switch ($string.Rights)                                                                                                     {
                    'Read Only' {
            $val = 4
        }
                    'Read Write' {
            $val = 8
        }
                    }
    
                New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities"  -Name $string.Name -Value $val
            }

            
        } catch {Write-Host "Failed to install Services $($_.exception.message)" -ForegroundColor cyan}
        
}
 
}
