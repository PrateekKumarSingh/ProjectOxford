using assembly System.Drawing
using namespace ComputerVision
using namespace Face
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

# function to expose class instances and method overload definitions
# outside the nested PowerShell module
Function New-CognitiveServiceInstance{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('ComputerVision','Face','ContentModerator')] $Name
    )

    switch($Name){
        
        'ComputerVision' {[ComputerVision]::new($env:API_SubscriptionKey_ComputerVision, $env:API_Location_ComputerVision)}
        'Face' {[Face]::new($env:API_SubscriptionKey_Face, $env:API_Location_Face)}
        'ContentModerator' {[face]::new($env:API_SubscriptionKey_ContentModerator, $env:API_Location_ContentModerator)}
    }

}

