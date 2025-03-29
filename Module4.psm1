function Get-AdminUsers {
    Get-LocalGroupMember -Group "Administradores" | 
    Select-Object Name, 
        @{Name="Origen de la cuenta"; Expression={$_.PrincipalSource}} | 
    Format-Table -AutoSize
}

function Get-InactiveUsers {
    $DaysInactive=90  #You can change the days
    Get-LocalUser|ForEach-Object { #Loop to iterate for each user
        $LastLogon=if ($_.LastLogon) { $_.LastLogon } else { [DateTime]::MinValue }
        if ((Get-Date) - $LastLogon -gt (New-TimeSpan -Days $DaysInactive)) {
            $_ | Select-Object Name, LastLogon
        }
    }
}