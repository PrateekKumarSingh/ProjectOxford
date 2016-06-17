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

}

Process{



        Foreach($S in (Clean-String $String))
        {
            $SplatInput = @{
            
            Uri= "https://api.projectoxford.ai/text/weblm/v1.0/breakIntoWords?model=anchor&text=$S&maxNumOfCandidatesReturned=5"
            Method = 'Post'
        }
            $Headers = @{
            
            'Ocp-Apim-Subscription-Key' = "2c40da8ae13a4bd1b3b7b8ee77f5fb34"
        }
            Try{
                $Data = Invoke-RestMethod @SplatInput -Headers $Headers
                Return  new-object psobject -Property @{               
                Original=$String; 
                Formatted =($data.candidates |select words, Probability|sort -Descending)[0].words
                }|select Original, Formatted
            }
            Catch{
                Write-Host "Something went wrong, please try running the script again" -fore Cyan
            }
        }
    }
}


"ilovepowershell", "Hello world" | Split-IntoWords
