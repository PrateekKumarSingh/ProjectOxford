Function Set-LocalCognitiveServiceConfiguration {
    [alias("config")]
    [cmdletbinding()]
    param(
        [Parameter(Mandatory, ParameterSetName='Manual')]
        [ValidateNotNullOrEmpty()]
        [String] $SubscriptionKey,
        [Parameter(Mandatory, ParameterSetName='Manual')]
        [Location] $Location,
        [Parameter(Mandatory, ParameterSetName='Manual')]
        [CognitiveService] $ServiceName,
        [Parameter(ParameterSetName='FromAzure')] 
        [switch] $FromAzureRM
    )

    $VerboseEnvVariableSetup = [scriptblock]{
        Write-Verbose "Setting Environment variable: `$env:API_SubscriptionKey_$ServiceName for Cognitive Service: $ServiceName" 
        Set-Item -Path "env:API_SubscriptionKey_$ServiceName" -Value $SubscriptionKey
        Write-Verbose "Setting Environment variable: `$env:API_Location_$ServiceName for Cognitive Service: $ServiceName" 
        Set-Item -Path "env:API_Location_$ServiceName" -Value $Location
    }

    if(Test-AzureRmLogin -verbose){
        Get-AzureRmCognitiveServicesAccount | ForEach-Object {
            $SubscriptionKey = ($_ | Get-AzureRmCognitiveServicesAccountKey).Key1
            $Location        = $_.Location
            $ServiceName     = ([uri]$_.Endpoint).segments[1] -replace "/",""
            $EndPoint        = $_.Endpoint
            
            $data = [System.Object] [Ordered] @{
                SubscriptionKey =   $SubscriptionKey 
                Location        =   $Location       
                ServiceName     =   $ServiceName    
                EndPoint        =   $EndPoint       
            }

            if($data){
                & $VerboseEnvVariableSetup
            }
        }
    }
}

#Set-LocalCognitiveServiceConfiguration -FromAzureRM -verbose
