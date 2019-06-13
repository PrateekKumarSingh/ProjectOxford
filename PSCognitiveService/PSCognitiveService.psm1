#Requires -Version 5.0

[cmdletbinding()]
param() 

$BasePath = $PSScriptRoot

# load assemblies
if ($PSEdition -in $null,'Desktop') {
    # PowerShell Desktop Edtion
    Add-Type -AssemblyName 'System.Drawing'
    #Install-Module AzureRM.Profile, AzureRM.CognitiveServices, AzureRM.Resources -Force -Scope CurrentUser -Verbose
    Import-Module AzureRM.Profile, AzureRM.CognitiveServices, AzureRM.Resources -Verbose
}
elseif ($PSEdition -eq 'core') {
    # PowerShell Core Edition(Win,Linux,Mac)
    # pre-installation of libgdiplus is required on linux/mac
    Add-Type -AssemblyName (Join-Path $PSScriptRoot 'lib\CoreCompat.System.Drawing.dll')
    #Install-Module AzureRM.Profile.NetCore, AzureRM.CognitiveServices.NetCore, AzureRM.Resources.NetCore -Force -Scope CurrentUser -Verbose
    Import-Module AzureRM.Profile.NetCore, AzureRM.CognitiveServices.NetCore, AzureRM.Resources.NetCore
}

$dependencies = @(
    'Enum',
    'HashTable'
)

# define class sequence
$classList = @(
    'ValidateFile',
    'ValidateImage',
    'ValidateMarket',
    'ComputerVision',
    'Face',
    'TextAnalytics',
    'ContentModerator',
    'BingSearchV7',
    'BingEntitySearch',
    'BingImageSearch'
)

# importing enumerators and hashtables sequentially
foreach ($item in $dependencies) {
    Write-Verbose "Dot sourcing '$item.ps1'" 
    . "$BasePath\classes\$item.ps1"
}

# importing classes sequentially
foreach ($class in $classList) {
    Write-Verbose "Dot sourcing class '$class'"
    . "$BasePath\classes\$class.ps1"
}


# dot dourcing files
$FolderNames = @(
    'Private',
    'Public'
)

Get-ChildItem $($FolderNames.ForEach({"$BasePath\$_\"})) -Recurse -Filter *.ps1 | ForEach-Object {. $_.FullName}
