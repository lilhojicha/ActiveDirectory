# Powershell script to read text file of names and create AD users

# stores each line to an array of newline-delimited strings
$names = Get-Content -Path .\names.txt
# assign everyone with the same password
$password = ConvertTo-SecureString "Password1" -AsPlainText -Force
# create the OU to store the users
New-ADOrganizationalUnit -Name _USERS -ProtectedFromAccidentalDeletion $false

foreach ($n in $names) {
    # separate first and last name by space delimiter
    $first_name = $n.split(" ")[0].ToLower()
    $last_name = $n.split(" ")[1].ToLower()
    $acc_name = $first_name[0] + $last_name

    Write-Host "Creating user: $acc_name" -BackgroundColor Black -ForegroundColor Cyan

    # create new ADUser
    New-ADUser  -Name $n `
                -GivenName $first_name `
                -Surname $last_name `
                -SamAccountName $acc_name `
                -Path "ou=_USERS,$(([ADSI]`"").distinguishedName)" `
                -AccountPassword $password `
                -Enabled $true
            
}
