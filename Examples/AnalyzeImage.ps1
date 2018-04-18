New-LocalConfiguration -FromAzure -verbose

$path = 'C:\tmp\Bill.jpg'
# by default chooses all visual features and details in the image
Get-ImageAnalysis -path $path

# selective visual features and details in the image
$visual_features = [enum]::GetNames([visualFeatures])
$details = [enum]::GetNames([details])
Get-ImageAnalysis -path $path -VisualFeatures $visual_features -Details $details

# help information
Get-Help analyze


# using computer vision classes and functions
$url = "https://upload.wikimedia.org/wikipedia/commons/d/d9/Bill_gates_portrait.jpg"

# create computer vision object
$Object = [ComputerVision]::new($env:API_SubscriptionKey_vision, $env:API_Location_vision)

# analyze image
$Object.analyze([uri]$url)
$Object.analyze([IO.FileInfo]$path)

# analyze image with visual features and details
$Object.analyze($url, $visual_features, $details)
$Object.analyze($path, $visual_features, $details)
