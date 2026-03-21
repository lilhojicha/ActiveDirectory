# ActiveDirectory
This active directory homelab is to understand the fundamentals in Active Directory, networking, and IT by promoteing a server to a domain controller, build a basic Active Driectory structure, create users and groups, and test authentictaion using both GUI and Powershell


 
## What I have learned 📝
- Deploying a Windows Server VM in Oracle
- Installing Active Directory Domain Services (AD DS)
- Promoting a server to a domain controller
- Designing a simple, logical OU structure
- Creating and manage users and security groups
- Understanding how group membership controls access
- Authenticating users from a Windows client
- Performing common AD tasks via GUI and Powershell
- Troubleshooting basic Active Directory issues

## Technologies and Components Used:
-	Windows Server 2019
-	Windows 10 Pro
-	Oracle VirtualBox
-	Active Directory
-	Active Directory Domain Service
-	Network Address Translation (NAT)
-	Domain Name Service (DNS)
-	Dynamic Host Configuration Protocol (DHCP)
-	File and Storage Services
-	Internet Information Services (IIS)
-	PowerShell


## Network Topology Map 🌐
![Network Topology](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/network_Topology.png)


## Environments Used and Links to Download

- [Windows 10](https://www.microsoft.com/en-us/software-download/windows10ISO) (21H2)
- [Downloads – Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Windows Server 2019 | Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019)

## Windows Server 2019 and Active Directory 🪟
Installed Roles and Features
![AD roles and features](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/Roles_and_features.png)

Active Directory Domain Services was installed because this is the ...

### Promoted the Server to a DC
Promoted the Server to a Domain Controller and created my first Active Directory domain called "mydomain"
This is the point where Active Directory actually becomes active.

### Created Organizational Units (OU) that mirrors how Active Directory is commonly structured in production enviroments by creating location-based OUs.
- OUs are designed around **policy and delegation boundaries** thus, creating location-based OUs
- The structure looks like this 

    OU_Branches
    └── Las_Vegas
        ├── Users
        ├── Workstations
        └── Laptops


![OU_Branches](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/OU_Branches.png)

### Created Users
Here I have created domain user accounts and placed them into the appropriate branch-based Users OU

The users I have created are
- John Davidson (ajohnson)
- Alice johnson (jdavidson)
- Bob martinez (bmartinez)
- Chris walker (cwalker)

![Users](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/Users.png)

The PowerShell Equivalent is 

``` PowerShell
$ou = "OU=Users,OU=Las_Vegas,OU=OU_Branches,DC=mydomain,DC=com"

New-ADUser -Name "Alice Johnson" -GivenName Alice -Surname Johnson -SamAccountName ajohnson -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "John Davidson" -GivenName John -Surname Davidson -SamAccountName jdavidson -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "Bob Martinez" -GivenName Bob -Surname Martinez -SamAccountName bmartinez -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "Chris Walker" -GivenName Chris -Surname Walker -SamAccountName cwalker -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true
```

**‼️Important Notes‼️**
- Users should always be placed in the correct branch OU
- Access is granted through group membership, not OU placement
- Password and lockout policies are engorced with Group Policy

### Created Security Groups

Security Groups that were created and users that were assigned
- HR - John Davidson
- Helpdesk - Alice johnson
- Accounting - Bob martinez
- ITSupport - Chris walker

![Security_groups](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/Security_groups.png)

Unlike users and computers, groups are typically stored in a centralized location rather than inside branch OUs and in this case we stored the groups in the _Groups OU 

    _Groups
    ├── Helpdesk
    ├── ITSupport
    ├── HR
    └── Accounting

These groups are global security groups to represent roles or departments within the domain


The PowerShell Equivalent

``` PowerShell
$groupsOU = "OU=OU_Groups,DC=mydomain,DC=com"

New-ADGroup -Name "Helpdesk" -GroupScope Global -GroupCategory Security -Path $groupsOU
New-ADGroup -Name "ITSupport" -GroupScope Global -GroupCategory Security -Path $groupsOU
New-ADGroup -Name "HR" -GroupScope Global -GroupCategory Security -Path $groupsOU
New-ADGroup -Name "Accounting" -GroupScope Global -GroupCategory Security -Path $groupsOU

Add-ADGroupMember -Identity "Helpdesk" -Members ajohnson
Add-ADGroupMember -Identity "ITSupport" -Members cwalker
Add-ADGroupMember -Identity "HR" -Members jdavidson
Add-ADGroupMember -Identity "Accounting" -Members bmartinez
```

**‼️Important Notes‼️**
- Users almost never get permissions assigned directly. They acquire access through their roles by being placed in a group, and groups are granted access to resources.
- Groups are typically centralized, not branch-based

### Created a Windows Client VM and Joined the Domain

I have also moved it to the correct branch OU

![client_computer](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/client_computer.png)

**‼️Important Notes‼️**
- Client must use the domain controller for DNS resolution
- Active Directory relies entirely on DNS to locate domain controllers. Incorrect DNS is the most common cause of domain join failures.
- So you have to set the DNS to the domain controller's private IP 

I then verified that Active Directory is working correctly by logging into the client as a domain user
    A successful domain login proves that the client can locate a domain controller, authenticate the user, build a security token, and apply group membership

## Real-world Active Directory Responsibilities
### 1. Configured Password Policy (Domain-Wide)

![Password Policy](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/Password_policy.png)

## 2. Created a Basic Logon Script

I have created two logon scripts that represent the real world.
It uses SYSVOL which is a special folder on every domain controller that stores files which must be accessible to all domain users and when the user logs in, their computer automatically pulls scripts and policies from SYSVOL

### Drive Mapping

Before writing a script, it's important to create a shared folder to then map a drive to that folder where your domain users can access

Here, I have created a shared folder called DeptShare where I have shared the folder permissions to add Domain Users -> Read and set NTFS permissions to let the group Accounting to have Modify and Read permissions.

    1. Drive Mapping Script
``` Powershell
# Map-Drives.ps1
$DriveLetter = "H"
$SharePath = "\\DC\DeptShare"
$LogFile = "$env:USERPROFILE\logon_log.txt"


# Check if drive exists
if (!(Get-PSDrive -Name $DriveLetter -ErrorAction SilentlyContinue)) {
New-PSDrive -Name $DriveLetter -PSProvider FileSystem -Root $SharePath -Persist

Add-Content -Path $LogFile -Value "$(Get-Date) - Mapped $DriveLetter to $SharePath"
} else {
Add-Content -Path $LogFile -Value "$(Get-Date) - $DriveLetter already mapped"
}

```

    2. User Environment Prep Script
``` Powershell
# Create folders
$Folders = @("Documents\Projects", "Documents\Tickets", "Desktop\Tools")
foreach ($f in $Folders) {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\$f" -Force
}

# Create a desktop shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Support Portal.lnk")
$Shortcut.TargetPath = "https://intranet/helpdesk"
$Shortcut.Save()

# Log
Add-Content "$env:USERPROFILE\logon_log.txt" "$(Get-Date) - Environment prepared"

```

3. Delegated Password Reset Permissions to Helpdesk

![Delegation2](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/delegation1.png)

![Delegation1](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/delegation2.png)



<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
