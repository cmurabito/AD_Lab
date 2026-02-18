## Defines excluded users from script.
$excludedUsers = "Insert excluded users here."

## Gets users inactive for 90 days and exports to a csv
Get-ADUser -Filter {enabled -eq $true} -Properties name, samaccountname, Created, lastlogondate, enabled |
Where-Object {$_.lastLogonDate -lt (Get-Date).adddays(-90) -and $excludedUsers -notcontains $_.SamAccountName} |
Select-Object samaccountname,lastlogondate |
Export-Csv "C:\temp\Inactive_Accounts.csv"

## Imports that same csv
$Inactive = Import-Csv -path "C:\temp\Inactive_Accounts.csv"

## Iterates through users in csv
forEach ($user in $Inactive) {
    
    ## Defines variable AccountName
    $AccountName = $user.samaccountname

    ## Prompts user for input and prompts again if they enter something invalid.
    $Choice = Read-Host -Prompt "Would you like to disable $AccountName? Type 'Y' for yes, or 'N' to skip."
    while ($Choice -notmatch "^[YN]$"){
        $Choice = Read-Host "Entry invalid. Please type 'Y' or 'N'."
    }

    ## If user types 'Y', then account is disabled, if user types 'N', on to the next account.
    switch ($Choice) {
        {$_ -match 'Y'} {
            Disable-ADAccount -Identity $AccountName -verbose
            Write-Host "$AccountName disabled."
        }
        {$_ -match 'N'} {Write-Host "Skipping..."}
        default {"Error! Exiting Script."}
    }
}