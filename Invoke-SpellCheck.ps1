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

            $Headers =  @{'Ocp-Apim-Subscription-Key' = "0a774da790a941b59c4104c0c2f61a44"}
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

"effery snove" | Invoke-SpellCheck

"Owershell", "detrimination" |Invoke-SpellCheck

"Owershell", "detrimination" |Invoke-SpellCheck -ShowErrors

"this is is great w@ll of china" |Invoke-SpellCheck -RemoveSpecialChars -ShowErrors

