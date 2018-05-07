# install module
Install-Module PSCognitiveService -Force -Scope CurrentUser -Verbose
# import module
Import-Module PSCognitiveService -Force -Verbose
# get module
Get-Command -Module PSCognitiveService
# login and obtain subscription keys, local config
New-LocalConfiguration -FromAzure -AddKeysToProfile | Out-Null
# face features & emotion recognitionc
Get-Face -Path 'C:\tmp\Bill.jpg' |Format-List *
# image analysis
Get-ImageAnalysis -Path 'C:\tmp\Bill.jpg'
# image description
Get-ImageDescription -Path 'C:\tmp\Bill.jpg' | ForEach-Object Description | Format-List
# tag image and convert to hashtags
Get-ImageTag -URL https://goo.gl/Q73Qtw | ForEach-Object{$_.tags.name} | ForEach-Object {'#'+$_ -join ' '}
# optical character recognition
Get-ImageText -URL https://goo.gl/XyP6LJ | ForEach-Object {$_.regions.lines.words.text -join ' '}
# convert to thumbnail
ConvertTo-Thumbnail -URL https://goo.gl/XyP6LJ -SmartCropping
# bing search
Search-Web 'powershell 6.1' -c 3 |ForEach-Object {$_.webpages.value} | Format-List name, url, snippet
Search-Entity -Text 'brad pitt' | ForEach-Object {$_.entities.value} | Format-List name, description, image, webSearchUrl
# text analytics
Get-Sentiment -Text "Hey good morning!","Such a wonderful day","I feel sad about you" |  ForEach-Object documents
Get-KeyPhrase -Text "Hey good morning!","Such a wonderful day","I feel sad about these poor people" | ForEach-Object documents
Trace-Language -Text "Hey good morning!", "Bonjour tout le monde", "La carretera estaba atascada" | ForEach-Object {$_.documents.detectedlanguages}
# moderate content - text, image (path/url)
Test-AdultRacyContent -Text "Hello World" | ForEach-Object Classification # clean
Test-AdultRacyContent -Text "go eff yourself" | ForEach-Object Classification # not good/review required
Test-AdultRacyContent -Path 'C:\Tmp\test.png'
Test-AdultRacyContent -URL https://goo.gl/uY2PS6
