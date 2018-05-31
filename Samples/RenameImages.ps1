# install module
Install-Module PSCognitiveService -Force -Scope CurrentUser -Verbose
# import module
Import-Module PSCognitiveService -Force -Verbose
# get module
Get-Command -Module PSCognitiveService
# create new cognitive subscription in AzureRM
New-CognitiveServiceAccount -AccountType ComputerVision -Verbose
# login and obtain subscription keys, local config
New-LocalConfiguration -FromAzure -AddKeysToProfile -Verbose | Out-Null
# collect target file paths
$Images = Get-ChildItem C:\Temp\ | % FullName
# get image descripton using ComputerVision cognitive service and rename files
$Images | ForEach-Object {
    $NewName = (Get-ImageAnalysis -path $_).description.captions.text
    Rename-Item -Path $_ -NewName $NewName -Verbose
}

