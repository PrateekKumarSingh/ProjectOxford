<#
.SYNOPSIS
    Recognize Key phrases in a given text or string.
.DESCRIPTION
    Identifies Key phrases in a given text/string using Microsoft cognitive service's "Text Analytics" API.
    NOTE : You need to subscribe the "Text Analytics API." before using the powershell script from the following link and setup an environment variable like, $env:MS_TextAnalytics_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-US/subscriptions
.PARAMETER String
    String to search for named entities.
.EXAMPLE
    PS C:\> Get-KeyPhrase -String "my name is prateek and I live in New Delhi"
    New Delhi
    prateek

    In above example, I passed an string to cmdlet in order to get the key phrases.

.EXAMPLE
    PS C:\> "my name is prateek and I live in New Delhi", "I was born in Ayodhya" | Get-KeyPhrase
    New Delhi
    prateek
    Ayodhya
       
    You can also pass string from pipeline as the cmdlet accpets input from pipeline
.EXAMPLE
    PS C:\> Get-Content C:\Data\File.txt | Out-String | Get-KeyPhrase
    clients
    confident making important business decisions
    Computer Vision API
    data
    information
    reliability

    Convert content of a file to string and pipe to generate Key Phrases for the whole Document. 
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Get-KeyPhrase
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
               $body=$S

               $Results = Invoke-RestMethod -Uri "https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/keyPhrases" `
                                            -Method 'POST' `
                                            -ContentType 'application/json' `
                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_TextAnalytics_API_key } `
                                            -Body (@{"documents" = [Object[]] [ordered]@{"language"= "en"; "id"= "1";"text"= $s} } |ConvertTo-Json) `
                                            -ErrorVariable E


               $Results.documents.keyPhrases
                
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
