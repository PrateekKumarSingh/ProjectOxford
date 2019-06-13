$PWD = Get-Location | ForEach-Object Path
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

'Bing.EntitySearch','Bing.Search.v7'| ForEach-Object {
    New-CognitiveServiceAccount -AccountType $_ -ResourceGroupName $ResrouceGroup -SKUName F0 -Location Global | Out-Null
} 

# add subscription key and location from azure to local session \ $profile as environment variable
# login and obtain subscription keys, local config
New-LocalConfiguration -FromAzure -AddKeysToProfile -Verbose | Out-Null

# face features & emotion recognition
Get-Face -Path "$PWD\media\Billgates.jpg" | ForEach-Object faceAttributes |Format-List *

# image analysis
Get-ImageAnalysis -Path "$pwd\media\Billgates.jpg" | ConvertFrom-Json

# image description
Get-ImageDescription -Path "$pwd\media\Billgates.jpg" | ForEach-Object Description | Format-List

# tag image and convert to hashtags
Get-ImageTag -URL https://goo.gl/Q73Qtw | ForEach-Object{$_.tags.name} | ForEach-Object {"#"+$_ -join " "}

# optical character recognition
Get-ImageText -URL https://goo.gl/XyP6LJ | ForEach-Object {$_.regions.lines} |  ForEach-Object { $_.words.text -join " "}

# convert to thumbnail 
ConvertTo-Thumbnail -URL https://goo.gl/XyP6LJ -SmartCropping

# bing search
Search-Web "ransomware wannacry" -c 5 |ForEach-Object {$_.webpages.value} | Format-List name, url, snippet
Search-Entity -Text "brad pitt" | ForEach-Object {$_.entities.value} | Format-List name, description, image, webSearchUrl

# text analytics
Get-Sentiment -Text "Hey good morning!","Such a wonderful day","I feel sad about you" |  ForEach-Object documents
Get-KeyPhrase -Text "Hey good morning!","Such a wonderful day","I feel sad about these poor people" | ForEach-Object documents
Trace-Language -Text "Hey good morning!", "Bonjour tout le monde", "La carretera estaba atascada" | ForEach-Object {$_.documents.detectedlanguages}

# moderate content - text, image (path/url)
Test-AdultRacyContent -Text "Hello World" | ForEach-Object Classification # clean
Test-AdultRacyContent -Text "go eff yourself" | ForEach-Object Classification # not good/review required
Test-AdultRacyContent -Path "$pwd\media\billgates.jpg"
Test-AdultRacyContent -URL https://goo.gl/uY2PS6

$urls = (Invoke-WebRequest ridicurious.com).links.href
$urls | select -Unique | where{$_ -like "http*"} | ForEach-Object { Test-AdultRacyContent -URL $_;Start-Sleep -s 1}

# capturing images from a image search and storing it on a local machine
$images = (Search-Image -Text 'Jeffery Snover' -Count 20 -SafeSearch strict -Verbose).value.contenturl
$images | ForEach-Object {
    try{
        Start-Sleep -s 1
            # analyze image and get a caption
            #$caption = (Get-ImageAnalysis -URL $images[0]).description.captions.text
            # creates a logical file name
            $filename = if($caption){$caption}else{'unnamed'}
            $path = "c:\temp\$filename.jpg"
            $i = 1
            while(Test-Path $path){
                if($filename -like "*(*)*"){
                    $OpenBraces = $filename.IndexOf('(')
                    $filename = $($filename[0..($OpenBraces-1)] -join '') +"($i)"
                }
                else{ $filename = $filename+"($i)" }
                $path = "c:\temp\$filename.jpg"; $i++
            }
            Write-Host "Downloading image as: $path" -ForegroundColor Cyan
            Invoke-WebRequest "$_" -OutFile $path # download the images
    }
    catch{
        $_.exception.message
    }
}