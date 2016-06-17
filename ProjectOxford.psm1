<#.Synopsis
Identify and Rectify spelling mistakes in an input String
.DESCRIPTION
Identify spelling meistakes and repeated token in a string and suggests possible corrections, able to identify Nouns in the string and converts first alphabet in Uppercase.
Function Generates all possible strings possible using the combination of suggestions.
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

Function Get-CelebrityInImage
{
[CmdletBinding()]
Param(
        #[Parameter(ValueFromPipeline=$True)]
		#[String] $Path,
		[Parameter(ValueFromPipeline=$True)]
		[String] $URL
)

    Begin
    {
    }
    
    Process
    {
        Foreach($Item in $URL)
        {
    
            Try
            {
                $result = Invoke-RestMethod -Uri "https://api.projectoxford.ai/vision/v1.0/models/celebrities/analyze" `
                                            -Method 'Post' `
                                            -ContentType 'application/json' `
                                            -Body $(@{"URL"= $Url} | ConvertTo-Json) `
                                            -Headers @{'Ocp-Apim-Subscription-Key' = "7ee8dc424cc8406ca2503f063a955a38"} `
                                            -ErrorVariable E

                $Celebs =  $result.result.celebrities.name

                ''|select @{n='Celebrities';e={$Celebs}}, @{n='Count';e={$Celebs.count}}, @{n='URL';e={$URL}}
            }
            Catch
            {
                "Something went wrong While extracting Text from Image, please try running the script again`nError Message : "+$E.Message
            }
        }
    }

    End
    {
    }
}

Function Get-ImageText
{
[CmdletBinding()]
Param(
        #[Parameter(ValueFromPipeline=$True)]
		#[String] $Path,
		[Parameter(ValueFromPipeline=$True)]
		[String] $URL
)

Process{
            $SplatInput = @{
            Uri= "https://api.projectoxford.ai/vision/v1/ocr"
            Method = 'Post'
			#InFile = $Path
			ContentType = 'application/json'
			}

            $Headers =  @{
			# Your Secret Subscription Key goes here.
			'Ocp-Apim-Subscription-Key' = "7ee8dc424cc8406ca2503f063a955a38"
			}

			If($URL)
			{
				$Body = @{"URL"= "$URL"} | ConvertTo-Json
			}

            Try{
				$Data = Invoke-RestMethod @SplatInput -Body $Body -Headers $Headers -ErrorVariable E
				$Language = $Data.Language
				$i=0; foreach($D in $Data.regions.lines){
				$i=$i+1;$s=''; 
				''|select @{n='LineNumber';e={$i}},@{n='LanguageCode';e={$Language}},@{n='Sentence';e={$D.words.text |%{$s=$s+"$_ "};$s}}}

            }
            Catch{
                "Something went wrong While extracting Text from Image, please try running the script again`nError Message : "+$E.Message
            }
    }
}

Function Invoke-ImageAnalysis
{
[CmdletBinding()]
Param(
        #[Parameter(ValueFromPipeline=$True)]
		#[String] $Path,
		[Parameter(ValueFromPipeline=$True)]
		[String] $URL
)

    Begin
    {
    }
    
    Process
    {
        ForEach($item in $URL)
        {
    
            Try
            {
                $result = Invoke-RestMethod -Uri "https://api.projectoxford.ai/vision/v1.0/analyze?visualFeatures=description,tags,faces,Color&details=Celebrities" `
                                            -Method 'Post' `
                                            -ContentType 'application/json' `
                                            -Body $(@{"URL"=$item} | ConvertTo-Json) `
                                            -Headers @{'Ocp-Apim-Subscription-Key' = "7ee8dc424cc8406ca2503f063a955a38"} `
                                            -ErrorVariable E

                $tags=($result.tags| ?{$_.confidence -gt 0.5}).Name
                $Caption  = ($result.description.captions|sort confidence -Descending)[0].text
                $Faces = $result.faces
                $PeopleCount = $result.faces.Count
                $Color = $result.color


                ''|select @{n='Tags';e={$Tags}}, @{n='Caption';e={$Caption}},`
                          @{n='PeopleCount';e={$PeopleCount}},@{n='Faces';e={$Faces}},` 
                          @{n='IsBlackAndWhite';e={$Color.isBWImg}}, @{n='ForegroundColor';e={$Color.dominantColorForeground}}, @{n='BackgroundColor';e={$Color.dominantColorBackground}}, @{n='ProminentColors';e={$Color.dominantColors}},`
                          @{n='URL';e={$Item}}
            }
            Catch
            {
                ($E.errorrecord.ErrorDetails.Message -split '"')[-2]
            }
        }
    }

    End
    {
    }
}

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

Function Test-AdultContent
{
[CmdletBinding()]
Param(
        #[Parameter(ValueFromPipeline=$True)]
		#[String] $Path,
		[Parameter(ValueFromPipeline=$True)]
		[String] $URL
)

    Begin
    {
    }
    
    Process
    {
        Foreach($Item in $URL)
        {
    
            Try
            {
                $result = Invoke-RestMethod -Uri "https://api.projectoxford.ai/vision/v1.0/analyze?visualFeatures=Adult" `
                                            -Method 'Post' `
                                            -ContentType 'application/json' `
                                            -Body $(@{"URL"= $URL} | ConvertTo-Json) `
                                            -Headers @{'Ocp-Apim-Subscription-Key' = "7ee8dc424cc8406ca2503f063a955a38"} `
                                            -ErrorVariable E

                $result.adult | select IsAdultContent, isRacyContent, @{n='URL';e={$Item}}
            }
            Catch
            {
                Writ ($E.errorrecord.ErrorDetails.Message -split '"')[-2]
            }
        }
    }

    End
    {
    }
}
