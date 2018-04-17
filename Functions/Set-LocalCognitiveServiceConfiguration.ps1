Function Set-LocalCognitiveServiceConfiguration {
    [alias("config")]
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $SubscriptionKey,
        [Parameter(Mandatory)] [Location] $Location,
        [Parameter(Mandatory)] [CognitiveService] $ServiceName
    )

    Write-Verbose "Setting Environment variables" 
    Set-Item -Path "env:API_SubscriptionKey_$ServiceName" -Value $SubscriptionKey
    Set-Item -Path "env:API_Location_$ServiceName" -Value $Location

    [System.Object] [Ordered] @{
        SubscriptionKey = $SubscriptionKey
        Location        = $Location
        Service         = $ServiceName
        Endpoint        = "https://$Location.api.cognitive.microsoft.com/$ServiceName/v1.0/"
    }
}

#Set-LocalCognitiveServiceConfiguration -SubscriptionKey 'bd59f063c3a5437c96377c7684a0aaad' -Location southeastasia -ServiceName vision -verbose
