Function Test-LocalConfiguration  {
    param(
        [Parameter(Mandatory)]
        [CognitiveService] $ServiceName
        )
        
        if(!(Get-Item -Path "env:API_SubscriptionKey_$ServiceName")){
            Throw "`$env:API_SubscriptionKey_$ServiceName is not set up.`nRun New-LocalConfiguration to setup environment variables."
        } 

        if(!(Get-Item -Path "env:API_Location_$ServiceName")){
            Throw "`$env:API_Location_$ServiceName is not set up.`nRun New-LocalConfiguration to setup environment variables."
        } 
        
        return $true
}

# Test-LocalConfiguration -ServiceName vision
