Function Get-ImageDescription{
    [alias("description")]
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

        [int] $NumOfCandidates = 1
    )

    begin {
    }
    process {
        $Object = @()
        if (Test-LocalConfiguration -ServiceName 'ComputerVision') {            
            $Object = [Vision]::new($env:API_SubscriptionKey_ComputerVision, $env:API_Location_ComputerVision)
            switch ($PsCmdlet.ParameterSetName) { 
                "Path" { $Object.describe($path, $NumOfCandidates) ; break} 
                "URL" { $Object.describe($url, $NumOfCandidates); break} 
            }        
        }
        Remove-Variable -Name Object
    }
    end {
    }

}
