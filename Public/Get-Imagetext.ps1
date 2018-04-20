Function Get-ImageText{
    [alias("ocr")]
    [cmdletbinding()]
    param(
        [Parameter(ParameterSetName = 'Path',Mandatory, Position = 0)]
        [ValidateScript( { 
            [ValidateFile]::Size([ValidateFile]::Extension([ValidateFile]::Path($_), [enum]::getnames([Extension])) , 4)
        })]
        [System.IO.FileInfo] $Path,

        [Parameter(ParameterSetName = 'URL',Mandatory, Position = 0)]
        [System.Uri] $URL
    )

    begin {
    }
    process {
        $Object = @()
        if (Test-LocalConfiguration -ServiceName 'Vision') {            
            $Object = [ComputerVision]::new($env:API_SubscriptionKey_Vision, $env:API_Location_Vision)
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
