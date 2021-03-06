Function Test-AdultRacyContent {
    [alias("moderate")]
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
        
        [Parameter(ParameterSetName = 'URL')]
        [Parameter(ParameterSetName = 'Path')]
        [switch] $CachesImage = $false,
        
        [Parameter(ParameterSetName = 'Text')]
        [System.String] $Text,

        [Parameter(ParameterSetName = 'Text')]
        [switch] $AutoCorrect,
        
        [Parameter(ParameterSetName = 'Text')]
        [Switch] $PersonalIdentifiableInformation, 

        [Parameter(ParameterSetName = 'Text')]
        [System.String] $ListId = '', 
        
        [Parameter(ParameterSetName = 'Text')]
        [System.String] $Language = 'Eng'
    )

    begin {
    }
    process {
        $Object = @()
        if (Test-LocalConfiguration -ServiceName 'ContentModerator') {            
            $Object = [ContentModerator]::new($env:API_SubscriptionKey_ContentModerator, $env:API_Location_ContentModerator)
            switch ($PsCmdlet.ParameterSetName) { 
                "Path" { $Object.processimage($path, $cachesImage) ; break} 
                "URL" { $Object.processimage($url, $cachesImage); break} 
                "Text" { $Object.processtext($text, $AutoCorrect, $PersonalIdentifiableInformation, $ListId, $Language ) ; break }
            }        
        }
        Remove-Variable -Name Object
    }
    end {
    }

}

Export-ModuleMember -Function Test-AdultRacyContent -Alias moderate
