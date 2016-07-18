<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Get-NextWords
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Valuefrompipeline = $true)][String] $String
    )

    Begin
    {
    }
    Process
    {
        Foreach($item in $String)
        {
            $result = Invoke-RestMethod -Uri "https://api.projectoxford.ai/text/weblm/v1.0/generateNextWords?model=query&words=$item&maxNumOfCandidatesReturned" `
                                        -Method 'Post' `
                                        -ContentType 'application/json' `
                                        -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_WebLM_API_KEy } `
                                        -ErrorVariable E

            $result.candidates | select @{n='String';e={$item}} , @{n='NextWord';e={$_.word}}, @{n='Probability';e={$_.Probability}}
        }
    }
    End
    {
    }
}
