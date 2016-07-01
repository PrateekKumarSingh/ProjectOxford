<#
.SYNOPSIS
    Recognize a named-entity from given text and aligning a textual mention of the entity to an appropriate entry in a knowledge base.
.DESCRIPTION
    Identifies and Maps named entities to appropriate knowledge base articles using  Microsoft cognitive service's "Entity linking" API.
    NOTE : You need to subscribe the "Entity linking API" before using the powershell script from the following link and setup an environment variable like, $env:MS_EntityLink_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-US/subscriptions
.PARAMETER String
    String to search for named entities.
.EXAMPLE
    PS Root\> Get-EntityLink -String "NASA sends space shuttles to ISS"
    
    Name                        Match MatchIndices Wiki Link                                               
    ----                        ----- ------------ ---------                                               
    NASA                        NASA  (0,3)        http://en.wikipedia.org/wiki/NASA                       
    International Space Station ISS   (29,31)      http://en.wikipedia.org/wiki/International_Space_Station

    In above example, I passed an string to cmdlet in order to link some word entities to wikipedia pages/articles
.EXAMPLE 
    PS Root\> "Bill gates invented Windows operating system " | Get-EntityLink
    
    Name              Match                    MatchIndices Wiki Link                                     
    ----              -----                    ------------ ---------                                     
    Bill Gates        Bill gates               (0,9)        http://en.wikipedia.org/wiki/Bill_Gates       
    Microsoft Windows Windows operating system (20,43)      http://en.wikipedia.org/wiki/Microsoft_Windows
       
    You can also pass string from pipeline as the cmdlet accpets input from pipeline
.EXAMPLE
    PS Root\> Get-Content File.txt | Out-String | Get-EntityLink

    Name               Match            MatchIndices                                Wiki Link                                               
    ----               -----            ------------                                ---------                                               
    Windows PowerShell {PowerShell, PS} {(0,1), (37,38), (403,404), (1267,1268)...} http://en.wikipedia.org/wiki/Windows_PowerShell         
    Microsoft          Microsoft        (101,109)                                   http://en.wikipedia.org/wiki/Microsoft                  
    Flow Java          ToString         (3058,3065)                                 http://en.wikipedia.org/wiki/Java_(programming_language)
    UTF-8              Unicode/UTF-8    (3288,3300)                                 http://en.wikipedia.org/wiki/UTF-8                      
   
    Convert content of a file to string and pipe to generate Entity links for the whole Document. 

.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Get-EntityLink
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

                $Results = Invoke-RestMethod -Uri "https://api.projectoxford.ai/entitylinking/v1.0/link" `
                                                            -Method 'POST' `
                                                            -ContentType 'text/plain' `
                                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_EntityLink_API_key } `
                                                            -Body $body `
                                                            -ErrorVariable E


                $Results.entities| ?{$_.score -gt 0.5} | select @{n="Name";e={$_.name}},`
                                                                 @{n='Match';e={$_.matches.text}}, `
                                                                 @{n='MatchIndices';e={Foreach($offset in $_.matches.Entries.offset){"($Offset,$($offset+($_.matches.text).length-1))"}}}, `
                                                                 @{n='Wiki Link';e={"http://en.wikipedia.org/wiki/$(($_.wikipediaId).replace(" ",'_'))"}}
               
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
