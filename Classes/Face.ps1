class Face {
    # properties
    [String] $subscription_key
    [String] $location
    [String] $query
    [psobject] $result
    hidden $base_url 
    [String] $endpoint

    # constructor
    Face([String] $subscription_key, [Location] $location) {
        $this.subscription_key = $subscription_key
        $this.location = $location
        $this.base_url = "https://{0}.api.cognitive.microsoft.com/face/v1.0/" -f $this.location 
    }

    #region detect-overload-methods 
    # methods  
    # detect(url)
    [System.Object] detect([System.Uri] $url) {
        $Service = 'detect'
        $this.endpoint = $this.base_url + $Service
        $this.query = '?returnFaceId=true&returnFaceLandmarks=true&returnFaceAttributes=age,gender' # default faceattributes are age and gender
        $params = @{
            Uri         = $this.endpoint + $this.query
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = @{'URL' = $url} | ConvertTo-Json
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }
    
    # detect(url, face_attributes, faceid, facelandmarks)
    [System.Object] detect([System.Uri] $url, [FaceAttributes[]] $Face_Attributes, [bool] $FaceId, [bool] $FaceLandmarks) {
        $Service = 'detect'
        $this.endpoint = $this.base_url + $Service
        $this.query = '?returnFaceId={0}&returnFaceLandmarks={1}&returnFaceAttributes={2}' -f $FaceId, $FaceLandmarks, $($Face_Attributes -join ',')
        $params = @{
            Uri         = $this.endpoint + $this.query
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = @{'URL' = $url} | ConvertTo-Json
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }

    # detect(path)
    [System.Object] detect([System.IO.FileInfo] $path) {
        $Service = 'detect'
        $this.endpoint = $this.base_url + $Service        
        $this.query = '?returnFaceId=true&returnFaceLandmarks=true&returnFaceAttributes=age,gender' # default faceattributes are age and gender
        $params = @{        
            Uri         = $this.endpoint + $this.query
            Method      = 'POST'
            InFile      = $path
            ContentType = 'application/octet-stream'
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }

    # detect(path, face_attributes, faceid, facelandmarks)
    [System.Object] detect([System.IO.FileInfo] $path, [FaceAttributes[]] $Face_Attributes, [bool] $FaceId, [bool] $FaceLandmarks) {
        $Service = 'detect'
        $this.endpoint = $this.base_url + $Service        
        $this.query = '?returnFaceId={0}&returnFaceLandmarks={1}&returnFaceAttributes={2}' -f $FaceId, $FaceLandmarks, $($Face_Attributes -join ',')
        $params = @{        
            Uri         = $this.endpoint + $this.query
            Method      = 'POST'
            InFile      = $path
            ContentType = 'application/octet-stream'
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }
    #endregion analyze-overload-methods    
}




# detect face using detect(path)
$object = [Face]::new($env:API_SubscriptionKey_face, $env:API_Location_face)
$path = [System.IO.FileInfo] 'C:\Tmp\Bill.jpg'
$object.detect($path)
$object.result.facerectangle
$object.result.facelandmarks

# detect face  using detect(url)
$object = [Face]::new($env:API_SubscriptionKey_face, $env:API_Location_face)
$url = [uri] 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'
$object.detect($url)

# using detect(path, Face_Attributes, FaceID, FaceLandmarks)
$object = [Face]::new($env:API_SubscriptionKey_face, $env:API_Location_face)
$path = [System.IO.FileInfo] 'C:\Tmp\Bill.jpg'
$Face_Attributes = [enum]::GetNames([FaceAttributes])
$object.detect($path, $Face_Attributes, $true, $true)
$object.result.faceattributes.facialHair

# using detect(url, Face_Attributes, FaceID, FaceLandmarks)
$object = [Face]::new($env:API_SubscriptionKey_face, $env:API_Location_face)
$url = [uri] 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'
$Face_Attributes = [enum]::GetNames([FaceAttributes])
$object.detect($url, $Face_Attributes, $true, $true)
$object.result.faceattributes





