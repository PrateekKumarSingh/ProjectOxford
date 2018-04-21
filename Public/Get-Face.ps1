Function Get-Face {
    [alias("Face")]
    [cmdletbinding()]
    param(
        [Parameter(ParameterSetName = 'Path', Mandatory, Position = 0)]
        [ValidateScript( { 
                [ValidateFile]::Size([ValidateFile]::Extension([ValidateFile]::Path($_), [enum]::getnames([Extension])) , 4)
            })]
        [System.IO.FileInfo] $Path,

        [Parameter(ParameterSetName = 'URL', Mandatory, Position = 0)]
        [System.Uri] $URL,

        [FaceAttributes[]] $FaceAttributes = [enum]::getnames([FaceAttributes]),

        [Switch] $FaceId, 
        
        [Switch] $FaceLandmarks
    )

    begin {
    }
    process {
        $Object = @()
        if (Test-LocalConfiguration -ServiceName 'Face') {            
            $Object = [Face]::new($env:API_SubscriptionKey_Face, $env:API_Location_Face)
            switch ($PsCmdlet.ParameterSetName) { 
                "Path" { $Object.detect($path, $FaceAttributes, $FaceId, $FaceLandmarks) ; break} 
                "URL" { $Object.detect($url, $FaceAttributes, $FaceId, $FaceLandmarks); break} 
            }        
        }
        Remove-Variable -Name Object
    }
    end {
    }

}


#man analyze
#
#
#$visual_features = [enum]::GetNames([visualFeatures])
#$details = [enum]::GetNames([details])
#
#$url = [system.uri] "https://upload.wikimedia.org/wikipedia/commons/d/d9/Bill_gates_portrait.jpg"
#$path = [System.IO.FileInfo]'C:\Tmp\bill.jpg'
#
## create computer vision object
#$Object = [ComputerVision]::new($key, 'SouthEastAsia')
#$o = new-object ComputerVision($key, 'SouthEastAsia')
#
## analyze image
#$Object.analyze($url)
#$Object.analyze($path)
#
## analyze image with visual features and details
#$Object.analyze($url, $visual_features, $details)
#$Object.analyze($path, $visual_features, $details)
#
