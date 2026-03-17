# ActiveDirectory
This active directory homelab is to understand the fundamentals in Active Directory, networking, and IT by promoteing a server to a domain controller, build a basic Active Driectory structure, create users and groups, and test authentictaion using both GUI and Powershell


 
## What I have learned
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


## Network Topology Map
![Screenshot 1]


## Environments Used and Links to Download

- [Windows 10](https://www.microsoft.com/en-us/software-download/windows10ISO) (21H2)
- [Downloads – Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Windows Server 2019 | Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019)

### Installed Roles and Features
## Active Directory Domain Services was installed because this is the ...
## Promoted the Server to a Domain Controller and created my first Active Directory domain called "mydomain"
    This is the point where Active Directory actually becomes active.
## Created Organizational Units (OU) that mirrors how Active Directory is commonly structured in production enviroments by creating location-based OUs.
- OUs are designed around **policy and delegation boundaries** thus, creating location-based OUs
- The structure looks like this 
```
_Branches
 └── Las_Vegas
     ├── Users
     ├── Workstations
     └── Laptops
```
## Created Users
Here I have created domain user accounts and placed them into the appropriate branch-based Users OU

The users I have created are
- John Davidson (ajohnson)
- Alice johnson (jdavidson)
- Bob martinez (bmartinez)
- Chris walker (cwalker)

The PowerShell Equivalent is 

```
$ou = "OU=Users,OU=Las_Vegas,OU=_Branches,DC=mydomain"

New-ADUser -Name "Alice Johnson" -GivenName Alice -Surname Johnson -SamAccountName ajohnson -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "John Davidson" -GivenName John -Surname Davidson -SamAccountName jdavidson -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "Bob Martinez" -GivenName Bob -Surname Martinez -SamAccountName bmartinez -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "Chris Walker" -GivenName Chris -Surname Walker -SamAccountName cwalker -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true
```
The PowerShell script to add 1000 users


**Important Notes**
- Users should always be placed in the correct branch OU
- Access is granted through group membership, not OU placement
- Password and lockout policies are engorced with Group Policy

## Created Security Groups

Security Groups that were created users that were assigned
- HR - John Davidson
- Helpdesk - Alice johnson
- Accounting - Bob martinez
- ITSupport - Chris walker

Unlike users and computers, groups are typically stored in a centralized location rather than inside branch OUs and in this case we stored the groups in the _Groups OU 
```
_Groups
 ├── Helpdesk
 ├── ITSupport
 ├── HR
 └── Accounting
```
These groups are global security groups to represent roles or departments within the domain


The PowerShell Equivalent
```
$groupsOU = "OU=_Groups,DC=mydomain"

New-ADGroup -Name "Helpdesk" -GroupScope Global -GroupCategory Security -Path $groupsOU
New-ADGroup -Name "ITSupport" -GroupScope Global -GroupCategory Security -Path $groupsOU
New-ADGroup -Name "HR" -GroupScope Global -GroupCategory Security -Path $groupsOU
New-ADGroup -Name "Accounting" -GroupScope Global -GroupCategory Security -Path $groupsOU

Add-ADGroupMember -Identity "Helpdesk" -Members ajohnson
Add-ADGroupMember -Identity "ITSupport" -Members cwalker
Add-ADGroupMember -Identity "HR" -Members jdavidson
Add-ADGroupMember -Identity "Accounting" -Members bmartinez
```

**Important Notes**
- Users never get permissions assigned directly. They acquire access through their roles
- Groups are typically centralized, not branch-based














<h2>Program walk-through:</h2>

<p align="center">
After you have installed everything, set up oracle virtual box and click on new <br/>
<img src="https://i.imgur.com/Ismg0R4.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
In the areas that I have highlighted below, go ahead and fill them out.
For the VM name, since this will be your server, just call it Domain Controller.
For the ISO image, make sure you locate that ISO image you saved for the 2019 server and select it.
and uncheck the 'Proceed with Unattended Installation'
Everything else you can leave and just click next and finish  <br/>
<img src="https://i.imgur.com/uYU6ozu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
We will then go to settings and set some features: <br/>
<img src="https://i.imgur.com/IYUAkxq.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
 <img src="https://i.imgur.com/wep6tf7.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
Keep the Adapter 1 to what it has and add an Adapter 2 and set it to 'Internal Network'. This is because you want a NIC for your internal network where your clients are going to communicate. This is the corporate network you are simulating.
If I don't have screenshots for certain window/page, just continue. <br/>
<img src="https://i.imgur.com/z8jDVIb.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
 <img src="https://i.imgur.com/h6mLZuq.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
 <img src="https://i.imgur.com/BPGMJ2B.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
Input 'Password1'. For security, it's not the best, but since it's just a homelab, it'll be easier to have something simple. Then log into that account.   <br/>
<img src="https://i.imgur.com/3pjRtgH.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
Go to the top of the window, at the Devices tab and click on 'Insert Guest Additions CD image...'. This will help the VM to be less laggy and you would be able to resize the window.:  <br/>
<img src="https://i.imgur.com/oRd6nOZ.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
Go to file explorer and click on 'This PC' -> 'CD Drive (D:) VirtualBox Guest Addtions' folder -> and open the 'VBoxWindowsAdditions-amd64'  <br/>
<img src="https://i.imgur.com/YVH8HTu.png" height="80%" width="80%" alt="Setting Up Your Environments"/>
 <br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
#1 right click either one of the Ethernet options and select 'Status'. You will then get to the #2 window and click on 'Details'. Check the Autoconfiguration IPv4 and find the one with the 169.254.xxx.x. This one is your internal network. Go ahead and rename that network as INTERNAL_NETWORK and the other one as INTERNET: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
 Go ahead and just click next until you get to the completing screen and choose to manually reboot later: <br/>
<img src="https://i.imgur.com/7vuwBXu.png" height="80%" width="80%" alt="Setting Up Your Environment"/>
<br />
<br />
</p>

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
