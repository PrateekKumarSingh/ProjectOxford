Function Trace-Language {
    [alias("Lang")]
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
        if (Test-LocalConfiguration -ServiceName 'TextAnalytics') {            
            $Object = [TextAnalytics]::new($env:API_SubscriptionKey_TextAnalytics, $env:API_Location_TextAnalytics)
            $Object.detectLanguage($Text)     
        }
        Remove-Variable -Name Object
    }
    end {
    }

}

Export-ModuleMember -Function Trace-Language -Alias Lang
