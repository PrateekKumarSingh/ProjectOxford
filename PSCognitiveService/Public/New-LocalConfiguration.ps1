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
        param([switch]$AddKeysToProfile, $data)
        $ServiceName = $data.ServiceName
        $SubscriptionKey = $data.SubscriptionKey
        $Location = $data.Location
        Write-Verbose "Setting Environment variable: `$env:API_SubscriptionKey_$ServiceName for Cognitive Service: $ServiceName" 
        Set-Item -Path "env:API_SubscriptionKey_$ServiceName" -Value $SubscriptionKey
        if($Location -ne 'global'){
            Write-Verbose "Setting Environment variable: `$env:API_Location_$ServiceName for Cognitive Service: $ServiceName" 
            Set-Item -Path "env:API_Location_$ServiceName" -Value $Location
        }
        if($AddKeysToProfile){
            Write-Verbose "Adding Environment variable(s) to Profile: $Profile" -Verbose
            Update-ProfileVariable "env:API_SubscriptionKey_$ServiceName" $SubscriptionKey
            if($Location -ne 'global'){
                Update-ProfileVariable "env:API_Location_$ServiceName" $Location
                Start-Sleep -Seconds 1
            }
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
                    $data = [System.Object] [Ordered] @{
                        ServiceName     =   $_.AccountType -replace "\.",""
                        Location        =   $_.Location
                        SubscriptionKey =   ($_ | Get-AzureRmCognitiveServicesAccountKey).Key1
                        EndPoint        =   $_.Endpoint
                    }

                    if($AddKeysToProfile){ & $Configuration -addKeysToProfile $data}
                    else{ & $Configuration $data}

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
        
        if($AddKeysToProfile){ & $Configuration -addKeysToProfile $data}
        else{ & $Configuration $data}
        $data 
    }

}
#New-LocalConfiguration -FromAzure -verbose
