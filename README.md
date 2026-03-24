# Active Directory Homelab (Enterprise Fundamentals)

## Project Overview
This project is a hands-on Active Directory homelab designed to demonstrate core enterprise identity, access management, and Windows infrastructure fundamentals. The environment simulates real-world administrative responsibilities, including domain creation, OU design, user and group management, authentication validation, Group Policy configuration, secure file sharing, and delegated administration.
The lab was built to mirror how Active Directory is deployed and managed in production environments, with a strong emphasis on security best practices, scalability, and automation using PowerShell.


## What This Project Demonstrates
- Active Directory domain and DNS fundamentals
- Proper OU design based on policy and delegation
- Group-based access control (RBAC)
- User authentication and authorization flow
- Group Policy design and application
- Secure file sharing using NTFS permissions
- Delegation of administrative tasks
- PowerShell automation for identity management


## Technologies and Components Used
-	Windows Server 2019 (Domain Controller)
-	Windows 10 Pro (Domain-joined client)
-	VMware Workstation
-	Active Directory Domain Service (AD DS)
-	DNS (Domain Name Service)
-	DHCP (Dynamic Host Configuration Protocol)
-	File and Storage Services
-	Internet Information Services (IIS)
-	PowerShell


## Network Topology Map 🌐
The environment consists of a domain controller and a Windows client VM connected through a NAT-based virtual network.

![Network Topology](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/network_Topology.png)


## Environment Setup

### Installation Media

- [Windows 10](https://www.microsoft.com/en-us/software-download/windows10ISO) (21H2)
- [Downloads – Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Windows Server 2019 | Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019)

## Active Directory Deployment 🪟
### Installed Server Roles
The server was configured with the required roles and features to support enterprise identity services.
![AD roles and features](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/Roles_and_features.png)


### Domain Controller Promotion
- Promoted Windows Server 2019 to a Domain Controller
- Created a new Active Directory domain: mydomain.com
- Enabled DNS during promotion to support domain services

This step activates Active Directory and establishes the authentication authority for the environment.

## Organizational Unit (OU) Design
- OUs were designed around **policy application and administrative delegation**, following best practices used in enterprise environments.

        OU_Branches
        └── Las_Vegas
            ├── Users
            ├── Workstations
            └── Laptops


![OU_Branches](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/OU_Branches.png)

This structure allows:

- Targeted Group Policy application
- Clean separation of users and devices
- Scalable expansion to additional locations or departments

## User Management
### Domain Users
Created domain user accounts and placed them into the appropriate branch-based Users OU.

- John Davidson (ajohnson)
- Alice johnson (jdavidson)
- Bob martinez (bmartinez)
- Chris walker (cwalker)

![Users](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/Users.png)

### PowerShell Automation
User creation was also performed via PowerShell to demonstrate automation capability.

``` PowerShell
$ou = "OU=Users,OU=Las_Vegas,OU=OU_Branches,DC=mydomain,DC=com"

New-ADUser -Name "Alice Johnson" -GivenName Alice -Surname Johnson -SamAccountName ajohnson -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "John Davidson" -GivenName John -Surname Davidson -SamAccountName jdavidson -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "Bob Martinez" -GivenName Bob -Surname Martinez -SamAccountName bmartinez -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "Chris Walker" -GivenName Chris -Surname Walker -SamAccountName cwalker -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true
```

**‼️Key Notes‼️**
- Users are placed in the correct OU for policy targeting
- Access is granted through **group membership**, not OU placement
- Password and lockout policies are enforced via Group Policy

## Security Groups Design (RBAC)
### Centralized Group Structure

Security groups were stored in a centralized OU to simplify access management.

    _Groups
    ├── Helpdesk
    ├── ITSupport
    ├── HR
    └── Accounting


![Security_groups](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/Security_groups.png)


### Group Membership
- HR -> John Davidson
- Helpdesk -> Alice johnson
- Accounting -> Bob martinez
- ITSupport -> Chris walker

### PowerShell Automation

``` PowerShell
$path = "DC=mydomain,DC=com"
$groupsOU = "OU=_Groups,DC=mydomain,DC=com"

# Creates the _Groups OU first to then add the security groups later
New-ADOrganizationalUnit -Name "_Groups" -ProtectedFromAccidentalDeletion $False -Path $path

# Add new security groups with global scope
New-ADGroup -Name "Helpdesk" -GroupScope Global -GroupCategory Security -Path $groupsOU
New-ADGroup -Name "ITSupport" -GroupScope Global -GroupCategory Security -Path $groupsOU
New-ADGroup -Name "HR" -GroupScope Global -GroupCategory Security -Path $groupsOU
New-ADGroup -Name "Accounting" -GroupScope Global -GroupCategory Security -Path $groupsOU

# Add members to these security groups
Add-ADGroupMember -Identity "Helpdesk" -Members ajohnson
Add-ADGroupMember -Identity "ITSupport" -Members cwalker
Add-ADGroupMember -Identity "HR" -Members jdavidson
Add-ADGroupMember -Identity "Accounting" -Members bmartinez
```

**Why this matters**
- Users almost never get permissions assigned directly. They acquire access through their roles by being placed in a group, and groups are granted access to resources.
- Groups represent job roles
- Permissions are assigned once and scale cleanly

## Domain-Joined Client Validation
A Windows 10 client VM was joined to the domain.

![client_computer](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/client_computer.png)

**Critical DNS Insight**
- The client uses the domain controller as its DNS server
- Active Directory relies entirely on DNS to locate domain controllers
- Incorrect DNS configuration is the most common cause of domain join failures

Successful domain login verified:

- DC discovery
- User authentication
- Security token creation
- Group membership processing

## Real-world Active Directory Responsibilities
### Domain Password Policy
Configured a domain-wide password policy using Group Policy.
![Password Policy](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/Password_policy.png)

### Drive Mapping
#### Logon Script (SYSVOL)

Created a PowerShell logon script stored in SYSVOL, ensuring availability to all domain users.
  
``` Powershell
# Map-Drives.ps1
$DriveLetter = "H"
$SharePath = "\\DC\DeptShare"
$existingDrive = Get-PSDrive -Name $DriveLetter -ErrorAction SilentlyContinue


# Check if drive exists
if (!$existingDrive) {
    New-PSDrive `
        -Name $DriveLetter `
        -PSProvider FileSystem `
        -Root $SharePath `
        -Persist

    Write-Host "Drive $DriveLetter mapped to $NetworkPath successfully." `
    -ForegroundColor Green
} else {
    Write-Host `
        "Drive $DriveLetter is already mapped to $($existingDrive.Root)" `
        -ForegroundColor Yellow
}

```
![map_drives](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/map_drives.png)

#### Group Policy Preference (Recommended)
Also implemented drive mapping using Group Policy Preferences to improve reliability and troubleshooting.
![mapped1](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/mapped1.png)
![mapped2](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/mapped2.png)


### File Share Security (NTFS vs Share Permissions)

- Share permissions were kept permissive
- NTFS permissions enforced access control

**Why**

- NTFS permissions are granular
- Support inheritance
- Apply locally and over the network
- Align with enterprise security best practices


### Delegated Password Reset Permissions to Helpdesk

Delegated password reset permissions to the Helpdesk group using the Delegation of Control Wizard.

![Delegation2](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/delegation1.png)

![Delegation1](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/delegation2.png)

This allows Helpdesk staff to perform common tasks without full administrative rights, following the **principle of least privilege**.


## Future Improvements
- Implement Fine-Grained Password Policies (FGPP)
- Add service accounts with scoped permissions
- Centralize logging and auditing
- Expand OU structure to multiple branches
- Automate user onboarding with CSV-based PowerShell scripts

## Summary
This project demonstrates practical, security-conscious Active Directory administration skills aligned with real enterprise environments. It highlights both technical execution and administrative decision-making, supported by automation and clear documentation.