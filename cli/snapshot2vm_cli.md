# Azure CLI 2.0으로 Snapshot에서 VM 만들기

### 로그인
<pre><code>
> az login
</code></pre>

로그인을 위해서 https://aka.ms/devicelogin 로 접속하고 Code를 입력하여 로그인 한다. 

### Snapshot 확인 
<pre><code>
> az snapshot list
</code></pre>

Sanpshot의 ID를 확인한다. 이 아이디를 확인하는 이유는 snapshot이 별도의 리소스 그룹에 있을 때 필요하다. Snapshot이 새로 생성할 VM의 리소스 그룹과 같다면 넘어가도 된다. 

### Public IP 만들기 
<pre><code>
> az network public-ip create --resource-group ManagedDiskGroup --location koreacentral --name VM3PIP --allocation-method static
</code></pre>
새로운 VM에 사용할 Public IP를 만든다. 

### 새로운 NIC(Network Interface Card) 만들기 
<pre><code>
> az network nic create --resource-group ManagedDiskGroup --location koreacentral --name VM3NIC --vnet-name ManagedDiskGroup-vnet --subnet default --public-ip-address VM3PIP
</code></pre>
새로운 VM에 사용할 NIC를 만든다. 

### Snapshot에서 Managed Disk 만들기
<pre><code>
> az disk create -g ManagedDiskGroup -n VM3-disk --source /subscriptions/e47f0bbb-cd59-41dc-86b7-2e239d536c04/resourceGroups/SNAPSHOTGROUP/providers/Microsoft.Compute/snapshots/VM1-snapshot00
</code></pre>

--source 의 파라미터로 Snapshot의 이름만 줘도 되는데 여기서는 ID 를 줬다. 그 이유는 Snapshot을 SnapshotGroup이라는 다른 리소스 그룹 넣어놨기 때문이다. 

### 가용성 집합(Availability Set) 만들기
<pre><code>
> az vm availability-set create --resource-group ManagedDiskGroup --location koreacentral --name ManagedAVSet --platform-fault-domain-count 2 --platform-update-domain-count 3
</code></pre>
가용성 집합이 없으면 만들어준다. VM을 새로 만들때만 가용성 집합에 넣을 수 있다. 

### 드디어 VM 만들기 
<pre><code>
> az vm create --resource-group ManagedDiskGroup --name VM3 --location koreacentral --availability-set ManagedAVSet --nics VM3NIC --attach-os-disk VM3-disk --os-type windows
</code></pre>

최종적으로 새로만든 디스크를 Attach 하고, 새로만든 NIC를 붙이고, 가용성집합에 넣으면서 VM을 생성한다. 

