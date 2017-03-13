# Azure Snapshot으로 VM 생성
Azure의 Managed Disk는 Snapshot을 만들어 특정 시점의 백업을 만들 수 있습니다. Snapshot을 만드는 방법은 ["관리 스냅숏을 사용하여 Azure Managed Disk로 저장된 VHD 복사본 만들기"](https://docs.microsoft.com/ko-kr/azure/virtual-machines/virtual-machines-windows-snapshot-copy-managed-disk)를 참조 바랍니다. 

만들어진 Snapshot에서 다시 Managed Disk를 만들 수 있고 이 Managed Disk를 이용하여 VM을 생성할 수 있습니다. 이 기능은 아직 (2017-03-13 현재) Azure Portal에서 지원하지 않는 기능이므로 Powershell을 이용하거나 Azure CLI를 사용해야 합니다. 

PowerShell 작업은 4단계로 진행됩니다. 
1. Snapshot / 가상네트워크 / 서브넷 가져오기 
1. Public IP / NIC(Network Interface Card) 만들기 
1. Snapshot에서 Managed Disk 만들기 
1. VM 만들기

* PowerShell
* Azure CLI

PowerShell로 진행하려면 
Azure PowerShell Resource Manager modules의 최신버전이 필요합니다. (2017-03-13 현재 3.7.0) 설치 방법은 1) [MSI 설치파일](https://github.com/Azure/azure-powershell/releases/download/v3.7.0-March2017/azure-powershell.3.7.0.msi) 2) [Microsoft Web Platform Installer](http://aka.ms/webpi-azps) 3) Windows PowerShell을 관리자 모드로 실행하고 > Install-Module AzureRM 실행 

Azure CLI로 진행하려면 
Azure CLI 최신버전이 필요합니다. 설치방법은 [Azure CLI 설치](https://docs.microsoft.com/ko-kr/azure/xplat-cli-install)문서를 참조 바랍니다. 