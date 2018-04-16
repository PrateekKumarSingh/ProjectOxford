class ComputerVision {
    # properties
    [String] $subscription_key
    [String] $query
    [psobject] $result
    hidden $base_url = "https://southeastasia.api.cognitive.microsoft.com/vision/v1.0/"
    [String] $endpoint

    # constructor
    ComputerVision([String] $subscription_key) {
        $this.subscription_key = $subscription_key
    }   

    # methods  
    # analyze(url)
    [System.Object] Analyze([System.Uri] $url, [VisualFeatures[]] $visual_features, [Details[]] $details) {
        $Service = 'analyze'
        $this.endpoint = $this.base_url + $Service

        if ($visual_features -and !$details) {
            $this.query = '?visualFeatures={0}' -f $($visual_features -join ',')
        }
        elseif ($visual_features -and $details) {
            $this.query ='?visualFeatures={0}&details={1}' -f $($visual_features -join ',') , $($details -join ',')
        }
        else{
            $this.query = '?visualFeatures=categories'
        }

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
    [System.Object] Analyze([System.Uri] $url, [VisualFeatures[]] $visual_features, [Details[]] $details) {
        $Service = 'analyze'
        $this.endpoint = $this.base_url + $Service

        if ($visual_features -and !$details) {
            $this.query = '?visualFeatures={0}' -f $($visual_features -join ',')
        }
        elseif ($visual_features -and $details) {
            $this.query ='?visualFeatures={0}&details={1}' -f $($visual_features -join ',') , $($details -join ',')
        }
        else{
            $this.query = '?visualFeatures=categories'
        }

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
    # analyze(url)
    [System.Object] Analyze([System.Uri] $url, [VisualFeatures[]] $visual_features) {
        $Service = 'analyze'
        $this.endpoint = $this.base_url + $Service
        $this.query = '?visualFeatures={0}' -f $($visual_features -join ',')
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
    # analyze(url)
    [System.Object] Analyze([System.Uri] $url, [VisualFeatures[]] $visual_features, [Details[]] $details) {
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
    [System.Object] Analyze([System.IO.FileInfo] $path, [VisualFeatures[]] $visual_features, [Details[]] $details) {
        $Service = 'analyze'
        $this.endpoint = $this.base_url + $Service        

        if ($visual_features -and !$details) {
            $this.query = '?visualFeatures={0}' -f $($visual_features -join ',')
        }
        elseif ($visual_features -and $details) {
            $this.query = '?visualFeatures={0}&details={1}' -f $($visual_features -join ',') , $($details -join ',')
        }
        else {
            $this.query = '?visualFeatures=categories'
        }        
        
        $params = @{        
            Uri         = $this.endpoint + $this.query
            Method      = 'POST'
            InFile      = $path
            ContentType = 'application/octet-stream'
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params -Verbose
        return $this.result
    }
}

$url = [system.uri] "https://upload.wikimedia.org/wikipedia/commons/d/d9/Bill_gates_portrait.jpg"
$path = [System.IO.FileInfo]'C:\Tmp\photo.jpg'
$Object = [ComputerVision]::new($key)
$visual_features = [enum]::GetNames([visualFeatures])
$details = [enum]::GetNames([details])
$Object.Analyze($url, $visual_features, $details)
$Object.Analyze($path)


class a {

    [int] $one
    [int] $two

    test() {

        Write-Host "from function test class A" $this.one $this.two
    }


}

class b : a {
    [string] $str1
    [string] $str2

    aoooo() {
        Write-Host "from function test class A str1" $this.str1 $this.str2
    }

}

[a.b]test2
