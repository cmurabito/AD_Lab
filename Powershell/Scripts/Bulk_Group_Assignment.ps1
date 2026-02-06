## Creates variable and imports csv
$list = Import-CSV -Path "C:\Path\To\CSV"

foreach ($user in $list) {
    $Username = $user.Username
    $Group = $user.GroupName
    
    ## Performs a check to see if user is part of specified group
    $isUser = Get-ADGroupMember -Identity $Group -Recursive | Where-Object {$_.SamAccountName -eq $userSam}

    ## If the user is already in the group, the user is skipped. Otherwise, the user is added.
    if ($isUser) {
        Write-Host "$Username is already a member of $Group. Skipping..."
    }
    else {
        Add-ADGroupMember -Identity $Group -Members $Username
        Write-Host "$Username has been added to $Group."
    }
}
