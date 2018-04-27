using assembly System.Drawing
[cmdletbinding()]
param()

$BasePath = $PSScriptRoot

# define class sequence
$classList = @(
    'Enum',
    'ValidateFile',
    'ValidateImage',
    'ValidateMarket',
    'Vision',
    'Face',
    'Moderate',
    'Analytics',
    'Bing'
)

# importing classes sequentially
foreach ($class in $classList) {
    Write-Verbose "Dot sourcing class '$class'" -Verbose
    . "$BasePath\classes\$class.ps1"
}


# dot dourcing files
$FolderNames = @(
    'Private',
    'Public'
)

Get-ChildItem $($FolderNames.ForEach({"$BasePath\$_\"})) -Recurse -Filter *.ps1 | ForEach-Object {. $_.FullName}
