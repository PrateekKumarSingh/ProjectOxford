Function Search-Entity {
    [alias("Entity")]
    [cmdletbinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [System.String] $Text,
        [Int] $Count = 10,
        [Int] $OffSet = 0,
        [SafeSearch] $SafeSearch = [SafeSearch]::Moderate
    )

    begin {
    }
    process {
        $Object = @()
        if (Test-LocalConfiguration -ServiceName 'BingEntitySearch') {
            $Object = [BingEntitySearch]::new($env:API_SubscriptionKey_BingEntitySearch)
            $Object.Search($Text, $Count, $OffSet, 'en-US', $SafeSearch)     
        }
        Remove-Variable -Name Object
    }
    end {
    }

}

Export-ModuleMember -Function Search-Entity -Alias Entity
