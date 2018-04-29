class ContentModerator {
    # properties
    [String] $subscription_key
    [String] $location
    [String] $query
    [psobject] $result
    hidden $base_url 
    [String] $endpoint

    # constructor
    ContentModerator([String] $subscription_key, [Location] $location) {
        $this.subscription_key = $subscription_key
        $this.location = $location
        $this.base_url = "https://{0}.api.cognitive.microsoft.com/contentmoderator/moderate/v1.0/" -f $this.location 
    }

    #region processimage-overload-methods 
    # methods  
    # processimage(url)
    [System.Object] processimage([System.Uri] $url) {     
        $Service = 'processimage'
        $this.endpoint = $this.base_url + $Service
        
        $this.query = '/Evaluate?'
        $params = @{
            Uri         = $this.endpoint + $this.query
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = @{
                            "DataRepresentation" = "URL"
                            "Value" = $url
                            } | ConvertTo-Json
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }
    
    # processimage(url, cachesimage)
    [System.Object] processimage([System.Uri] $url, [bool] $CachesImage) {
        $Service = 'processimage'
        $this.endpoint = $this.base_url + $Service
        $this.query = '/Evaluate?CacheImage={0}' -f $CachesImage
        $params = @{
            Uri         = $this.endpoint + $this.query
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = @{
                            "DataRepresentation" = "URL"
                            "Value" = $url
                            } | ConvertTo-Json
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }

    # processimage(path)
    [System.Object] processimage([System.IO.FileInfo] $path) {
        $Service = 'processimage'
        $this.endpoint = $this.base_url + $Service
        $this.query = '/Evaluate?'
        $params = @{        
            Uri         = $this.endpoint + $this.query
            Method      = 'POST'
            InFile      = $path
            ContentType = 'image/jpeg'
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }

    # processimage(path, cachesimage)
    [System.Object] processimage([System.IO.FileInfo] $path, [bool] $CachesImage) {
        $Service = 'processimage'
        $this.endpoint = $this.base_url + $Service
        $this.query = '/Evaluate?CacheImage={0}' -f $CachesImage
        $params = @{        
            Uri         = $this.endpoint + $this.query
            Method      = 'POST'
            InFile      = $path
            ContentType = 'image/jpeg'
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }
    #endregion processimage-overload-methods    

    #region processtext-overload-methods 
    # methods  
    # processtext(text)
    [System.Object] processtext([System.String] $text) {     
        $Service = 'ProcessText'
        $this.endpoint = $this.base_url + $Service
        $this.query = '/Screen?classify=True'
        $params = @{
            Uri         = $this.endpoint + $this.query
            Method      = 'POST'
            ContentType = 'text/plain'
            Body        = $text
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }
    
    # processtext(text, autocorrect, personalIdentifiableInfo, listId, classify, language)
    [System.Object] processtext([System.String] $text, [bool] $autocorrect, [bool] $personalIdentifiableInfo, [System.String] $listId, [string] $language) {
        $Service = 'processtext'
        $this.endpoint = $this.base_url + $Service
        $this.query = '/Screen?autocorrect={0}&PII={1}&listI={2}&classify=True&languge={3}' -f $autocorrect, $personalIdentifiableInfo, $listId, $language
        $params = @{
            Uri         = $this.endpoint + $this.query
            Method      = 'POST'
            ContentType = 'text/plain'
            Body        = $text
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }
    #endregion processtext-overload-methods  

}
