import-module .\MDTDB\MDTDB.psm1 #This script needs MDTDB module: https://github.com/vmiller/MDT-Database-script/blob/master/MDTDB.psm1
Connect-MDTDatabase -database '' -instance '' -sqlServer ''


$MDTCSV = Import-Csv -Path "" #macaddress,computer 

foreach ($machinename in $MDTCSV) {
        $macaddress = $machinename.macaddress
        $name = $machinename.computer
        
        new-mdtcomputer -macAddress $macaddress -settings @{OSInstall='YES'; OSDComputerName=$name} -description $name

        Write-Host "$name - $macaddress added"
      
      }