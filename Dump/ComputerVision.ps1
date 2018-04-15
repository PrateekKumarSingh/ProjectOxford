class ComputerVision {
    # properties
    [String] $subscription_key
    [System.Uri] $url
    [System.IO.FileInfo] $path
    [string[]] $visual_features = 'categories'
    [string[]] $details
    [String] $query
    [psobject] $result
    hidden $base_url = "https://southeastasia.api.cognitive.microsoft.com/vision/v1.0/"
    $endpoint = $this.base_url + 'analyze'

    # constructor
    ComputerVision([String] $subscription_key, [Location] $location) {
        $this.subscription_key = $subscription_key
    }   

    # methods  
    # analyze(url)
    [System.Object] Analyze([System.Uri] $url) {

        $this.url = $url
        if($this.visual_features -and !$this.details){
            $this.query = '?visualFeatures={0}' -f $($this.visual_features -join ',')
        }
        elseif ($this.visual_features -and $this.details) {
            $this.query = '?visualFeatures={0}&details={1}' -f $($this.visual_features -join ',') , $($this.details -join ',')
        }

        $params = @{
            Uri         = $this.endpoint + $this.query
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = @{'URL' = $this.url} | ConvertTo-Json
            Headers     = @{'Ocp-Apim-Subscription-Key' = $this.subscription_key}
        }
        $this.result = Invoke-RestMethod @params
        return $this.result
    }

    # analyze(path)
    [System.Object] Analyze([System.IO.FileInfo] $path) {
        $this.path = $path
        if ($this.visual_features -and !$this.details) {
            $this.query = '?visualFeatures={0}' -f $($this.visual_features -join ',')
        }
        elseif ($this.visual_features -and $this.details) {
            $this.query = '?visualFeatures={0}&details={1}' -f $($this.visual_features -join ',') , $($this.details -join ',')
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
$Object.visual_features = [enum]::GetNames([visualFeatures])
$Object.details = [enum]::GetNames([details])
$Object.Analyze($url)
$Object.Analyze($path)


class a{

[int] $one
[int] $two

test(){

        Write-Host "from function test class A" $this.one $this.two
}


}

class b : a {
    [string] $str1
    [string] $str2

    aoooo(){
        Write-Host "from function test class A str1" $this.str1 $this.str2
    }

}

[a.b]
