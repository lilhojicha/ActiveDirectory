# Script that creates Branches with users, workstations, and laptops
# OU_Branches
#         └── Las_Vegas
#             ├── Users
#             ├── Workstations
#             └── Laptops

$path = "OU=OU_Branches,DC=mydomain,DC=com"
$sub_ou = "Users", "Workstations", "Laptops"

# here are the 20 most populous cities
$locations = "San_Diego_CA", "Los_Angeles_CA", "New_York_NY", "Boston_MA", "Chicago_IL", "Houston_TX", "Phoenix_AZ", "Philadelphia_PA", "San_Antonio_TX", "Dallas_TX", "Jacksonville_FL", "Fort_Worth_TX", "San_Jose_CA", "Austin_TX", "Charlotte_NC", "Columbus_OH", "Indianapolis_IN", "San_Francisco_CA", "Seattle_WA", "Denver_CO", "Oklahoma_City_OK"


foreach($n in $locations){
    
    # Creating the location branch
    New-ADOrganizationalUnit -Name $n -ProtectedFromAccidentalDeletion $False -Path $path

    # Creating the sub OUs for the branches
    foreach ($ou in $sub_ou) {
        New-ADOrganizationalUnit    -Name $ou`
                                    -ProtectedFromAccidentalDeletion $False`
                                    -Path "OU=$n,$path"
    }
}