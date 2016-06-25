<#
.SYNOPSIS
    Get News from different categories
.DESCRIPTION
    This cmdlet returns NEWS items depending upon the catogoris you provide as a parameter, for which it employs Microsoft cognitive service's "Bing Search" API, by issuing an HTTP GET request to the API
    NOTE : You need to subscribe the "Bing search API" before using the powershell script from the following link and setup an environment variable like, $env:MS_BingSearch_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-US/subscriptions
.PARAMETER Category
    Mention the NEWS category like - Sports, Politics or Entertainment
.PARAMETER HeadlinesOnly
    Choose this switch if you want only headlines to be returned.
.EXAMPLE
PS C:\> Get-News -Category "sports" | sort publisheddate | select -First 1

    Topic         : Roger Federer ready to put ‘one stupid move’ behind him ahead of Wimbledon
    Description   : All it took was “one stupid move” for Roger Federer’s season to fall into an abyss. For much of his career, the seven-times Wimbledon champion had been blessed with 
                    a body that seemed bullet-proof against the aches, pains and injuries suffered by ...
    About         : {Roger Federer, Wimbledon}
    Category      : Sports
    NewsProvider  : The Indian Express
    Headline      : False
    PublishedDate : 6/25/2016 7:04:00 PM
    URL           : http://www.bing.com/cr?IG=1D675EE849BD47D1AA576531A6EA3C11&CID=1A99E3DE2CC1633C28A5EAE12DF062D5&rd=1&h=DuRuwfZJBY-ROSM8myTav-xQgxXZJ9IOT_gMMnqvH14&v=1&r=http%3a%2f%2f
                    indianexpress.com%2farticle%2fsports%2ftennis%2froger-federer-ready-to-put-one-stupid-move-behind-him-ahead-of-wimbledon-2875960%2f&p=DevEx,5036.1  
    
    In above example, I queried  news under "Sports" category and sorted it according to published date to get the latest news.
.EXAMPLE

PS C:\> Get-News -HeadlinesOnly |select -First 2

    Topic         : Britain votes to leave EU, Cameron quits, markets rocked | Reuters
    Description   : LONDON Britain has voted to leave the European Union, forcing the resignation of Prime Minister David Cameron and dealing the biggest blow since World War Two to the 
                    European project of forging greater unity. Global stock markets plunged on Friday, and the ...
    About         : {David Cameron, European Union, United Kingdom}
    Category      : World
    NewsProvider  : Firstpost
    Headline      : True
    PublishedDate : 6/25/2016 7:35:00 PM
    URL           : http://www.bing.com/cr?IG=F8C5A488A96B433DBF9A046AFB3142B2&CID=3F39C0A8A9366E090993C997A8076F98&rd=1&h=NYvnARoK615NZ0lqaYQz7CjbV0s106KMwXW18HUM_Zk&v=1&r=http%3a%2f%2f
                    www.firstpost.com%2ffwire%2fbritain-votes-to-leave-eu-cameron-quits-markets-rocked-reuters-2855004.html&p=DevEx,5030.1
    
    Topic         : At Least 14 Killed In Hotel Attack In Somalia's Capital
    Description   : Mogadishu, Somalia: At least 14 people were killed when gunmen stormed a hotel in Somalia's seaside capital and took an unknown number of hotel guests hostage, 
                    police and medical workers said on Saturday, before security forces hunted down the attackers ...
    About         : {Somalia, Capital}
    Category      : World
    NewsProvider  : NDTV
    Headline      : True
    PublishedDate : 6/25/2016 7:31:00 PM
    URL           : http://www.bing.com/cr?IG=F8C5A488A96B433DBF9A046AFB3142B2&CID=3F39C0A8A9366E090993C997A8076F98&rd=1&h=UcoWWIEPchWv0x5FAJQh7e4DlnAkmcYm2tYoLXgHWgM&v=1&r=http%3a%2f%2f
                    www.ndtv.com%2fworld-news%2fat-least-14-killed-in-hotel-attack-in-somalias-capital-1423439&p=DevEx,5035.1
    
    You can choose '-HeadlinesOnly' switch to only get the NEWS in headlines under all categories.
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Get-News
{
[CmdletBinding()]
Param(
        #[Parameter(ValueFromPipeline=$True)]
		#[String] $Path,
		[Parameter(ValueFromPipeline=$True, position =0)]
		[String] $Category,
        [Switch] $HeadlinesOnly

)

    Begin
    {
    }
    
    Process
    {
        Foreach($C in $Category)
        {
                    
            Try
            {
               
                $Result = Invoke-RestMethod -Uri "https://api.cognitive.microsoft.com/bing/v5.0/news/?Category=$C" `
                                            -Method 'GET' `
                                            -ContentType 'application/json' `
                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_BingSearch_API_key } `
                                            -ErrorVariable E

                Write-Verbose "Total of $($Result.webPages.totalEstimatedMatches) keyword matches."

                $news = $Result.value | select @{n="Topic";e={$_.name}},@{n='Description';e={$_.Description}}, @{n='About';e={$_.about.name}},@{n='Category';e={$_.category}}, @{n='NewsProvider';e={$_.provider.name}}, @{n='Headline';e={if($_.headline){$True}else{$false}}},@{n='PublishedDate';e={[datetime]$_.datePublished}} ,@{n='URL';e={$_.url}}

                If($HeadlinesOnly)
                {
                    $news | ?{$_.headline -eq "true"}                   
                }
                else
                {
                    $news
                }

            }
            Catch
            {
                $error = ($E.errorrecord.ErrorDetails.Message | ConvertFrom-Json).errors
                $error.parameter+": "+$error.Message
            }
        }
    }

    End
    {
    }
}
