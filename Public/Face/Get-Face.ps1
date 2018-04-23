Function Get-Face {
    [alias("Face")]
    [cmdletbinding()]
    param(
        [Parameter(ParameterSetName = 'Path', Mandatory, Position = 0)]
        [ValidateScript({ 
                [ValidateImage]::Dimensions(
                    [ValidateFile]::Size(
                        [ValidateFile]::Extension(
                            [ValidateFile]::Path($_), [enum]::getnames([Extension])) , 4), 36, 36, 4096, 4096)
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
