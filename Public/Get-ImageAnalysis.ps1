Function Get-ImageAnalysis {
    [alias("analyze")]
    [cmdletbinding()]
    param(
        [Parameter(ParameterSetName = 'Path',Mandatory, Position = 0)]
        [ValidateScript( { 
                [ValidateImage]::Dimensions(
                    [ValidateFile]::Size(
                        [ValidateFile]::Extension(
                            [ValidateFile]::Path($_), [enum]::getnames([Extension])) , 4), 50, 50, 4096, 4096)
        })]
        [System.IO.FileInfo] $Path,

        [Parameter(ParameterSetName = 'URL',Mandatory, Position = 0)]
        [System.Uri] $URL,

        [VisualFeatures[]] $VisualFeatures = [enum]::getnames([VisualFeatures]),

        [Details[]] $Details = [enum]::getnames([Details])
    )

    begin {
    }
    process {
        $Object = @()
        if (Test-LocalConfiguration -ServiceName 'Vision') {            
            $Object = [ComputerVision]::new($env:API_SubscriptionKey_Vision, $env:API_Location_Vision)
            switch ($PsCmdlet.ParameterSetName) { 
                "Path" { $Object.analyze($path, $VisualFeatures, $Details) ; break} 
                "URL" { $Object.analyze($url, $VisualFeatures, $Details); break} 
            }        
        }
        Remove-Variable -Name Object
    }
    end {
    }

}

#$path =  'C:\tmp\Bill.jpg'
#Get-ImageAnalysis $path -Verb
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
