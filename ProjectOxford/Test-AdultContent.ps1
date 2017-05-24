<#.Synopsis
Get Adult and Racy score of an Web hosted Images.
.DESCRIPTION
Function identifies any adult or racy content on a web hosted Image and flags them with a Boolean value [$true/$false]
NOTE : You need to subscribe the "Computer Vision API" before using the powershell script from the following link and setup an environment variable like, $env:MS_ComputerVision_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-US/subscriptions

.EXAMPLE
PS Root\> "http://upload.wikimedia.org/wikipedia/commons/6/6c/Satya_Nadella.jpg" | Test-AdultContent

isAdultContent isRacyContent URL                                                                 
-------------- ------------- ---                                                                 
         False         False http://upload.wikimedia.org/wikipedia/commons/6/6c/Satya_Nadella.jpg

pass the Image URL to the function through a pipeline to get the results.
.EXAMPLE
PS Root\> (Invoke-WebRequest -Uri 'http:\\geekeefy.wordpress.com' -UseBasicParsing).images.src | Test-AdultContent -ErrorAction SilentlyContinue |ft -AutoSize

isAdultContent isRacyContent URL                                                                                                  
-------------- ------------- ---                                                                                                  
         False         False https://geekeefy.files.wordpress.com/2016/06/tip2.gif?w=596&amp;h=300&amp;crop=1                     
         False         False https://geekeefy.files.wordpress.com/2016/06/wil.png?w=900&amp;h=152&amp;crop=1                      
         False         False https://geekeefy.files.wordpress.com/2016/06/windowserror1.gif?w=900&amp;h=300&amp;crop=1            
         False         False https://geekeefy.files.wordpress.com/2016/06/gist3.png?w=711&amp;h=133&amp;crop=1                    
         False         False https://geekeefy.files.wordpress.com/2016/05/ezgif-com-video-to-gif-11.gif?w=900&amp;h=300&amp;crop=1

You can also pass a series of Image URL's to the Cmdlet, like in the above example I passed it Image URL's of all images from my Blog homepage.
Please note that, API has a limitation of 20 requests per min, so you may see errors after the limitation is breached
#>
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
                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_ComputerVision_API_key} `
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
