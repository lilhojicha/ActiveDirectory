
![picture](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/banner3.png)

# Real-world Active Directory Responsibilities
## Domain Password Policy
Configured a domain-wide password policy using Group Policy.
![Password Policy](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/Password_policy.png)

## Drive Mapping
### Logon Script (SYSVOL)

Created a PowerShell logon script stored in SYSVOL, ensuring availability to all domain users.
  
``` Powershell
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

    Write-Host `
        "Drive $DriveLetter mapped to $SharePath successfully." `
        -ForegroundColor Green
} else {
    Write-Host `
        "Drive $DriveLetter is already mapped to $($existingDrive.Root)" `
        -ForegroundColor Yellow
}

```
![map_drives](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/map_drives.png)

### Group Policy Preference (Recommended)
Also implemented drive mapping using Group Policy Preferences to improve reliability and troubleshooting.
<img src="https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/mapped1.png" width="500">

<img src="https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/map_drives3.png" width="300">

<img src="https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/map_drives4.png" width="500">

Verified GPO application using gpupdate /force and confirmed mapped drive behavior after user logon

<img src="https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/map_drives5.png" width="500">



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

![Delegation1](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/delegation1.png)

![Delegation2](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/delegation2.png)

This allows Helpdesk staff to perform common tasks without full administrative rights, following the **principle of least privilege**.