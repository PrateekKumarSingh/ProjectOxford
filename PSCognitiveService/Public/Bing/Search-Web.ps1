<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Text
Parameter description

.PARAMETER Count
Parameter description

.PARAMETER OffSet
Parameter description

.PARAMETER Market
Parameter description

.PARAMETER SafeSearch
Parameter description

.PARAMETER Image
Parameter description

.PARAMETER News
Parameter description

.EXAMPLE
Before using the 'Web-Search' cmdlet make sure you have created the a Cognitive Service account for 'Bing.Search.v7' on Azure. Unless you have the Cognitive Service account on Azure and configured it locally on machine using the 'New-LocalConfiguration' cmdlet the Web search will not work.

New-CognitiveServiceAccount -AccountType Bing.Search.v7 -ResourceGroupName ResourceGroup1 -Location global -Verbose -SKUName F0

.EXAMPLE
An example

.EXAMPLE
An example

.EXAMPLE
An example

.NOTES
General notes
#>

Function Search-Web {
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
        [SafeSearch] $SafeSearch = [SafeSearch]::Moderate,
        [Switch] $News
    )

    begin {
    }
    process {
        $Object = @()
        if (Test-LocalConfiguration -ServiceName 'BingSearchv7') {           
            $Object = [BingSearchV7]::new($env:API_SubscriptionKey_BingSearchv7)
            $Object.Search($Text, $Count, $OffSet, $MarketCodes[$Market], $SafeSearch)     
        }
        Remove-Variable -Name Object
    }
    end {
    }

}

Export-ModuleMember -Function Search-Web -Alias Bing