class ComputerVision {
    # properties
    [String] $subscription_key
    [String] $location
    [String] $query
    [psobject] $result
    hidden $base_url 
    [String] $endpoint


    # constructor
    ComputerVision([String] $subscription_key, [Location] $location) {
        $this.subscription_key = $subscription_key
        $this.location = $location
        $this.base_url = "https://{0}.api.cognitive.microsoft.com/vision/v1.0/" -f $this.location
    }

#region analyze-overload-methods 
    # methods  
    # analyze(url)
    [System.Object] analyze([System.Uri] $url) {
        $Service = 'analyze'
        $this.endpoint = $this.base_url + $Service
        $this.query = '?visualFeatures=categories'
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

    # analyze(url, visual_features, details)
    [System.Object] analyze([System.Uri] $url, [VisualFeatures[]] $visual_features, [Details[]] $details) {
        $Service = 'analyze'
        $this.endpoint = $this.base_url + $Service
        $this.query ='?visualFeatures={0}&details={1}' -f $($visual_features -join ',') , $($details -join ',')
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

    # analyze(path)
    [System.Object] analyze([System.IO.FileInfo] $path) {
        $Service = 'analyze'
        $this.endpoint = $this.base_url + $Service        
        $this.query = '?visualFeatures=categories'
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

    # analyze(path, visual_features, details)
    [System.Object] analyze([System.IO.FileInfo] $path, [VisualFeatures[]] $visual_features, [Details[]] $details) {
        $Service = 'analyze'
        $this.endpoint = $this.base_url + $Service        
        $this.query = '?visualFeatures={0}&details={1}' -f $($visual_features -join ',') , $($details -join ',')    
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
    
#region describe-overload-methods
    # describe(url)
    [System.Object] describe([System.Uri] $url) {
        $Service = 'describe'
        $this.endpoint = $this.base_url + $Service
        $this.query = '?maxCandidates=1'
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

    # describe(url, MaxCandidates)
    [System.Object] describe([System.Uri] $url, [Int] $MaxCandidates) {
        $Service = 'describe'
        $this.endpoint = $this.base_url + $Service
        $this.query = '?maxCandidates={0}' -f $MaxCandidates
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

    # describe(path)
    [System.Object] describe([System.IO.FileInfo] $path) {
        $Service = 'describe'
        $this.endpoint = $this.base_url + $Service        
        $this.query = '?maxCandidates=1' 
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

    # describe(path, MaxCandidates)
    [System.Object] describe([System.IO.FileInfo] $path, [int] $MaxCandidates) {
        $Service = 'describe'
        $this.endpoint = $this.base_url + $Service        
        $this.query = '?maxCandidates={0}' -f $MaxCandidates   
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
    
#endregion describe-overload-methods

#region toThumbnail-overload-methods    
    # ToThumbnail(url, outputFile, width, height, smartCropping)
    [System.Object] toThumbnail([System.Uri] $url, [System.IO.FileInfo] $outputFile, [int] $width, [int] $height, [bool] $smartCropping) {
        $Service = 'generateThumbnail'
        $this.endpoint = $this.base_url + $Service        
        $this.query = '?width={0}&height={1}&smartCropping={2}' -f $width, $height, $smartCropping
        $params = @{        
        Uri         = $this.endpoint + $this.query
        Method      = 'POST'
        ContentType = 'application/json'
        Body        = @{'URL' = $url} | ConvertTo-Json
        Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
    
        $bytes = [byte[]] $(Invoke-RestMethod @params).ToCharArray()
        [IO.File]::WriteAllBytes($OutputFile,$bytes)
        $this.result = @{
            Width = $width
            Height = $height
            OutputFile = $outputFile
            ByteArray = $bytes
            smartCropping = $true
        }
        return $this.result
    }

    # toThumbnail(path outputFile, width, height, smartCropping)
    [System.Object] toThumbnail([System.IO.FileInfo] $path, [System.IO.FileInfo] $outputFile, [int] $width, [int] $height, [bool] $smartCropping) {
        $Service = 'generateThumbnail'
        $this.endpoint = $this.base_url + $Service        
        $this.query = '?width={0}&height={1}&smartCropping={2}' -f $width, $height, $smartCropping
        $params = @{        
        Uri         = $this.endpoint + $this.query
        Method      = 'POST'
        InFile      = $path
        ContentType = 'application/octet-stream'
        Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
    
        $bytes = [byte[]] $(Invoke-RestMethod @params).ToCharArray()
        [IO.File]::WriteAllBytes($OutputFile,$bytes)
        $this.result = @{
            Width = $width
            Height = $height
            OutputFile = $outputFile
            ByteArray = $bytes
            smartCropping = $true
        }
        return $this.result
    }
#endregion toThumbnail-overload-methods    

#region ocr-overload-methods
    # OCR(url)
    [System.Object] OCR([System.Uri] $url) {
        $Service = 'ocr'
        $this.endpoint = $this.base_url + $Service        
        $this.query = '?language=unk&&detectOrientation=true'
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

    # OCR(path)
    [System.Object] OCR([System.IO.FileInfo] $path) {    
        $Service = 'ocr'
        $this.endpoint = $this.base_url + $Service        
        $this.query = '?language=unk&&detectOrientation=true'
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
#endregion ocr-overload-methods

#region tag-overload-methods
    # tag(url)
    [System.Object] tag([System.Uri] $url) {    
        $Service = 'tag'
        $this.endpoint = $this.base_url + $Service        
        $params = @{        
            Uri         = $this.endpoint
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = @{'URL' = $url} | ConvertTo-Json
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
    
        $this.result = Invoke-RestMethod @params
        return $this.result
    }  

    # tag(path)
    [System.Object] tag([System.IO.FileInfo] $path) {    
        $Service = 'tag'
        $this.endpoint = $this.base_url + $Service        
        $params = @{        
            Uri         = $this.endpoint
            Method      = 'POST'
            InFile      = $path
            ContentType = 'application/octet-stream'
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
    
        $this.result = Invoke-RestMethod @params
        return $this.result
    }  
#endregion tag-overload-methods

}

$visual_features = [enum]::GetNames([visualFeatures])
$details = [enum]::GetNames([details])

$url = [system.uri] "https://upload.wikimedia.org/wikipedia/commons/d/d9/Bill_gates_portrait.jpg"
$path = [System.IO.FileInfo]'C:\Tmp\bill.jpg'

# create computer vision object
$Object = [ComputerVision]::new($key,'SouthEastAsia')
$o = new-object ComputerVision($key,'SouthEastAsia')

# analyze image
$Object.analyze($url)
$Object.analyze($path)

# analyze image with visual features and details
$Object.analyze($url, $visual_features, $details)
$Object.analyze($path, $visual_features, $details)

# describe image
$Object.describe($path)

# describe image with 5 candidates
$Object.describe($path,5)

# get 50x50 thumbnail
$Object.ToThumbnail($path,'c:\tmp\unsmart.jpg',50,50,$false)

# get 50x50 thumbnail with smart cropping
$Object.ToThumbnail($url,'c:\tmp\smart.jpg',50,50,$true)

# Optical Character recognition from URL
[System.Uri] $quoteURL = 'https://www.brainyquote.com/photos_tr/en/h/helenkeller/101301/helenkeller1-2x.jpg'
$Object.OCR($quoteURL)

# Optical Character recognition from file
[System.IO.FileInfo] $quotepath = 'C:\tmp\quotes.jpg'
$Object.OCR($quotePath)
$Object.result.regions.lines | foreach{ $_.words.text -join " " }


# tag image from url
$Object.tag($URL) > null
$Object.result.tags

# tag image from file
$Object.tag($path)
$Object.result.tags



