![Active directory microsoft](https://ivorontita.com/wp-content/uploads/2020/06/kisspng-active-directory-federation-services-microsoft-off-5b1e5b080fff82.7771912715287160400655.png)

# Environment Setup
This document details the Azure environment provisioned for an Active Directory home lab, including VM configuration, networking, and domain infrastructure.

## Lab Overview
I've built a Windows Server 2022 Domain Controller and a Windows 10 Pro client computer to simulate 

## Lab Architecture
- ![Network Topology](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/network_Topology.png)
- [IP address table]

## Azure Infrastructure
### Resource Group
- **Subscription:** Deafult
- **Resource group name:** AD-Lab
- **Regions:** (US) North Central US
![Resource Group Configuration ](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/01-setup/resourcegroup.png)

### Virtual Network & Subnet
- **Subscription:** Deafult
- **Resource group:** AD-Lab
- **Virtual Network Name:** ActiveDirectoryVNet
- **Regions:** (US) North Central US
![Resource Group Configuration ](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/01-setup/virtualnetwork.png)

### Domain Controller VM (Windows Server 2019)
- **Image:** Windows Server 2022 Datacenter
- **VM name:** DC-1
- **Static Private IP:** 10.0.0.4
- **Virtual Network:** ActiveDirectoryVNet
- **Location:** (US) North Central US
![Resource Group Configuration ](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/01-setup/DC-1.png)

### Client VM (Windows 10 Pro)
- **Image:** Windows 10 Pro
- **VM name:** Client-1
- **DNS Server:** 10.0.0.4
- **Virtual Network:** ActiveDirectoryVNet
- **Location:** (US) North Central US
![Resource Group Configuration ](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/01-setup/Client-1.png)


## Pre-Configuration Steps
- Assign a static private IP address to the Domain Controller virtual machine (10.0.0.4)
- Configured the client virtual machine's DNS server to the Domain Controller's IP address (10.0.0.4)
- Allowed Inbound ports 3389 (RDP) for both VMs


## Environment Validation
[Proof it's running — screenshot of both VMs "Running" in Azure portal]