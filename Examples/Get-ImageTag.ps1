# get image tags using a path that are relevant to the content of the supplied image
$Path = 'C:\tmp\Bill.jpg'
ConvertTo-Thumbnail -Path $Path

# get image tags using a URL
$URL = 'https://drscdn.500px.org/photo/159533631/m%3D900/v2?webp=true&sig=61eee244d82e8eac7354bf31800c17a8d0627aba1d941f96f5a9e5e4910de693'
Get-ImageTag -URL $url -Verbose

# using alias
tag -URL $URL -Verbose
tag -URL $path -Verbose

# create computer vision object
$Object = [ComputerVision]::new($env:API_SubscriptionKey_vision, $env:API_Location_vision)

# using the tag(url) method
$Object.tag([uri]$url)
$Object.result.tags.name | foreach {'#'+$_} # prints hashtags

# using the tag(path) method
$Object.tag([IO.FileInfo]$path)



