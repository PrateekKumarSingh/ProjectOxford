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

#Get-Celebrity -URL "http://img2.tvtome.com/i/u/aa0f2214136945d8c57879a5166c4271.jpg"

#"https://upload.wikimedia.org/wikipedia/commons/6/6c/Satya_Nadella.jpg"

$URLs = "http://az616578.vo.msecnd.net/files/2015/12/19/635861460485772096-652901092_selfieoscars.jpg", `
        "http://upload.wikimedia.org/wikipedia/commons/6/6c/Satya_Nadella.jpg", `
        "http://img2.tvtome.com/i/u/aa0f2214136945d8c57879a5166c4271.jpg", `
        "http://www.newstatesman.com/sites/default/files/images/2014%2B36_Friends_Cast_Poker(1).jpg", `
        "http://i.huffpost.com/gen/2018240/images/o-FRIENDS-SHOW-JENNIFER-ANISTON-facebook.jpg"

$URLs | Get-Celebrity |ft * -AutoSize