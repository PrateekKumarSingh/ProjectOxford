Function Get-ImageText{
    [alias("ocr")]
    [cmdletbinding()]
    param(
        [Parameter(ParameterSetName = 'Path',Mandatory, Position = 0)]
        [ValidateScript( { 
                [ValidateImage]::Dimensions(
                    [ValidateFile]::Size(
                        [ValidateFile]::Extension(
                            [ValidateFile]::Path($_), [enum]::getnames([Extension])) , 4), 40, 40, 3200, 3200)
        })]
        [System.IO.FileInfo] $Path,

        [Parameter(ParameterSetName = 'URL',Mandatory, Position = 0)]
        [System.Uri] $URL
    )

    begin {
    }
    process {
        $Object = @()
        if (Test-LocalConfiguration -ServiceName 'ComputerVision') {            
            $Object = [ComputerVision]::new($env:API_SubscriptionKey_ComputerVision, $env:API_Location_ComputerVision)
            switch ($PsCmdlet.ParameterSetName) { 
                "Path" { $Object.ocr($path) ; break} 
                "URL" { $Object.ocr($url); break} 
            }        
        }
        Remove-Variable -Name Object
    }
    end {
    }

}
