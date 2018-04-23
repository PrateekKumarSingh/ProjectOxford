

# convert to thumbnail using a path
$Path = 'C:\tmp\Bill.jpg'
ConvertTo-Thumbnail -Path $Path

# convert to thumbnail using a URL
$URL = 'https://drscdn.500px.org/photo/159533631/m%3D900/v2?webp=true&sig=61eee244d82e8eac7354bf31800c17a8d0627aba1d941f96f5a9e5e4910de693'
ConvertTo-Thumbnail -URL $URL -Width 100 -Height 100 -Verbose -SmartCropping


# convert to thumbnail using a URL with specific dimensions
Thumbnail -URL $URL -OutFile c:\tmp\t.png -Width 100 -Height 100 -Verbose
Thumbnail -URL $URL -OutFile c:\tmp\t.png -Width 100 -Height 100 -Verbose -SmartCropping


# convert to thumbnail using computer vision classes and .toThumbnail() method
$Object = [Vision]::new($env:API_SubscriptionKey_vision, $env:API_Location_vision)

# using URL
$Object.toThumbnail([System.IO.FileInfo] $path, [System.IO.FileInfo] 'c:\tmp\test.png', 200, 200, $true)

# using path
$Object.toThumbnail([System.Uri] $url, [System.IO.FileInfo] 'c:\tmp\test.png', 200, 200, $true)
