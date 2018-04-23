using assembly System.Drawing
[cmdletbinding()]
param()

$BasePath = 'C:\Data\Powershell\repository\PSCognitiveService'

# define class sequence
$classList = @(
    'Enum',
    'ValidateFile',
    'ValidateImage',
    'ComputerVision',
    'Face',
    'ContentModerator'
)

# importing classes sequentially
#foreach ($class in $classList) {
#    Write-Verbose "Dot sourcing class '$class'" -Verbose
#    . "$BasePath\classes\$class.ps1"
#}

# importing classes sequentially
foreach ($class in $classList) {
    Import-Module "$BasePath\classes\$class.ps1"
}

# dot dourcing files
$FolderNames = @(
    'Private',
    'Public'
)

Get-ChildItem $($FolderNames.ForEach({"$BasePath\$_\"})) -Recurse -Filter *.ps1 | ForEach-Object {. $_.FullName}
