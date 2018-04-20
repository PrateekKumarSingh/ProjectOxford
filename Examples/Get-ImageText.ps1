# Optical character recognition using a URL
Get-ImageText -URL 'http://quotesnhumor.com/wp-content/uploads/2016/02/Top-25-Believe-Quotes-believe-images.jpg' -Verbose

# Optical character recognition using a path
ocr -Path C:\Tmp\q.jpg -Verbose

# Optical character recognition using computer vision classes and functions
$path = 'C:\tmp\q.jpg'
$url = "http://www.imagesquotes.com/wp-content/uploads/2013/01/inspirational_quotes_motivational.jpg"

# create computer vision object
$Object = [ComputerVision]::new($env:API_SubscriptionKey_vision, $env:API_Location_vision)

# using the OCR(url) method
$Object.OCR([uri]$url)
$Object.result.regions.lines | foreach {$_.words.text -join ' '} # prints result line-wise

# using the OCR(path) method
$Object.OCR([IO.FileInfo]$path)


