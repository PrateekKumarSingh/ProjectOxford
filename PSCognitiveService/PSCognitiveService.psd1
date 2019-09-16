@{
    # Script module or binary module file associated with this manifest.
    RootModule           = '.\PSCognitiveService.psm1'

    # Version number of this module.
    ModuleVersion        = '0.4.5'

    # Supported PSEditions
    # CompatiblePSEditions = @('Desktop', 'Core')

    # ID used to uniquely identify this module
    GUID                 = 'c2e17d6f-16c1-4afd-aad0-5c8ba0be10ee'

    # Author of this module
    Author               = 'Prateek Singh'

    # Company or vendor of this module
    CompanyName          = 'Prateek Singh'

    # Copyright statement for this module
    Copyright            = '(c) 2019 Prateek Singh. All rights reserved.'

    # Description of the functionality provided by this module
    Description          = "PowerShell wrapper around Microsoft Azure Cognitive Services REST API's, to bring power of Machine Learning to your console and applications"

    # Minimum version of the Windows PowerShell engine required by this module
    # PowerShellVersion    = '5.1'
    
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = @(
        'ConvertTo-Thumbnail',
        'Get-Face',
        'Get-ImageAnalysis',
        'Get-ImageDescription',
        'Get-ImageTag',
        'Get-Imagetext',
        'Get-KeyPhrase',
        'Get-Sentiment',
        'New-CognitiveServiceInstance',
        'New-CognitiveServiceAccount'
        'New-LocalConfiguration',
        'Search-Entity',
        'Search-Web',
        'Search-Image',
        'Test-AdultRacyContent',
        'Test-FaceMatch',
        'Trace-Language'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('azure', 'AzureRM', 'az', 'CognitiveService', 'AI', 'NetCore', 'Core')

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/PrateekKumarSingh/PSCognitiveService'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = "Adapted to to new 'Az' modules"

        } # End of PSData hashtable

    } # End of PrivateData hashtable
}
