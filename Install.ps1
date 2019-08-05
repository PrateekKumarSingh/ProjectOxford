<#
    .SYNOPSIS
        Download the module files from GitHub.

    .DESCRIPTION
        Download the module files from GitHub to the local client in the module folder.
#>

[CmdLetBinding()]
Param (
    [ValidateNotNullOrEmpty()]
    [String]$ModuleName = 'PSCognitiveService',
    [String]$InstallDirectory,
    [ValidateNotNullOrEmpty()]
    [String]$GitPath = 'https://raw.githubusercontent.com/PrateekKumarSingh/PSCognitiveService/master'
)

$Pre = $VerbosePreference
$VerbosePreference = 'continue'

#Try {
    Write-Verbose "$ModuleName module installation started"

    $Files = @(
        'PSCognitiveService/PSCognitiveService.psd1',
        'PSCognitiveService/PSCognitiveService.psm1',
        'PSCognitiveService/Classes/Vision.ps1',
        'PSCognitiveService/Classes/Moderate.ps1',
        'PSCognitiveService/Classes/Enum.ps1',
        'PSCognitiveService/Classes/Face.ps1',
        'PSCognitiveService/Classes/ValidateFile.ps1',
        'PSCognitiveService/Classes/ValidateImage.ps1',
        'PSCognitiveService/Private/Test-AzLogin.ps1',
        'PSCognitiveService/Private/Test-LocalConfiguration.ps1',
        'PSCognitiveService/Public/New-LocalConfiguration.ps1',
        'PSCognitiveService/Public/Face/Get-Face.ps1',
        'PSCognitiveService/Public/Moderator/Test-AdultRacyContent.ps1',
        'PSCognitiveService/Public/Vision/ConvertTo-Thumbnail.ps1',
        'PSCognitiveService/Public/Vision/Get-ImageAnalysis.ps1',
        'PSCognitiveService/Public/Vision/Get-ImageDescription.ps1',
        'PSCognitiveService/Public/Vision/Get-ImageTag.ps1',
        'PSCognitiveService/Public/Vision/Get-Imagetext.ps1'
    )

    if (-not $InstallDirectory) {
        Write-Verbose "$ModuleName no installation directory provided"

        $PersonalModules = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules

        if (($env:PSModulePath -split ';') -notcontains $PersonalModules) {
            Write-Warning "$ModuleName personal module path '$PersonalModules' not found in '`$env:PSModulePath'"
        }

        if (-not (Test-Path $PersonalModules)) {
            Write-Error "$ModuleName path '$PersonalModules' does not exist"
        }

        $InstallDirectory = Join-Path -Path $PersonalModules -ChildPath $ModuleName
        Write-Verbose "$ModuleName default installation directory is '$InstallDirectory'"
    }

    if (-not (Test-Path $InstallDirectory)) {
        New-Item -Path $InstallDirectory -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\PSCognitiveService\Classes -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\PSCognitiveService\Examples -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\PSCognitiveService\Private -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\PSCognitiveService\Public -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\PSCognitiveService\Public\Face -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\PSCognitiveService\Public\Moderator -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\PSCognitiveService\Public\Vision -ItemType Directory -EA Stop -Verbose | Out-Null
        Write-Verbose "$ModuleName created module folder '$InstallDirectory'"
    }

    $WebClient = New-Object System.Net.WebClient

    $Files | ForEach-Object {
        $File = $installDirectory, '\', $($_ -replace '/', '\') -join ''
        $URL = $GitPath, '/', $_ -join ''
        $WebClient.DownloadFile($URL, $File)
        Write-Verbose "$ModuleName installed module file '$_'"
    }

    Write-Verbose "$ModuleName module installation successful"
#}
#Catch {
#    throw "Failed installing the module in the install directory '$InstallDirectory': $_"
#}
$VerbosePreference = $Pre
