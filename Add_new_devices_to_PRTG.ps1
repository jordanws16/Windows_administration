# This script creates new PRTG Devices in the top section and adds a ping sensor in the lower section.
# You'll need the PRTGAPI installed using "Install-Package PrtgAPI -Source PSGallery"
 
$creds = Get-Credential

Connect-PrtgServer path -Credential $creds -IgnoreSSL

# CSV Format
# Name,IP

#Where is the CSV file?
$csv = Import-Csv ""
# Which group ID should the new devices be added to? You can get this from PRTG
$groupid = 0000

foreach ($line in $csv) {
    Get-Group -Id $groupid | Add-Device -Name $line.Name -Host $line.IP
}

#Add a ping sensor to each device. The sensor starts paused.
$newDevices = Get-Group -Id $groupid | Get-Device
foreach ($device in $newDevices) {
    Get-Sensor ping -count 1 | Clone-Object -DestinationId $device.ID
}














