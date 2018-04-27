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
        if (Test-LocalConfiguration -ServiceName 'Bing_Search_v7') {            
            $Object = [Bing]::new($env:API_SubscriptionKey_Bing_Search_v7, $env:API_Location_Bing_Search_v7)
            $Object.Search($Text)     
        }
        Remove-Variable -Name Object
    }
    end {
    }

}
