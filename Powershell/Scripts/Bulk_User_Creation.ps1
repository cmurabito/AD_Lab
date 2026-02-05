## Creates a variable named users from csv file
$users = Import-Csv -Path "C:\Path\To\YourFile.csv"

## Iterates through csv file and assigns variables
foreach ($user in  $users) {
    $displayname = $user.FirstName + " " + $user.LastName
    $firstname = $user.FirstName
    $surname = $user.LastName
    $samaccount = $user.Username
    $upn = $user.Username + "@Lab.local"
    $OU = $user.OU
    $password = "insertpasshere"
    
## Defines username checking variable
    $usercheck = Get-ADUser -Filter "SamAccountName -eq '$samaccount'"

    ## Checks if user account is already in database. If not, creates account.
    if ($null -ne $usercheck) {
        New-ADUser -Name "$displayname" -DisplayName "$displayname" -SamAccountName $samaccount -UserPrincipalName $upn -GivenName "$firstname" -Surname "$surname" -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled $true -Path $OU -ChangePasswordAtLogon $true -server Lab.local
        Write-Host "$samaccount successfully added to user database."
    } else {
        Write-Host "$samaccount already exists in user database."
    }
    
}

