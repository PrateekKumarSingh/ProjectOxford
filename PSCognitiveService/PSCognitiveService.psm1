#Requires -Version 5.0

[cmdletbinding()]
param() 

$BasePath = $PSScriptRoot

# load assemblies
if ($PSEdition -in $null, 'Desktop') {
    # PowerShell Desktop Edtion
    Add-Type -AssemblyName 'System.Drawing'
}
elseif ($PSEdition -eq 'core') {
    # PowerShell Core Edition(Win,Linux,Mac)
    # pre-installation of libgdiplus is required on linux/mac
    Add-Type -AssemblyName (Join-Path $PSScriptRoot 'lib\CoreCompat.System.Drawing.dll')
}

$DependentModules = 'az.Profile', 'az.CognitiveServices', 'az.Resources'
$installed = Get-Module $DependentModules -ListAvailable | Where-Object { $_.name -In $DependentModules }
$missing = $DependentModules | Where-Object { $_ -notin $installed.name }

if ($missing) {
    Write-Verbose "Module dependencies not found [$Missing]. Attempting to install."
    Install-Module $missing -Force -AllowClobber
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
    . ([IO.Path]::Combine($BasePath, 'Classes', "$item.ps1"))
}

# importing classes sequentially
foreach ($class in $classList) {
    Write-Verbose "Dot sourcing class '$class'"
    . ([IO.Path]::Combine($BasePath, 'Classes', "$class.ps1"))
}


# dot dourcing files
$FolderNames = @(
    'Private',
    'Public'
)

Get-ChildItem $($FolderNames.ForEach( { Join-Path $BasePath $_ })) -Recurse -Filter *.ps1 | ForEach-Object { . $_.FullName }
