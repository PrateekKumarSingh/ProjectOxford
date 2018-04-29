Function Search-Web {
    [alias("bing")]
    [cmdletbinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $Text
    )

    begin {
    }
    process {
        $Object = @()
        if (Test-LocalConfiguration -ServiceName 'BingSearchv7') {            
            $Object = [BingSearchV7]::new($env:API_SubscriptionKey_BingSearchv7)
            $Object.Search($Text)     
        }
        Remove-Variable -Name Object
    }
    end {
    }

}
