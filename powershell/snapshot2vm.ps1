# 잘 작동되고 있는 VM에서 OS 디스크를 Snapshot으로 만들어서 특정 시점의 백업을 만든 후 
# Snapshot에서 다시 VM을 생성해야 할 때 사용하는 스크립트 
# VM을 생성할 때 기존 리소스 그룹과 가상네트워크를 사용함. 
# 특히 VM에서 이미지를 생성하기 전에 Snapshot으로 백업 후 Restore 할 때 사용 가능 

# 파라미터 설정
$location = "koreacentral"
$rgName = "ManagedDiskGroup"
$snapshotRGName = 'SnapshotGroup'
$snapshotName = 'VM1-snapshot00'
$vmName = 'VM2'

$vnetName = "ManagedDiskGroup-vnet"
$subnetName = "default"
$avsetName = "ManagedAVSet"

# Snapshot 가져오기 
$snapshot = Get-AzureRmSnapshot -SnapshotName $snapshotName -ResourceGroupName $snapshotRGName
# 가상네트워크 가져오기
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $rgName -Name $vnetName
# 가상네트워크 서브넷 가져오기 
$subnetConfig = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $frontendSubnetName
# 가용성 집합 가져오기
$avset = Get-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name $avsetName


# Public IP 만들기 
$pipName = $vmName + "PIP"
$pip = New-AzureRmPublicIpAddress -Name $pipName -ResourceGroupName $rgName -Location $location -AllocationMethod Dynamic
# 새로운 NIC(Network Interface Card) 만들기 
$nicName = $vmName + "NIC"
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -SubnetId $subnetConfig.Id -PublicIpAddressId $pip.Id

# Snapshot에서 Managed Disk 만들기
$diskType = 'PremiumLRS'
$managedDiskCreateOption = 'Copy' 
$diskName = $vmName + "-osdisk"
$diskConfig = New-AzureRmDiskConfig -AccountType $diskType -Location $location -CreateOption $managedDiskCreateOption -SourceResourceId $snapshot.Id
$osDisk = New-AzureRmDisk -DiskName $diskName -Disk $diskConfig -ResourceGroupName $rgName

# 여기까지가 Snapshot에서 Managed Disk 만들기 
# -------------------------------------

# 새로운 VM 만들기 위한 준비 
$vmSize = 'Standard_DS2_v2' # 'StandardLRS'
$diskCreateOption = 'Attach'
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize -AvailabilitySetId $avset.Id
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id
$vm = Set-AzureRmVMOSDisk -VM $vm -Name $diskName -ManagedDiskId $osDisk.Id -CreateOption $diskCreateOption -Windows -Caching ReadWrite

# 드디어 VM 만들기 
New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $vm -Verbose

# 완료 




# ---------------------------------------
# 아래는 참조용 
# 특정 지역에서 사용가능한 VM 사이즈 리스트 
Get-AzureRmVMSize -Location $location
