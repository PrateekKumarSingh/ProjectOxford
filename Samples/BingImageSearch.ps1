# install module
Install-Module PSCognitiveService -Force -Scope CurrentUser -Verbose
# import module
Import-Module PSCognitiveService -Force -Verbose
# get module
Get-Command -Module PSCognitiveService
# login and obtain subscription keys, local config
New-LocalConfiguration -FromAzure -AddKeysToProfile -Verbose | Out-Null
