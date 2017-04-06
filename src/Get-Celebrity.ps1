<#
.SYNOPSIS
    Cmdlet is capable to identify the Names and total numbers of Celebrities in a web hosted Image.
.DESCRIPTION
    This cmdlet is Using Microsoft cognitive service's "Computer Vision" API as a service to get the information needed by issuing an HTTP request to the API
    NOTE : You need to subscribe the "Computer Vision API" before using the powershell script from the following link and setup an environment variable like, $env:MS_ComputerVision_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-US/subscriptions
.PARAMETER Url
    Image URL where you want to identify the Celebrities.
.EXAMPLE
    PS Root\> Get-Celebrity -URL "http://img2.tvtome.com/i/u/aa0f2214136945d8c57879a5166c4271.jpg"
    Celebrities                                        Count URL                                                            
    -----------                                        ----- ---                                                            
    {David Schwimmer, Matthew Perry, Jennifer Aniston}     3 http://img2.tvtome.com/i/u/aa0f2214136945d8c57879a5166c4271.jpg   
    
    In above example, Function identifies all celebrities in the web hosted image and their head count. Then returns the Information like, Celebrity name, Count and URL searched.
.EXAMPLE
    PS Root\> $URLs = "http://az616578.vo.msecnd.net/files/2015/12/19/635861460485772096-652901092_selfieoscars.jpg", 
        "http://upload.wikimedia.org/wikipedia/commons/6/6c/Satya_Nadella.jpg","http://img2.tvtome.com/i/u/aa0f2214136945d8c57879a5166c4271.jpg",
        "Http://www.newstatesman.com/sites/default/files/images/2014%2B36_Friends_Cast_Poker(1).jpg",
        "http://i.huffpost.com/gen/2018240/images/o-FRIENDS-SHOW-JENNIFER-ANISTON-facebook.jpg"
    $URLs | Get-Celebrity |ft * -AutoSize
    Celebrities                                                    Count URL                                                                                         
    -----------                                                    ----- ---                                                                                         
    {Bradley Cooper, Ellen DeGeneres, Jennifer Lawrence}               3 http://az616578.vo.msecnd.net/files/2015/12/19/635861460485772096-652901092_selfieoscars.jpg
    Satya Nadella                                                      1 http://upload.wikimedia.org/wikipedia/commons/6/6c/Satya_Nadella.jpg                        
    {David Schwimmer, Matthew Perry, Jennifer Aniston}                 3 http://img2.tvtome.com/i/u/aa0f2214136945d8c57879a5166c4271.jpg                             
    David Schwimmer                                                    1 http://www.newstatesman.com/sites/default/files/images/2014%2B36_Friends_Cast_Poker(1).jpg  
    {David Schwimmer, Lisa Kudrow, Matthew Perry, Matt LeBlanc...}     5 http://i.huffpost.com/gen/2018240/images/o-FRIENDS-SHOW-JENNIFER-ANISTON-facebook.jpg
    You can also, pass multiple URL's to the cmdlet as it accepts the Pipeline input and will return the results.
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Get-Celebrity
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
                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_ComputerVision_API_key } `
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
