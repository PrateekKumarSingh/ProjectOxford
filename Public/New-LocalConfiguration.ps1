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
        [switch] $FromAzure,
        [Parameter(ParameterSetName='Manual')]
        [Parameter(ParameterSetName='FromAzure')] 
        [switch] $AddKeysToProfile
    )

    $Configuration = [scriptblock]{
        param([switch]$AddKeysToProfile)
        Write-Verbose "Setting Environment variable: `$env:API_SubscriptionKey_$ServiceName for Cognitive Service: $($ServiceName.ToString().ToUpper())" 
        Set-Item -Path "env:API_SubscriptionKey_$ServiceName" -Value $SubscriptionKey
        Write-Verbose "Setting Environment variable: `$env:API_Location_$ServiceName for Cognitive Service: $($ServiceName.ToString().ToUpper())" 
        Set-Item -Path "env:API_Location_$ServiceName" -Value $Location -Verbose
        if($AddKeysToProfile){
            Write-Verbose "Adding Environment variable(s) to Profile: $Profile" -Verbose
            Add-Content $profile -Value "`$env:API_SubscriptionKey_$ServiceName = '$SubscriptionKey'"
            Add-Content $profile -Value "`$env:API_Location_$ServiceName = '$Location'"
        }
    }
    
    if($FromAzure){
        if(Test-AzureRmLogin -verbose){
            Write-Verbose "Logged in."
            Write-Verbose "Fetching AzureRM Cognitive Service accounts" 
            $Accounts = Get-AzureRmCognitiveServicesAccount 
            Write-Verbose $("{0} Service found in AzureRM [{1}] " -f $Accounts.Count, $($Accounts.AccountType -join ', ') ) -Verbose
            if($Accounts){
                $Accounts | ForEach-Object {
                    $SubscriptionKey = ($_ | Get-AzureRmCognitiveServicesAccountKey).Key1
                    $Location        = $_.Location
                    $ServiceName     = ([uri]$_.Endpoint).segments[1] -replace "/",""
                    $EndPoint        = $_.Endpoint
                    
                    $data = [System.Object] [Ordered] @{
                        ServiceName     =   $ServiceName    
                        Location        =   $Location       
                        SubscriptionKey =   $SubscriptionKey 
                        EndPoint        =   $EndPoint       
                    }

                    if($AddKeysToProfile){ & $Configuration -addKeysToProfile }
                    else{ & $Configuration }

                    $data
                }
            }
        }
    }
    else{
        $data = [System.Object] [Ordered] @{
            ServiceName     =   $ServiceName    
            Location        =   $Location       
            SubscriptionKey =   $SubscriptionKey 
        }
        
        if($AddKeysToProfile){ & $Configuration -addKeysToProfile }
        else{ & $Configuration }
        $data 
    }

}
#New-LocalConfiguration -FromAzure -verbose
