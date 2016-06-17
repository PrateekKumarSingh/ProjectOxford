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

@(
    "http://www.zastavki.com/pictures/originals/2013/Girls___Beautyful_Girls_Girl_sitting_on_a_bench_043919_.jpg",
    "http://cdn.deccanchronicle.com/sites/default/files/NADELLA2.jpg",
    "http://i.huffpost.com/gen/2018240/images/o-FRIENDS-SHOW-JENNIFER-ANISTON-facebook.jpg"
) | Invoke-ImageAnalysis