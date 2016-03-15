<#.Synopsis
Identify and Rectify spelling mistakes in an input String
.DESCRIPTION
Identify spelling meistakes and repeated token in a string and suggests possible corrections, able to identify Nouns in the string and converts first alphabet in Uppercase.
Function Generates all possible strings possible using the combination of suggestions.
.EXAMPLE
Hello world
.EXAMPLE
PS D:\> "owershell is is fun" | Start-SpellCheck -ShowErrors |ft -AutoSize

ErrorToken Type          Suggestions
---------- ----          -----------
owershell  UnknownToken  powershell 
is         RepeatedToken         

DESCRIPTION
-----------
When Start-SpellCheck function is used with -ShowErrors switch, it identifies unknown tokens (mistakes), repeated token in the string and displays Suggestions.  
.EXAMPLE
PS D:\> "thes is the the graet wall of china" |Start-SpellCheck
this is the great wall of China
the is the great wall of China

DESCRIPTION
-----------
Using the Suggestion function generates all possible combination of sentences.
.EXAMPLE
PS D:\> "b!ll g@tes" |Start-SpellCheck -RemoveSpecialChars
Bill Gates

DESCRIPTION
-----------
When Start-SpellCheck function is used with -RemoveSpecialChars switch, it removes all special character fomr the input string and rectifies the spelling mistakes.
#>

Function Start-SpellCheck()
{
[CmdletBinding()]
Param(
        [Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$True)]
		[String[]]$String,
		[Switch] $ShowErrors,
		[Switch] $RemoveSpecialChars
)
Process{
		If($RemoveSpecialChars){ $String = Remove-SpecialChars $String	}
		
        Foreach($S in $String)
        {
            $SplatInput = @{
            Uri= "https://api.projectoxford.ai/text/v1.0/spellcheck?Proof"
            Method = 'Post'
			}

            $Headers =  @{'Ocp-Apim-Subscription-Key' = "0826b10032104bbb9794572e171b1c62"}
			$body =     @{'text'=$s	}
            Try{
                $SpellingErrors = (Invoke-RestMethod @SplatInput -Headers $Headers -Body $body -ErrorVariable +E ).SpellingErrors
				$OutString = $String # Make a copy of string to replace the errorswith suggestions.

				If($SpellingErrors)  # If Errors are Found
				{
					# Nested Foreach to generate the Rectified string Post Spell-Check
					Foreach($E in $spellingErrors){
					
						If($E.Type -eq 'UnknownToken') # If an unknown word identified, replace it with the respective sugeestion from the API results
						{
							$OutString= Foreach($s in $E.suggestions.token)
										{
											$OutString -replace $E.token, $s
										}
						}
						Else      # If REPEATED WORDS then replace the set by an instance of repetition
						{
							$OutString = $OutString -replace "$($E.token) $($E.token) ", "$($E.token) "
						}
					}

					# InCase ShowErrors switch is ON
					If($ShowErrors -eq $true)
					{
						return $SpellingErrors |select @{n='ErrorToken';e={$_.Token}},@{n='Type';e={$_.Type}}, @{n='Suggestions';e={($_.suggestions).token|?{$_ -ne $null}}}
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
                "Something went wrong While extracting Text from Image, please try running the script again`nError Message : "+$E.Message
            }
        }
    }
}

# Function to Remove special character s and punctuations from Input string
Function Remove-SpecialChars($Str)
{
    Foreach($Char in [Char[]]"!@#$%^&*(){}|\/?><,.][+=-_"){$str=$str.replace("$Char",'')}
    Return $str
}
