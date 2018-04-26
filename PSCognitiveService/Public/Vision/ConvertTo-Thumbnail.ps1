Function ConvertTo-Thumbnail {
    [alias("thumbnail")]
    [cmdletbinding()]
    param(
        [Parameter(ParameterSetName = 'Path', Mandatory, Position = 0)]
        [ValidateScript( { 
                [ValidateImage]::Dimensions(
                    [ValidateFile]::Size(
                        [ValidateFile]::Extension(
                            [ValidateFile]::Path($_), [enum]::getnames([Extension])) , 4), 50, 50, 4096, 4096)
            })]
        [System.IO.FileInfo] $Path,

        [Parameter(ParameterSetName = 'URL', Mandatory, Position = 0)]
        [System.Uri] $URL,
        
        [ValidateScript({[ValidateFile]::Extension($_, [enum]::getnames([Extension]))})]
        [Parameter(Position = 1)]
        [System.IO.FileInfo] $OutFile = "$env:USERPROFILE\Pictures\Thumbnail.jpg", 

        [Parameter(Position = 2)] 
        [ValidateRange(0, 1024)]      
        [Int] $Width = 50, 

        [Parameter(Position = 3)] 
        [ValidateRange(0, 1024)]      
        [Int] $Height = 50, 

        [switch] $SmartCropping
    )

    begin {
    }
    process {
        $Object = @()
        if (Test-LocalConfiguration -ServiceName 'Vision') {            
            $Object = [Vision]::new($env:API_SubscriptionKey_ComputerVision, $env:API_Location_ComputerVision)
            switch ($PsCmdlet.ParameterSetName) { 
                "Path" { $Object.toThumbnail($Path, $OutFile, $Width, $Height, $SmartCropping); break} 
                "URL" { $Object.toThumbnail($URL, $OutFile, $Width, $Height, $SmartCropping); break} 
            }        
        }
        Remove-Variable -Name Object
    }
    end {
    }

}

