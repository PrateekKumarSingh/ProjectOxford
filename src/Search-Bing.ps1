<#
.SYNOPSIS
    Bing search based on query.
.DESCRIPTION
    This cmdlet returns Bing web search results Using Microsoft cognitive service's "Bing Search" API, by issuing an HTTP GET request to the API
    NOTE : You need to subscribe the "Bing search API" before using the powershell script from the following link and setup an environment variable like, $env:MS_BingSearch_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-US/subscriptions
.PARAMETER Query
    String you want to search on Bing
.PARAMETER Count
    Number of results you want Bing Search to return
.PARAMETER SafeSearch
    Safe search to avoid adult content to be returned from Bing search, default value is set to 'Moderate'
.EXAMPLE
    PS C:\> Search-Bing -Query "Bill Gates" -Count 2

    Query           : Bill Gates
    Result          : Bill Gates - Wikipedia, the free encyclopedia
    URL             : https://en.wikipedia.org/wiki/Bill_Gates
    Snippet         : William Henry "Bill" Gates III (born October 28, 1955) is an American business magnate, entrepreneur, philanthropist, investor, and programmer. In 1975, Gates and 
                      Paul Allen co-founded Microsoft, which became the world's largest PC software company.
    DateLastCrawled : 2016-06-24
    
    Query           : Bill Gates
    Result          : Bill Gates - Biography.com
    URL             : www.biography.com/people/bill-gates-9307520
    Snippet         : Biography.com tracks the life and career of Bill Gates, from his early interest in computer programming to his place as founder of Microsoft, the world's largest 
                      software business.
    DateLastCrawled : 2016-06-20

    
    In above example, I ran a bing search on "Bill gates" and chose to return only 2 matching results values.
.EXAMPLE
    PS C:\> Search-Bing -Query "Bill Gates" -Count 1 -SafeSearch Strict

    Query           : Bill Gates
    Result          : Bill Gates - Wikipedia, the free encyclopedia
    URL             : https://en.wikipedia.org/wiki/Bill_Gates
    Snippet         : William Henry "Bill" Gates III (born October 28, 1955) is an American business magnate, entrepreneur, philanthropist, investor, and programmer. In 1975, Gates and 
                      Paul Allen co-founded Microsoft, which became the world's largest PC software company.
    DateLastCrawled : 2016-06-24

    You can choose different modes (Strict, Moderate, Off) in '-SafeSearch' to make sure no adult content is returned from the Bing Search
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Search-Bing
{
[CmdletBinding()]
Param(
        #[Parameter(ValueFromPipeline=$True)]
		#[String] $Path,
		[Parameter(ValueFromPipeline=$True, position =0, mandatory=$true )]
		[String] $Query,
        [Parameter(position =1)]
        [int] $Count = 10,
        [Validateset('Strict', 'Moderate', 'Off')][String] $SafeSearch = 'Moderate'
)

    Begin
    {
    }
    
    Process
    {
        Foreach($Q in $Query)
        {
            $Item = ($Q.trim()).Replace(' ','+')
                    
            Try
            {
                $Result = Invoke-RestMethod -Uri "https://api.cognitive.microsoft.com/bing/v5.0/search?q=$Item&count=$Count&SafeSearch=$SafeSearch" `
                                            -Method 'GET' `
                                            -ContentType 'application/json' `
                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_BingSearch_API_key } `
                                            -ErrorVariable E `

                Write-Verbose "Total of $($Result.webPages.totalEstimatedMatches) keyword matches."

                $Result.webPages.value | select @{n="Query";e={$q}},@{n='Result';e={$_.name}}, @{n='URL';e={$_.displayURL}}, @{n='Snippet';e={$_.snippet}}, @{n='DateLastCrawled';e={($_.dateLastCrawled).split('T')[0]}}

            }
            Catch
            {
                "Something went wrong While extracting Text from Image, please try running the script again`nError Message : "+$E.Message
            }
        }
    }

    End
    {
    }
}
