Function Set-ComputerVisionConfig{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $SubscriptionKey,
        [Parameter(Mandatory)] [Location] $Location
    )

    Write-Verbose "Setting Environment variables"
    $env:API_SubscriptionKey_Vision = $SubscriptionKey
    $env:API_Location_Vision = $Location
    [System.Object] [Ordered] @{
        SubscriptionKey = $SubscriptionKey
        Location        = $Location
        Endpoint        = "https://$Location.api.cognitive.microsoft.com/Vision/v1.0/"
    }
}

Set-ComputerVisionConfig -SubscriptionKey 'bd59f063c3a5437c96377c7684a0aaad' -Location southeastasia -verbose

Function Get-ImageAnalysis{
    [alias("analyze")]
    [cmdletbinding()]
    param(
        [ValidateScript({ 
                [ValidateFile]::Size([ValidateFile]::Extension([ValidateFile]::Path($_) , [enum]::getnames([Extensions])) , 4)
            })]
        [System.IO.FileInfo] $Path,
        [Features[]] $VisualFeatures,
        [Details[]] $Details
    )

    $Object = [ComputerVision]::new($env:API_SubscriptionKey_Vision, $env:API_Location_Vision)
    $Object.analyze($path)
}

$path =  'C:\tmp\Bill.jpg'
Get-ImageAnalysis 
man analyze


$visual_features = [enum]::GetNames([visualFeatures])
$details = [enum]::GetNames([details])

$url = [system.uri] "https://upload.wikimedia.org/wikipedia/commons/d/d9/Bill_gates_portrait.jpg"
$path = [System.IO.FileInfo]'C:\Tmp\bill.jpg'

# create computer vision object
$Object = [ComputerVision]::new($key, 'SouthEastAsia')
$o = new-object ComputerVision($key, 'SouthEastAsia')

# analyze image
$Object.analyze($url)
$Object.analyze($path)

# analyze image with visual features and details
$Object.analyze($url, $visual_features, $details)
$Object.analyze($path, $visual_features, $details)
