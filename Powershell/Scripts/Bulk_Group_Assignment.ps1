## Creates variable and imports csv
$list = Import-CSV -Path "C:\Path\To\CSV"

foreach ($user in $list) {
    $Username = $user.Username
    $Group = $user.GroupName
    
    Add-ADGroupMember -Identity $Group -Members $Username
    Write-Host "$Username has been added to $Group."
}