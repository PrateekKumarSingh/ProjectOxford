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

$URL = "http://Snoverisms.com/"
(Invoke-WebRequest -Uri $URL).images.src |?{$_ -match 'quotes'}| Get-Random -Count 1 | %{$URL+$_} | Get-ImageText