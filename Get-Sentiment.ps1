<#
.SYNOPSIS
    Get Sentiment in an input string
.DESCRIPTION
    This cmdlet utlizes Microsoft cognitive service's "Bing Search" API to know the sentiment of the string.
    NOTE : You need to subscribe the "Bing search API" before using the powershell script from the following link and setup an environment variable like, $env:MS_TextAnalytics_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-US/subscriptions
.PARAMETER Category
    Mention the NEWS category like - Sports, Politics or Entertainment
.PARAMETER HeadlinesOnly
    Choose this switch if you want only headlines to be returned.
.EXAMPLE
    PS Root\> Get-Sentiment -String "Hello Prateek, how are you?"
    
    String                      Positive % Negetive % OverallSentiment
    ------                      ---------- ---------- ----------------
    Hello Prateek, how are you? 93.37      6.63       Positive        
    
    In above example, I passed an string to cmdlet in order to get the Sentiment of the string.
.EXAMPLE
    PS Root\> "howdy","what the hell","damn" | Get-Sentiment
    
    String        Positive % Negetive % OverallSentiment
    ------        ---------- ---------- ----------------
    howdy         99.12      0.88       Positive        
    what the hell 23.91      76.09      Negitive        
    damn          0.80       99.20      Negitive
    
    You can also pass multiple strings as an argument through pipeline to the cmdlet to get the sentiment analysis
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Get-Sentiment
{
[CmdletBinding()]
Param(
		[Parameter(mandatory = $true,ValueFromPipeline=$True, position =0)]
		[String] $String

)

    Begin
    {
    }
    
    Process
    {
        Foreach($s in $String)
        {
                    
            Try
            {
               

                $Results = Invoke-RestMethod -Uri "https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/sentiment" `
                                                            -Method 'POST' `
                                                            -ContentType 'application/json' `
                                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_TextAnalytics_API_key } `
                                                            -Body (@{"documents" = [Object[]]@{"language"= "en"; "id"= "1";"text"= $s} } |ConvertTo-Json)`
                                                            -ErrorVariable E
                
                $sentiment = "{0:n2}" -f ($Results.documents.score  *100)

                '' | select @{n="String";e={$s}},@{n='Positive %';e={$sentiment}}, @{n='Negetive %';e={"{0:n2}" -f (100 - $sentiment)}},@{n='OverallSentiment';e={if($sentiment -gt 50){"Positive"}elseif($sentiment -eq 50){"Neutral"}else{"Negitive"}}}

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
