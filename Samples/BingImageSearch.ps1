# installation
Install-Module PSCognitiveService -Force -Scope CurrentUser -Verbose
Import-Module PSCognitiveService -Force -Verbose

# create Azure Cognitive Service subscription
New-CognitiveServiceAccount -AccountType Face `
    -ResourceGroupName RG1 -Location southeastasia -SKUName F0 -Verbose | Out-Null
New-CognitiveServiceAccount -AccountType ComputerVision `
    -ResourceGroupName RG1 -Location southeastasia -SKUName F0 -Verbose | Out-Null
# create Azure Cognitive Service subscription with this approach
# when you're unsure of resource groups, price tier and location
New-CognitiveServiceAccount -AccountType Bing.Search.v7 -Verbose

# login and obtain subscription keys, configure them locally
New-LocalConfiguration -FromAzure -AddKeysToProfile -Verbose | Out-Null

# search images on web using 'Bing' API
$images = (Search-Image -Text 'jim carrey' `
                        -Count 20 -SafeSearch strict `
                        -Verbose).value.contenturl

$images | ForEach-Object {
    try{
        # capture emotions each image
        $happiness = (Get-Face -URL $_).faceattributes.emotion.happiness 
        if($happiness -gt .90){ # filter out happy images
            # analyze image and get a caption
            $caption = (Get-ImageAnalysis -URL $_).description.captions.text
            # creates a logical file name
            $filename = if($caption){$caption}else{'unnamed'}
            $path = "c:\temp\$filename.jpg"
            $i = 1
            while(Test-Path $path){
                if($filename -like "*(*)*"){
                    $filename = $($filename[0..$($filename.length-4)] -join '') +"($i)"
                }
                else{ $filename = $filename+"($i)" }
                $path = "c:\temp\$filename.jpg"; $i++
            }
            Write-Host "Downloading image as: $path" -ForegroundColor Cyan
            Invoke-WebRequest "$_" -OutFile $path # download the images
        }
    }
    catch{
        $_.exception.message
    }
}
