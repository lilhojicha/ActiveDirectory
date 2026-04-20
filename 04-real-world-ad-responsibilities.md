
![picture](/screenshots/banner3.png)

# Real-world Active Directory Responsibilities
## Drive Mapping
### Logon Script (SYSVOL)

Created a PowerShell logon script stored in SYSVOL, ensuring availability to all domain users.
  
**Note:**
You must create the folder you want to share first and go to Properties to share the folder in order to create the share path of the folder

``` Powershell
$DriveLetter = "H"
$SharePath = "\\DC-1\DeptShare"
$existingDrive = Get-PSDrive -Name $DriveLetter -ErrorAction SilentlyContinue


# Check if drive exists
if (!$existingDrive) {
    New-PSDrive `
        -Name $DriveLetter `
        -PSProvider FileSystem `
        -Root $SharePath `
        -Persist

    Write-Host `
        "Drive $DriveLetter mapped to $SharePath successfully." `
        -ForegroundColor Green
} else {
    Write-Host `
        "Drive $DriveLetter is already mapped to $($existingDrive.Root)" `
        -ForegroundColor Yellow
}

```
![map_drives](/screenshots/05-extra/drivemapscript.png)

### Group Policy Preference
Also implemented drive mapping using Group Policy Preferences to improve reliability and troubleshooting because GPP can be configured to apply drive mappings asynchronously, meaning it'll persist across reboots and it runs after logon. Plus logon scripts are considered legacy. 


![map_drives](screenshots/05-extra/creategpo.png)

![map_drives](screenshots/05-extra/mapdrives3.png)

![map_drives](screenshots/05-extra/map_drives4.png)

Verified GPO application using gpupdate /force and confirmed mapped drive behavior after user logon

![map_drives](screenshots/05-extra/confirmdrivesharegpo.png)

## File Share Security (NTFS vs Share Permissions)

- Share permissions were kept permissive
- NTFS permissions enforced access control

**Why**

- NTFS permissions are granular
- Support inheritance
- Apply locally and over the network
- Align with enterprise security best practices

## Delegated Password Reset Permissions to Helpdesk

Delegated password reset permissions to the Helpdesk group using the Delegation of Control Wizard.

![Delegation1](/screenshots/05-extra/delegation1.png)

![Delegation2](/screenshots/05-extra/delegation2.png)

This allows Helpdesk staff to perform common tasks without full administrative rights, following the **principle of least privilege**.