$PWD = Get-Location | % Path
# install module
Install-Module PSCognitiveService -Force -Scope CurrentUser -Verbose
# import module
Import-Module PSCognitiveService -Force -Verbose
# get module
Get-Command -Module PSCognitiveService
# create cognitive service accounts in azure
$ResrouceGroup = 'RG1'
'ComputerVision','ContentModerator','Face','TextAnalytics' | ForEach-Object {
    New-CognitiveServiceAccount -AccountType $_ -ResourceGroupName $ResrouceGroup -SKUName F0 -Location centralindia | Out-Null
} 

'Bing.Search.v7','Bing.EntitySearch'| ForEach-Object {
    New-CognitiveServiceAccount -AccountType $_ -ResourceGroupName $ResrouceGroup -SKUName F0 -Location Global | Out-Null
} 

# add subscription key and location from azure to local session \ $profile as environment variable
# login and obtain subscription keys, local config
New-LocalConfiguration -FromAzure -AddKeysToProfile -Verbose | Out-Null
# face features & emotion recognition
Get-Face -Path "$PWD\media\Billgates.jpg" | ForEach-Object faceAttributes |Format-List *
# image analysis
Get-ImageAnalysis -Path "$pwd\media\Billgates.jpg" | ConvertFrom-Json
Get-ImageAnalysis -URL https://goo.gl/Q73Qtw  | ConvertFrom-Json
# image description
Get-ImageDescription -Path "$pwd\media\Billgates.jpg" | ForEach-Object Description | Format-List
# tag image and convert to hashtags
Get-ImageTag -URL https://goo.gl/Q73Qtw | ForEach-Object{$_.tags.name} | ForEach-Object {"#"+$_ -join " "}
# optical character recognition
Get-ImageText -URL https://goo.gl/XyP6LJ | ForEach-Object {$_.regions.lines} |  ForEach-Object { $_.words.text -join " "}
# convert to thumbnail 
ConvertTo-Thumbnail -URL https://goo.gl/XyP6LJ -SmartCropping
# bing search
Search-Web "powershell 7" -c 130 |ForEach-Object {$_.webpages.value} | Format-List name, url, snippet
Search-Entity -Text "brad pitt" | ForEach-Object {$_.entities.value} | Format-List name, description, image, webSearchUrl
# text analytics
Get-Sentiment -Text "I don't write pester tests!" | % { if($_.documents.score -lt 0.5){'negetive'}else{'positive'} }
Get-Sentiment -Text "Hey good morning!","Such a wonderful day","I feel sad about you" |  ForEach-Object documents
Get-KeyPhrase -Text "Hey good morning!","Such a wonderful day","I feel sad about these poor people" | ForEach-Object documents
Trace-Language -Text "Hey good morning!", "Bonjour tout le monde", "La carretera estaba atascada" | ForEach-Object {$_.documents.detectedlanguages}
# moderate content - text, image (path/url)
Test-AdultRacyContent -Text "Hello World" | ForEach-Object Classification # clean
Test-AdultRacyContent -Text "go eff yourself" | ForEach-Object Classification # not good/review required
Test-AdultRacyContent -Path "$pwd\media\test.png"
Test-AdultRacyContent -URL https://goo.gl/uY2PS6
