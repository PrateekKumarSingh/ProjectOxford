class Analytics {
    # properties
    [String] $subscription_key
    [String] $location
    [String] $query
    [psobject] $result
    hidden $base_url 
    [String] $endpoint

    # constructor
    Analytics([String] $subscription_key, [Location] $location) {
        $this.subscription_key = $subscription_key
        $this.location = $location
        $this.base_url = "https://{0}.api.cognitive.microsoft.com/text/analytics/v2.0/" -f $this.location 
    }

    #region detect-overload-methods 
    # methods  
    # detect(url)
    [System.Object] detectLanguage([System.String[]] $text) {
        $Service = 'languages'
        $this.endpoint = $this.base_url + $Service

        $data = for ($counter = 1; $counter -le $text.Length; $counter++) { @{id = $counter;text = $text[$counter]}}
        $request = @{documents = $data} | ConvertTo-Json

        $params = @{
            Uri         = $this.endpoint
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = $request
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params -Verbose
        return $this.result
    }
    #endregion detect-overload-methods    
}

$o = [Analytics]::new($env:API_SubscriptionKey_text, $env:API_Location_text)  
$o.detectLanguage($text)
