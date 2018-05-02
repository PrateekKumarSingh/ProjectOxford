# function to expose class instances and method overload definitions
# outside the nested PowerShell module
Function New-CognitiveServiceInstance {
    [Alias('cognsvc')]
    [cmdletbinding(SupportsShouldProcess=$false)]
    param(
        [Parameter(Mandatory)]
        #[ValidateSet('ComputerVision', 'Face', 'ContentModerator','TextAnalytics','Bing')] $Name
        [CognitiveService] $Name
    )

    switch ($Name) {
        'ComputerVision' {[ComputerVision]::new($env:API_SubscriptionKey_ComputerVision, $env:API_Location_ComputerVision)}
        'Face' {[Face]::new($env:API_SubscriptionKey_Face, $env:API_Location_Face)}
        'ContentModerator' {[ContentModerator]::new($env:API_SubscriptionKey_ContentModerator, $env:API_Location_ContentModerator)}
        'TextAnalytics' {[TextAnalytics]::new($env:API_SubscriptionKey_TextAnalytics, $env:API_Location_TextAnalytics)}
        'BingSearchV7' {[BingSearchV7]::new($env:API_SubscriptionKey_BingSearchV7)}
    }
}

Export-ModuleMember -Function New-CognitiveServiceInstance -Alias CognSVC
