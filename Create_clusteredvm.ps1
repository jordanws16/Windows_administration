# Create vms for a failover cluster from a CSV file
#
$csv = import-csv -Path #Needs fields: "VMPATHS Name,Ram (GB),Vcores,HDDsize,Bootdisk,Storagearea,Machine,cluster,SwitchName"

foreach($VMOBJ in $csv) {

$VMPATH= ($VMOBJ.storagearea+'\'+$VMOBJ.name)

Invoke-Command -ScriptBlock {Mkdir  $VMPATH} -ComputerName $vmobj.Machine

Write-Host "Creating VM: $($VMOBJ.name)"  -ForegroundColor Cyan

New-VM -Name $VMOBJ.Name -MemoryStartupBytes ($VMOBJ.'Ram (GB)' * 1024) -SwitchName $vmobj.SwitchName -Path $VMPATH -Generation 2 -BootDevice CD -NewVHDPath ($VMPATH+'\'+$vmobj.name) -NewVHDSizeBytes ($vmobj.HDDsize+ 'GB') -ComputerName $vmobj.Machine

Add-VMHardDiskDrive -VMName ($VMOBJ.name) -Path $VMOBJ.Bootdisk -ComputerName $vmobj.Machine

Add-ClusterVirtualMachineRole -Cluster $VMOBJ.Cluster -Name $vmobj.name -VMName $vmobj.name





}