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
$Images = Get-ChildItem C:\Temp\ | ForEach-Object FullName
# get image analysis using ComputerVision Cognitive Service and rename files
$Images | ForEach-Object {
    $Result = (Get-ImageAnalysis -path $_)
    $NewName = $Result.description.captions.text
    # use tags as name if captions are not returned
    if(!$NewName){$NewName = $Result.description.tags -join ' '}
    Rename-Item -Path $_ -NewName $NewName -Verbose
}
