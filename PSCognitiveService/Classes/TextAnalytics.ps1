class TextAnalytics {
    # properties
    [String] $subscription_key
    [String] $location
    [String] $query
    [psobject] $result
    hidden $base_url 
    [String] $endpoint

    # constructor
    TextAnalytics([String] $subscription_key, [Location] $location) {
        $this.subscription_key = $subscription_key
        $this.location = $location
        $this.base_url = "https://{0}.api.cognitive.microsoft.com/text/analytics/v2.0/" -f $this.location 
    }

    #region methods 
    # detectLanguage(string[] text)
    [System.Object] detectLanguage([System.String[]] $text) {
        $Service = 'languages'
        $this.endpoint = $this.base_url + $Service

        $data = for ($counter = 0; $counter -lt $text.Count; $counter++) { @{id = $counter+1;text = $text[$counter]}}
        $request = @{documents = @($data)} | ConvertTo-Json

        $params = @{
            Uri         = $this.endpoint
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = $request
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }
    # detectLanguage(string[] text)
    [System.Object] getKeyPhrase([System.String[]]  $text) {
        $Service = 'keyPhrases'
        $this.endpoint = $this.base_url + $Service

        $data = for ($counter = 0; $counter -lt $text.Count; $counter++) { @{id = $counter+1;text = $text[$counter]}}
        $request = @{documents = @($data)} | ConvertTo-Json

        $params = @{
            Uri         = $this.endpoint
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = $request
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }

    [System.Object] getSentiment([System.String[]]  $text) {
        $Service = 'sentiment'
        $this.endpoint = $this.base_url + $Service

        $data = for ($counter = 0; $counter -lt $text.Count ; $counter++) { @{id = $counter+1;text = $text[$counter]}}
        $request = @{documents = @($data)} | ConvertTo-Json

        $params = @{
            Uri         = $this.endpoint
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = $request
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }
    #endregion methods    
}

