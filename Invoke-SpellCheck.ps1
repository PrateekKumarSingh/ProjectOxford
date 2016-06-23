<#.Synopsis
Identify and Rectify spelling mistakes in an input String
.DESCRIPTION
Identify spelling meistakes and repeated token in a string and suggests possible combination of correct spellings, able to identify Nouns in the string and converts first alphabet in Uppercase.
Cmdlet is Using Microsoft cognitive service's "Spell Check" API as a service to get the information needed by making HTTP calls to the API
NOTE : You need to subscribe the "Spell Check API" before using the powershell script from the following link and setup an environment variable like, $env:MS_SpellCheck_API_key = "YOUR API KEY"
    
API Subscription Page - https://www.microsoft.com/cognitive-services/en-US/subscriptions
.EXAMPLE
Hello world
.EXAMPLE
PS D:\> "owershell is is fun" | Invoke-SpellCheck -ShowErrors |ft -AutoSize

ErrorToken Type          Suggestions
---------- ----          -----------
owershell  UnknownToken  powershell 
is         RepeatedToken         

DESCRIPTION
-----------
When Invoke-SpellCheck function is used with -ShowErrors switch, it identifies unknown tokens (mistakes), repeated token in the string and displays Suggestions.  
.EXAMPLE
PS D:\> "thes is the the graet wall of china" |Invoke-SpellCheck
this is the great wall of China
the is the great wall of China

DESCRIPTION
-----------
Using the Suggestion function generates all possible combination of sentences.
.EXAMPLE
PS D:\> "b!ll g@tes" |Invoke-SpellCheck -RemoveSpecialChars
Bill Gates

DESCRIPTION
-----------
When Invoke-SpellCheck function is used with -RemoveSpecialChars switch, it removes all special character fomr the input string and rectifies the spelling mistakes.
#>
Function Invoke-SpellCheck
{
[CmdletBinding()]
Param(
        [Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$True)]
		[String] $String,
		[Switch] $ShowErrors,
		[Switch] $RemoveSpecialChars
)

Begin
{
    # Function to Remove special character s and punctuations from Input string
    Function Remove-SpecialChars($Str) { Foreach($Char in [Char[]]"!@#$%^&*(){}|\/?><,.][+=-_"){$str=$str.replace("$Char",'')}; Return $str}
}

Process{
		If($RemoveSpecialChars){ $String = Clean-String $String	}
		
        Foreach($S in $String)
        {
            $SplatInput = @{
            Uri= "https://bingapis.azure-api.net/api/v5/spellcheck?Proof"
            Method = 'Post'
			}

            $Headers =  @{'Ocp-Apim-Subscription-Key' = $env:MS_SpellCheck_API_key}
			$body =     @{'text'= $s}
            Try{
                $SpellingErrors = (Invoke-RestMethod @SplatInput -Headers $Headers -Body $body ).flaggedTokens
				$OutString = $String # Make a copy of string to replace the errorswith suggestions.

				If($SpellingErrors)  # If Errors are Found
				{
					# Nested Foreach to generate the Rectified string Post Spell-Check
					Foreach($E in $spellingErrors){
					
						If($E.Type -eq 'UnknownToken') # If an unknown word identified, replace it with the respective sugeestion from the API results
						{
							$OutString= Foreach($s in $E.suggestions.suggestion)
										{
											$OutString -replace $E.token, $s
										}
						}
						ElseIf($E.Type -eq 'RepeatedToken')  # If REPEATED WORDS then replace the set by an instance of repetition
						{
							$OutString = $OutString -replace "$($E.Token) $($E.Token) ", "$($E.Token) "
						}
					}

					# InCase ShowErrors switch is ON
					If($ShowErrors -eq $true)
					{
						return $SpellingErrors |select @{n='ErrorToken';e={$_.Token}},@{n='Type';e={$_.Type}}, @{n='Suggestions';e={($_.suggestions).suggestion|?{$_ -ne $null}}}
					}
					Else      # Else return the spell checked string
					{
						Return $OutString 
					}
				}
				else     # When No error is found in the input string
				{			
						Return "No errors found in the String."
				}
				
            }
            Catch{
                "Something went wrong, please try running the script again"
            }
        }
    }

End
{
}
}
