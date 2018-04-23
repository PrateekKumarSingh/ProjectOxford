using assembly System.Drawing
using namespace Vision
using namespace Face
[cmdletbinding()]
param()

$BasePath = 'C:\Data\Powershell\repository\PSCognitiveService'

# define class sequence
$classList = @(
    'Enum',
    'ValidateFile',
    'ValidateImage',
    'Vision',
    'Face',
    'Moderate'
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
        [ValidateSet('Vision','Face','Moderate')] $Name
    )

    switch($Name){
        'Vision' {[Vision]::new($env:API_SubscriptionKey_Vision, $env:API_Location_Vision)}
        'Face' {[Face]::new($env:API_SubscriptionKey_Face, $env:API_Location_Face)}
        'Moderate' {[face]::new($env:API_SubscriptionKey_Moderate, $env:API_Location_Moderate)}
    }

}

