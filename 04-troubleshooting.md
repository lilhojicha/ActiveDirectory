![picture](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/banner2.png)


# Troubleshooting 

## Drive Mapping

I had an issue where my drive mapping logon script wasn't working even after creating an "Accounting" folder that I wanted to share.

I looked at the error message saying the network path was not found which is supposed to be $SharePath = "\\DC-1\Accounting"

I first confirmed that the path didn't exist which means the folder was not shared.
I then looked at the properties of the Accounting folder and confirmed the it was not shared. After sharing the folder, I ran the script again and it successfully executed and mapped the drive.

## User Creation

I was trying to create new users, security groups, and then assign them through a powershell script 

```PowerShell
$path = "DC=mydomain,DC=com"
$groupsOU = "OU=_Groups,DC=mydomain,DC=com"
$ou = "OU=Users,OU=Los_Angeles_CA,OU=_Branches,DC=mydomain,DC=com"

New-ADUser -Name "Alice Johnson" -GivenName Alice -Surname Johnson -SamAccountName ajohnson -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "John Davidson" -GivenName John -Surname Davidson -SamAccountName jdavidson -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "Bob Martinez" -GivenName Bob -Surname Martinez -SamAccountName bmartinez -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true

New-ADUser -Name "Chris Walker" -GivenName Chris -Surname Walker -SamAccountName cwalker -Path $ou -AccountPassword (Read-Host -AsSecureString) -Enabled $true


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
```
And had some issues where I didn't have permission to create the users -> run powershell admin
and then the password not meeting the length, complexity, or history requirement -> went to group policy and reviewed the password policy reran the script but the first user was already created with the account being disabled -> tried to uncheck the disabled option but I didn't change the password -> changed the password -> uncheck the disabled option