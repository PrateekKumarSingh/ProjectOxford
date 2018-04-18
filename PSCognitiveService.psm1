using assembly System.Drawing
[cmdletbinding()]
param()

# define class sequence
$classList = @(
    'Enum',
    'ValidateFile',
    'ValidateImage',
    'ComputerVision'
)

# importing classes sequentially
foreach ($class in $classList) {
    Write-Verbose "Class '$class'" -Verbose
    . "$psscriptroot\classes\$class.ps1"
}

# dot dourcing files
Get-ChildItem $PSScriptRoot\private\ -Recurse  | Where-Object {$_.Extension -eq '.ps1' -and $_.Directory -notlike '*x'} | ForEach-Object {. $_.FullName}
Get-ChildItem $PSScriptRoot\public\ -Recurse  | Where-Object {$_.Extension -eq '.ps1' -and $_.Directory -notlike '*x'} | ForEach-Object {. $_.FullName }

