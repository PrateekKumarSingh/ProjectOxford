# function to expose class instances and method overload definitions
# outside the nested PowerShell module
Function New-CognitiveServiceInstance {
    [cmdletbinding(SupportsShouldProcess=$false)]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Vision', 'Face', 'Moderate')] $Name
    )

    switch ($Name) {
        'Vision' {[Vision]::new($env:API_SubscriptionKey_Vision, $env:API_Location_Vision)}
        'Face' {[Face]::new($env:API_SubscriptionKey_Face, $env:API_Location_Face)}
        'Moderate' {[face]::new($env:API_SubscriptionKey_Moderate, $env:API_Location_Moderate)}
    }
}
