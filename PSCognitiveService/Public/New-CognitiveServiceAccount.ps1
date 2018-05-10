function New-CognitiveServiceAccount {
    [CmdletBinding()]
    param (
        # Cognitive service account type 
        [Parameter(Mandatory)]
        [ValidateSet('Bing.Search.v7', 'Bing.EntitySearch', 'ComputerVision', 'Face', 'ContentModerator', 'TextAnalytics')]
        [String] $AccountType,
        [String] $ResourceGroupName,
        [Location] $Location,
        [ValidateSet('F0','F1','S0','S1','S2','S3','S4','S5','S6','S7','S8')]
        [String] $SKUName
    )

    process {
        try{
            if(Test-AzureRMLogin){
                Write-Verbose "Logged in."
                if(!$ResourceGroupName){
                    Write-Verbose "Fetching AzureRM Resource groups"
                    $ResourceGroupArray = Get-AzureRmResourceGroup| ForEach-Object ResourceGroupName
                    do{
                        Write-host "Select a AzureRM 'Resource Group' to create new Cognitive Service Account type: '$AccountType'" -ForegroundColor Yellow
                        for($i=1;$i -le $ResourceGroupArray.Count;$i++){
                            if($ResourceGroupArray.Count -gt 1){
                                " [{0}] {1}" -f ($i), $ResourceGroupArray[$i-1]
                            }
                        }
                        $ResourceGroupChoice = $(Read-Host "`nEnter your choice [1-$($ResourceGroupArray.count)]") - 1
                        $ResourceGroupName = $ResourceGroupArray[$ResourceGroupChoice]
                    }
                    while(-not($ResourceGroupChoice -in 0..$($ResourceGroupArray.count-1)))
                }
            }
        
            if(!$Location){
                $LocationArray = $Matrix[$AccountType]['AvailableLocations']
                do{
                    if($LocationArray.count -gt 1){
                        Write-host "Select a AzureRM 'Location' to create new Cognitive Service Account type: '$AccountType'" -ForegroundColor Yellow                
                        for($i=1;$i -le $LocationArray.Count;$i++){
                            if($LocationArray.Count -gt 1){
                                " [{0}] {1}" -f ($i), $LocationArray[$i-1]
                            }
                        }
                        $LocationChoice = $(Read-Host "`nEnter your choice [1-$($LocationArray.count)]") - 1
                        $Location = $LocationArray[$LocationChoice]
                    }
                    elseif($LocationArray.count -eq 1){
                        $Location = 'Global'
                        Write-Host "Choosing default and only Location: 'Global'"
                        break
                    }
                }
                while(-not($LocationChoice -in $(0..$($LocationArray.count-1))))
            }
        
            if(!$SKUName){            
                $SKUNameArray = $Matrix[$AccountType]['PriceTiers']
                do{
                    Write-host "Select a AzureRM 'PriceTier' to create new Cognitive Service Account type: '$AccountType'" -ForegroundColor Yellow                  
                    for($i=1;$i -le $SKUNameArray.Count;$i++){
                        if($SKUNameArray.Count -gt 1){
                            " [{0}] {1} - {2}" -f ($i), $SKUNameArray[$i-1] , $PriceTiers[$SKUNameArray[$i-1][0].ToString()]
                        }
                    }
                    $SKUNameChoice = $(Read-Host "`nEnter your choice [1-$($SKUNameArray.count)]") - 1
                    $SKUName = $SKUNameArray[$SKUNameChoice]
                }
                while(-not($SKUNameChoice -in 0..$($SKUNameArray.count-1)))
            }
        
            $splat = @{
                ResourceGroupName = $ResourceGroupName
                Name = "{0}-{1}" -f $AccountType.Replace('.','') , $Location
                SkuName = $SKUName
                Location = $Location
                Type = $AccountType
            }
            
            New-AzureRmCognitiveServicesAccount @splat -Confirm:$false -Force -Verbose -WarningAction Ignore
            
        }
        catch{
                throw $_.exception.message
        }
    }
}

Export-ModuleMember -Function New-CognitiveServiceAccount

#New-CognitiveServiceAccount -AccountType 'Bing.Search.v7' -Verbose





