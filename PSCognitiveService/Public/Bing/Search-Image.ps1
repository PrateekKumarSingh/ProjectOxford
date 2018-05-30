Function Search-Image {
    [alias("bing")]
    [cmdletbinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [System.String] $Text,
        [Int] $Count = 10,
        [Int] $OffSet = 0,
        [ValidateSet(
            'Spanish-Latin America','French-Canada','Croatian-Croatia','Swedish-Sweden','Danish-Denmark',
            'Bulgarian-Bulgaria','Russian-Russia','English-New Zealand','Ukrainian-Ukraine','Spanish-Mexico',
            'English-South Africa','Hungarian-Hungary','Turkish-Turkey','Latvian-Latvia','English-Australia',
            'Slovak-Slovak Republic','French-Switzerland','Italian-Italy','English-Malaysia','French-Belgium',
            'English-United Kingdom','Portuguese-Brazil','Estonian-Estonia','English-Canada','Chinese-Hong Kong SAR',
            'Dutch-Netherlands','Spanish-United States','Norwegian-Norway','Chinese-China','Korean-Korea',
            'Romanian-Romania','German-Austria','Lithuanian-Lithuania','Czech-Czech Republic','English-Ireland',
            'English-India','English-Arabia','Hebrew-Israel','Spanish-Spain','English-Indonesia',
            'German-Germany','Portuguese-Portugal','Spanish-Chile','Slovenian-Slovenia','English-United States',
            'Greek-Greece','English-Singapore','English-Philippines','Spanish-Argentina','Finnish-Finland',
            'Chinese-Taiwan','Dutch-Belgium','French-France','German-Switzerland','Polish-Poland',
            'Arabic-Arabia','Thai-Thailand','Japanese-Japan'
        )]
        [String] $Market = 'English-United States' ,
        [SafeSearch] $SafeSearch = [SafeSearch]::Moderate
    )

    begin {
    }
    process {
        $Object = @()
        if (Test-LocalConfiguration -ServiceName 'BingSearchv7') {
            $Object = [BingImageSearch]::new($env:API_SubscriptionKey_BingSearchv7)
            $Object.Search($Text, $Count, $OffSet, $MarketCodes[$Market], $SafeSearch)     
        }
        Remove-Variable -Name Object
    }
    end {
    }

}

Export-ModuleMember -Function Search-Image -Alias Bing
