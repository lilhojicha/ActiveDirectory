![banner](screenshots/banner2.png)


# Troubleshooting & Validation

## Overview
This document captures real issues encountered during the Active Directory 
home lab build. Each entry includes the symptom, investigation process, 
root cause, and resolution — mirroring how issues are documented in 
real IT environments.

---

## Issue #1: Drive Mapping Script Failing — Network Path Not Found

### Symptom
Logon script failed to map the Accounting shared drive. PowerShell returned:

![No network path for drive](screenshots/04-troubleshooting/nonetworkpath.png)

### Investigation
- Attempted to manually navigate to `\\DC-1\Accounting` from the client — path 
  did not resolve
- Opened **File Explorer → Properties** on the Accounting folder on DC-1
- Confirmed the folder existed locally but had **no share configured**

### Root Cause
The folder was created on the Domain Controller but was never shared over 
the network. The script referenced a UNC path (`\\DC-1\Accounting`) that 
did not yet exist as a network share.

### Resolution
1. Right-clicked the Accounting folder → **Properties → Sharing tab**
2. Selected **Share** and added the appropriate security group with 
   correct permissions
3. Re-ran the logon script — drive mapped successfully

### Lesson Learned
Creating a folder locally does not automatically make it a network share. 
UNC paths require the share to be explicitly configured. In production, 
this would be caught by validating share existence before deploying 
logon scripts.

---

## Issue #2: HR User Could See Mapped Drive But Had No Write Access

### Symptom
After mapping a drive to HR users via Group Policy Preferences (GPP) and 
setting NTFS permissions to grant the HR security group Full Control on 
the HR folder, one HR member could see the drive but could not create 
files or folders inside it.

### Investigation
- Confirmed the HR folder NTFS permissions showed HR → Full Control 
- Noticed the HR folder had a **parent folder** that was not shared
- Checked parent folder NTFS permissions: `Everyone → Read` only
- Added HR group to the parent folder with **Read & List** permissions
- Tested again — issue persisted

### Root Cause
NTFS permissions on the HR folder were correct, but the **Share permissions 
on the HR folder itself** were set to `Everyone → Read`. Share permissions 
and NTFS permissions both apply, and Windows enforces whichever is **more 
restrictive** — in this case, the Share permissions were overriding the 
NTFS Full Control grant.

### Resolution
1. Opened the HR folder → **Properties → Sharing → Advanced Sharing → 
   Permissions**
2. Removed `Everyone → Read`
3. Added `HR Security Group → Full Control` at the Share permission level
4. HR member was then able to create files and folders successfully

### Lesson Learned
Both Share permissions and NTFS permissions must be configured correctly — 
they are not interchangeable. Best practice in enterprise environments is 
to set Share permissions to `Everyone → Full Control` and control access 
exclusively through NTFS permissions to avoid this conflict.

---

## Issue #3: Permissions (Run as Admin)

### Symptom
Running the user/group creation script returned an access denied error 
when attempting to create new AD users.

![Error Message](screenshots/04-troubleshooting/errormessage.png)

### Script Used
```PowerShell
$path = "DC=mydomain,DC=com"
$groupsOU = "OU=_Groups,DC=mydomain,DC=com"
$ou = "OU=Users,OU=Los_Angeles_CA,OU=_Branches,DC=mydomain,DC=com"

New-ADUser -Name "Alice Johnson" -GivenName Alice -Surname Johnson -SamAccountName ajohnson -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "John Davidson" -GivenName John -Surname Davidson -SamAccountName jdavidson -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "Bob Martinez" -GivenName Bob -Surname Martinez -SamAccountName bmartinez -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "Chris Walker" -GivenName Chris -Surname Walker -SamAccountName cwalker -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

```
The script halted, leaving `ajohnson` created in AD but in a 
**disabled state**.

### Investigation
- Navigated to **Group Policy Management → Default Domain Policy → 
  Password Policy**
- Reviewed the configured password requirements (minimum length, 
  complexity rules)
- Confirmed the password entered during `Read-Host` prompt did not meet 
  the policy

### Root Cause
The password entered at the prompt was too simple and did not satisfy the 
domain password policy enforced via GPO. The `New-ADUser` cmdlet created 
the account object but could not enable it without a compliant password, 
leaving it disabled.

### Resolution
1. Located `ajohnson` in **Active Directory Users and Computers (ADUC)**
2. Attempted to uncheck **Account is disabled** — failed because no 
   valid password was set
3. Right-clicked account → **Reset Password** → entered a policy-compliant 
   password
4. Unchecked **Account is disabled** → account activated successfully
5. Re-ran the remainder of the script for the remaining users with a 
   compliant password ready

### Lesson Learned
When using `Read-Host -AsSecureString` for password input in scripts, 
validate complexity requirements before running in a domain environment. 
A better practice is to define a compliant default password in the script 
for lab use, or implement a pre-check function that validates against 
the domain policy before account creation.

## Issue #4: Password complexity + disabled account recovery

### Symptoms
### Investigation
### Root Cause 
### Resolution
### Lesson Learned



---

## Final Lab Validation

| Validation Point | Method | Status |
|---|---|---|
| AD DS role running | Server Manager | ✅ |
| OUs created correctly | ADUC | ✅ |
| Users created and enabled | ADUC | ✅ |
| Security groups created and populated | ADUC → Group Members | ✅ |
| Drive mapping working for Accounting | Logon script test | ✅ |
| HR shared drive write access confirmed | File creation test on client | ✅ |
| GPP drive map visible to HR users | Client login verification | ✅ |

## Reflection
This lab reinforced that Windows permission issues are rarely single-layered — 
the Share/NTFS interaction in Issue #2 is a pattern I expect to encounter 
regularly in production environments. The PowerShell errors strengthened my 
understanding of AD account states and GPO enforcement timing. Next iteration 
of this lab will include automating password complexity validation before 
account creation and expanding the GPP drive mapping to additional departments.