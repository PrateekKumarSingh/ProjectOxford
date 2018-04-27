class Bing {
    # properties
    [String] $subscription_key
    [String] $query
    #[String[]] $response_filter
    [psobject] $result
    hidden $base_url 
    [String] $endpoint
    # constructor
    Search ([String] $subscription_key) {
        $this.subscription_key = $subscription_key
        $this.base_url = "https://api.cognitive.microsoft.com/bing/v7.0/"
    }

    #region methods 
    # Search(string query)
    [System.Object] Search([System.String] $Query) {
        $Service = 'search'
        $this.endpoint = $this.base_url + $Service
        #$this.response_filter = '&responseFilter=' + ($this.response_filter -join ',')
        #$this.query = "?q=$query$($this.response_filter)"
        $this.query = "?q=$query"

        $params = @{
            Uri         = $this.endpoint + $this.query
            Method      = 'GET'
            ContentType = 'application/json'
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params -Verbose
        return $this.result
    }
    # Search(string query, numofresults, offset, market, safesearch)
    [System.Object] Search([System.String] $Query, [int] $NumOfResults, [int] $offset , [String] $mkt, [string] $safesearch) {
        $Service = 'search'
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
        $this.result = Invoke-RestMethod @params -Verbose
        return $this.result
    }
    #endregion methods    
}

#$ob = [Bing]::new($env:API_SubscriptionKey_Bing_Search_v7)
##$ob.response_filter = [ResponseFilters]::Computation
#$ob.Search('ridicurious.com') 
#$ob.result.webPages.value
#$ob.Search('powershell',1, 20 , 'en-CA', [SafeSearch]::off)
#$ob.result.webPages.value
