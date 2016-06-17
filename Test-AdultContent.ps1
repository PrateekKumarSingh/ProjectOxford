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

#@(
#	"http://az616578.vo.msecnd.net/files/2015/12/19/635861460485772096-652901092_selfieoscars.jpg", `
#        "http://upload.wikimedia.org/wikipedia/commons/6/6c/Satya_Nadella.jpg", `
#        "http://img2.tvtome.com/i/u/aa0f2214136945d8c57879a5166c4271.jpg", `
#        "http://www.newstatesman.com/sites/default/files/images/2014%2B36_Friends_Cast_Poker(1).jpg", `
#        "http://i.huffpost.com/gen/2018240/images/o-FRIENDS-SHOW-JENNIFER-ANISTON-facebook.jpg", `
#        "http://img01.thedrum.com/s3fs-public/styles/news_article_lightbox/public/news/tmp/103031/nrm_1418898205-cosmopolitan_february_cover.jpg?itok=2b0rU0Db"
#) | Test-AdultContent |ft * -AutoSize

(iwr -Uri 'http:\\geekeefy.wordpress.com' -UseBasicParsing).images.src | Test-AdultContent -ErrorAction SilentlyContinue
