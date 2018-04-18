Function New-LocalConfiguration {
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
        [switch] $FromAzure
    )

    $VerboseEnvVariableSetup = [scriptblock]{
        Write-Verbose "Setting Environment variable: `$env:API_SubscriptionKey_$ServiceName for Cognitive Service: $ServiceName" 
        Set-Item -Path "env:API_SubscriptionKey_$ServiceName" -Value $SubscriptionKey
        Write-Verbose "Setting Environment variable: `$env:API_Location_$ServiceName for Cognitive Service: $ServiceName" 
        Set-Item -Path "env:API_Location_$ServiceName" -Value $Location
    }
    
    if($FromAzure){
        if(Test-AzureRmLogin -verbose){
            Write-Verbose "Fetching AzureRM Cognitive Service accounts" 
            $Accounts = Get-AzureRmCognitiveServicesAccount 
            Write-Verbose $("{0} Service found in AzureRM" -f $Accounts.Count)
            $Accounts | ForEach-Object {
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
                    $data
                }
            }
        }
    }
    else{
            $data = [System.Object] [Ordered] @{
                SubscriptionKey =   $SubscriptionKey 
                Location        =   $Location       
                ServiceName     =   $ServiceName    
                EndPoint        =   $EndPoint       
            }

            if($data){
                & $VerboseEnvVariableSetup
                $data
            }
    }
}

#New-LocalConfiguration -FromAzure -verbose
