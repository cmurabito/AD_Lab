## Creates a variable named users from csv file
$users = Import-Csv -Path "C:\Path\To\YourFile.csv"

## Iterates through csv file and assigns variables/creates users
foreach ($user in  $users) {
    $displayname = $user.FirstName + " " + $user.LastName
    $firstname = $user.FirstName
    $surname = $user.LastName
    $samaccount = $user.Username
    $upn = $user.Username + "@Lab.local"
    $OU = $user.OU
    $password = "insertpasshere"
    New-ADUser -Name "$displayname" -DisplayName "$displayname" -SamAccountName $samaccount -UserPrincipalName $upn -GivenName "$firstname" -Surname "$surname" -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled $true -Path "$OU" -ChangePasswordAtLogon $true -server Lab.local
}