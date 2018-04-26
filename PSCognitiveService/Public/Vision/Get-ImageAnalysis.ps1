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
            $Object = [Vision]::new($env:API_SubscriptionKey_ComputerVision, $env:API_Location_ComputerVision)
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
