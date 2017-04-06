<#.Synopsis
Returns information about visual content found in web hosted images.
.DESCRIPTION
Function returns variety of information about visual content found in an image, like Color schemes, Face rectangles, Tags, caption (Small description of Image), head couts, Age & gender of people in Image, celebrity identification and much much more.
NOTE : You need to subscribe the "Computer Vision API" before using the powershell script from the following link and setup an environment variable like, $env:MS_ComputerVision_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-US/subscriptions

.EXAMPLE
PS Root\> "http://cdn.deccanchronicle.com/sites/default/files/NADELLA2.jpg" | Get-ImageAnalysis


Tags            : {person, man, glasses, cellphone...}
Caption         : Satya Nadella with glasses holding a cell phone
PeopleCount     : 1
Faces           : @{age=44; gender=Male; faceRectangle=}
IsBlackAndWhite : False
ForegroundColor : Blue
BackgroundColor : Blue
ProminentColors : {Blue, White}
URL             : http://cdn.deccanchronicle.com/sites/default/files/NADELLA2.jpg

Passing an image URL through pipeline to the cmdlet will return you the image analysis information

.EXAMPLE
PS Root\> ("http://i.huffpost.com/gen/2018240/images/o-FRIENDS-SHOW-JENNIFER-ANISTON-facebook.jpg" |Get-ImageAnalysis).faces

age gender faceRectangle                               
--- ------ -------------                               
 31 Male   @{left=902; top=394; width=159; height=159} 
 28 Female @{left=300; top=531; width=144; height=144} 
 31 Male   @{left=478; top=316; width=137; height=137} 
 27 Male   @{left=1254; top=254; width=133; height=133}
 29 Female @{left=1486; top=456; width=131; height=131}
 32 Female @{left=685; top=121; width=129; height=129} 

In above example I selected the 'Faces' property of the result and it returned all Identified faces, their Age and gender.
#>
Function Get-ImageAnalysis
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
                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_ComputerVision_API_key} `
                                            -ErrorVariable E

                $tags=($result.tags| ?{$_.confidence -gt 0.5}).Name
                $Caption  = ($result.description.captions|sort confidence -Descending)[0].text
                $Faces = $result.faces
                $PeopleCount = $result.faces.Count
                $Color = $result.color


                ''|select @{n='Tags';e={$Tags}}, @{n='Caption';e={$Caption}},`
                          @{n='HeadCount';e={$PeopleCount}},@{n='Faces';e={$Faces}},` 
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
