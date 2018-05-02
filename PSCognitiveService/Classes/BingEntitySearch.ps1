class BingEntitySearch {
    # properties
    [String] $subscription_key
    [String] $query
    #[String[]] $response_filter
    [psobject] $result
    hidden $base_url 
    [String] $endpoint
    # constructor
    BingEntitySearch ([String] $subscription_key) {
        $this.subscription_key = $subscription_key
        $this.base_url = "https://api.cognitive.microsoft.com/bing/v7.0/"
    }

    #region methods 
    # Search(string query, numofresults, offset, market, safesearch)
    [System.Object] Search([System.String] $Query, [int] $NumOfResults, [int] $offset , [String] $mkt, [string] $safesearch) {
        $Service = 'entities'
        $this.endpoint = $this.base_url + $Service
        #$this.response_filter = '&responseFilter=' + ($this.response_filter -join ',')
        #$this.query = "?q=$query&count=$NumOfResults&offset=$offset&mkt=$mkt&safesearch=$safesearch$($this.response_filter)"
        $this.query = "?q=$query&count=$NumOfResults&offset=$offset&mkt=$mkt&safesearch=$safesearch"
        $params = @{
            Uri         = $this.endpoint + $this.query
            Method      = 'GET'
            ContentType = 'application/json'
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }
    #endregion methods    
}

#$ob = [BingEntitySearch]::new($env:API_SubscriptionKey_BingEntitySearch)
#$ob.Search('brad pit',10, 0 , 'en-CA', [SafeSearch]::off)
#$ob.result.entities.value
