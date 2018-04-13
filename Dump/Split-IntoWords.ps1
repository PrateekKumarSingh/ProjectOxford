<#.Synopsis
Cmdlet is capable of inserting spaces in words that lack spaces.
.DESCRIPTION
Insert spaces into a string of words lacking spaces, like a hashtag or part of a URL. Punctuation or exotic characters can prevent a string from being broken.
So it's best to limit input strings to lower-case, alpha-numeric characters.
NOTE : You need to subscribe the "Web language Model API (WebLM)" before using this powershell script from the following link and setup an environment variable like, $env:MS_WebLM_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up
.EXAMPLE
PS Root\> "ilovepowershell", "Helloworld" | Split-IntoWords

Original        Formatted        
--------        ---------        
ilovepowershell i love powershell
Helloworld      hello world
#>
Function Split-IntoWords
{
[CmdletBinding()]
Param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
        [string] $String
)

Begin
{
    Function Clean-String($Str)
    {
        Foreach($Char in [Char[]]"!@#$%^&*(){}|\/?><,.][+=-_"){$str=$str.replace("$Char",'')}
        Return $str
    }

    If(!$Env:MS_WebLM_API_KEy)
    {
        Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_WebLM_API_key = `"YOUR API KEY`" `n`n"
    }

}

Process{



        Foreach($S in (Clean-String $String))
        {
            $SplatInput = @{
            
            Uri= "https://api.projectoxford.ai/text/weblm/v1.0/breakIntoWords?model=anchor&text=$S&maxNumOfCandidatesReturned=5"
            Method = 'Post'
        }
            $Headers = @{
            
            'Ocp-Apim-Subscription-Key' = $Env:MS_WebLM_API_KEy
        }
            Try
            {
                $Data = Invoke-RestMethod @SplatInput -Headers $Headers -ErrorVariable E
                Return  new-object psobject -Property @{               
                Original=$String; 
                Formatted =($data.candidates |select words, Probability|sort -Descending)[0].words
                }|select Original, Formatted
            }
            Catch
            {
                $Message = ($E.errorrecord.ErrorDetails.message|Out-String|ConvertFrom-Json).message   
                $category = $E.errorrecord.categoryInfo
                
                Write-Error -Exception ($E.errorrecord.Exception) `
                            -Message $message `
                            -Category $category.category `
                            -CategoryActivity $category.Activity `
                            -CategoryReason $category.Reason `
                            -TargetName $category.TargetName `
                            -TargetType $category.TargetType `
                            -RecommendedAction ($E.errorrecord.errordetails.RecommendedAction) `
                            -ErrorId $E.errorRecord.FullyQualifiedErrorId
            }
        }
    }
}