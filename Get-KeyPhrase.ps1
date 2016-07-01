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
