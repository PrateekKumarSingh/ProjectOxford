# detect face using a local image
$path = 'C:\tmp\Bill.jpg'
Get-Face -Path $path -FaceId -FaceLandmarks 
Get-Face -Path $path -FaceId -FaceLandmarks -FaceAttributes age, gender |fl *

# detect face using [face] object and detect(path) method
$object = [Face]::new($env:API_SubscriptionKey_face, $env:API_Location_face)
$path = [System.IO.FileInfo] 'C:\Tmp\Bill.jpg'
$object.detect($path)
$object.result.facerectangle
$object.result.facelandmarks

# detect face using [face] object and detect(path, Face_Attributes, FaceID, FaceLandmarks) method
$object = [Face]::new($env:API_SubscriptionKey_face, $env:API_Location_face)
$path = [System.IO.FileInfo] 'C:\Tmp\Bill.jpg'
$Face_Attributes = [enum]::GetNames([FaceAttributes])
$object.detect($path, $Face_Attributes, $true, $true)
$object.result.faceattributes.facialHair

# detect face using a url
$Url = 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'
Get-Face -URL $url -FaceId -FaceLandmarks -Verbose
Get-Face -URL $url -FaceId -FaceLandmarks -FaceAttributes age, gender -Verbose |fl *

# detect face using [face] object and detect(url) method
$object = [Face]::new($env:API_SubscriptionKey_face, $env:API_Location_face)
$url = [uri] 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'
$object.detect($url)


# detect face using [face] object and detect(url, Face_Attributes, FaceID, FaceLandmarks) method
$object = [Face]::new($env:API_SubscriptionKey_face, $env:API_Location_face)
$url = [uri] 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'
$Face_Attributes = [enum]::GetNames([FaceAttributes])
$object.detect($url, $Face_Attributes, $true, $true)
$object.result.faceattributes
