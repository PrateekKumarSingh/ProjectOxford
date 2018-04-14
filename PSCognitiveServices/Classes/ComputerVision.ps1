class ComputerVision {
    [String] $subscription_key
    [System.Uri] $url
    [System.IO.FileInfo] $path
    [string[]] $visual_features 
    
    hidden $base_url = "https://southeastasia.api.cognitive.microsoft.com/vision/v1.0/"
    $analyze_url = $this.base_url + 'analyze'

    # constructor
    ComputerVision([String] $subscription_key) {
        $this.subscription_key = $subscription_key
    }
    
    # .analyze(url, features)
    [System.Object] Analyze([System.Uri] $url, [String[]] $visual_features) {
        $this.url = $url
        $this.visual_features = $visual_features

        $params = @{
                        Uri = $this.analyze_url + '?visualFeatures=' + $($this.visual_features -join ',')
                        Method = 'POST'
                        ContentType = 'application/json'
                        Body = @{'URL' = $this.url} | ConvertTo-Json
                        Headers = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }

        $result = Invoke-RestMethod @params
        return $result
    }
    
    # .analyze(path, features)
    [System.Object] Analyze([System.IO.FileInfo] $path, [String[]] $visual_features) {
        $this.path = $path
        $this.visual_features = $visual_features
        $params = @{
                        Uri = $this.analyze_url + '?visualFeatures=' + $($this.visual_features -join ',')
                        Method = 'POST'
                        InFile = $path
                        ContentType = 'application/octet-stream'
                        Headers = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }

        $result = Invoke-RestMethod @params
        return $result
    }
}

$url = [system.uri]'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J_400x400.jpg'
$path = [System.IO.FileInfo]'C:\Tmp\photo.jpg'
$features = 'description', 'faces', 'categories'
$o = [ComputerVision]::new($key)
$o.Analyze($url, $features)
$o.Analyze($path, $features)
