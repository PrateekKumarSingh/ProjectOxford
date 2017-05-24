<#
.SYNOPSIS
    Cmdlet is capable in extracting text from the web hosted Images.
.DESCRIPTION
    This cmdlet is Using Microsoft cognitive service's "Computer Vision" API as a service to extract text from the web hosted images by issuing an HTTP calls to the API.
    NOTE : You need to subscribe the "Computer Vision API" before using the powershell script from the following link and setup an environment variable like, $env:MS_ComputerVision_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-US/subscriptions

.PARAMETER Url
    Image URL from where you want to extract the text.
.EXAMPLE
    PS Root\> "https://assets.entrepreneur.com/article/1440698865_graphic-quote-estee-lauder.jpg" | Get-ImageText
    
    LineNumber LanguageCode Sentence         
    ---------- ------------ --------         
             1 en           I NEVER DREAMED  
             2 en           ABOUT SUCCESS.   
             3 en           I WORKED FOR IT. 
             4 en           -Edtée Zaudet      
        
    In above example, Function extract the text from the URL passed  returns you the sentences and Identified language

.EXAMPLE
    $URLs = "https://assets.entrepreneur.com/article/1440698865_graphic-quote-estee-lauder.jpg","https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg"
    $URLs | Get-ImageText
    
    LineNumber LanguageCode Sentence             URL                                                                                    
    ---------- ------------ --------             ---                                                                                    
             1 en           I NEVER DREAMED      https://assets.entrepreneur.com/article/1440698865_graphic-quote-estee-lauder.jpg      
             2 en           ABOUT SUCCESS.       https://assets.entrepreneur.com/article/1440698865_graphic-quote-estee-lauder.jpg      
             3 en           I WORKED FOR IT.     https://assets.entrepreneur.com/article/1440698865_graphic-quote-estee-lauder.jpg      
             4 en           -Edtée Zaudet        https://assets.entrepreneur.com/article/1440698865_graphic-quote-estee-lauder.jpg      
             1 en           STOP HATING          https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             2 en           YOURSELF FOR         https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             3 en           EVERYTHING YOU       https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             4 en           AREN'T AND START     https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             5 en           LOVING YOURSELF      https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             6 en           FOR EVERYTHING       https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             7 en           YOU ALREADY ARE.     https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             8 en           RECOVERYEXPERTS.COM  https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
        
    You can also, pass multiple URL's to the cmdlet as it accepts the Pipeline input and will return the results.
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
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
			'Ocp-Apim-Subscription-Key' = $env:MS_ComputerVision_API_key
			}

			If($URL)
			{
				$Body = @{"URL"= "$URL"} | ConvertTo-Json
			}

            Try{
				$Data = Invoke-RestMethod @SplatInput -Body $Body -Headers $Headers -ErrorVariable E
				$Language = $Data.Language
				$i=0; 
                foreach($D in $Data.regions.lines){
				$i=$i+1;$s=''; 
				''|select @{n='LineNumber';e={$i}},@{n='LanguageCode';e={$Language}},@{n='Sentence';e={$D.words.text |%{$s=$s+"$_ "};$s}},@{n='URL';e={$URL}}
                }

            }
            Catch{
                "Something went wrong While extracting Text from Image, please try running the script again`nError Message : "+$E.Message
            }
    }
}
