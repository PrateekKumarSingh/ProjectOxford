$projectRoot = Resolve-Path "$PSScriptRoot\.." | % Path
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
#$projectRoot
Import-Module $projectRoot\PSCognitiveService\PSCognitiveService.psm1


InModuleScope -ModuleName PSCognitiveService {
    Describe "Test Face API Function" -Tag Build {  
        Context 'Get-Face' {            
            It "Should not throw with a local file PATH" {
                {Get-Face -Path ".\Media\BillGates.jpg"} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a local file PATH" {
                (Get-Face -Path ".\Media\BillGates.jpg").gettype().Name | Should Be PSCustomObject
            }
            It "Should not throw with a URL" {
                {Get-Face -URL 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Steve_Jobs_Headshot_2010-CROP2.jpg'} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-Face -URL 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Steve_Jobs_Headshot_2010-CROP2.jpg').gettype().Name | Should Be PSCustomObject
            }
        }
    }

    Describe "Test ComputerVision API Function" -Tag Build {
        Context 'Get-ImageAnalysis' {            
            It "Should not throw with a local file PATH" {
                {Get-ImageAnalysis -Path ".\Media\BillGates.jpg"} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a local file PATH" {
                (Get-ImageAnalysis -Path ".\Media\BillGates.jpg").gettype().Name | Should Be PSCustomObject
            }
            It "Should not throw with a URL" {
                {Get-ImageAnalysis -URL 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Steve_Jobs_Headshot_2010-CROP2.jpg'} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-ImageAnalysis -URL 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Steve_Jobs_Headshot_2010-CROP2.jpg').gettype().Name | Should Be PSCustomObject
            }
        }

        Context 'Get-ImageDescription' {            
            It "Should not throw with a local file PATH" {
                {Get-ImageDescription -Path ".\Media\BillGates.jpg"} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a local file PATH" {
                (Get-ImageDescription -Path ".\Media\BillGates.jpg").gettype().Name | Should Be PSCustomObject
            }
            It "Should not throw with a URL" {
                {Get-ImageDescription -URL 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Steve_Jobs_Headshot_2010-CROP2.jpg'} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-ImageDescription -URL 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Steve_Jobs_Headshot_2010-CROP2.jpg').gettype().Name | Should Be PSCustomObject
            }
        }
     
        Context 'Get-ImageTag' {            
            It "Should not throw with a local file PATH" {
                {Get-ImageTag -Path ".\Media\BillGates.jpg"} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a local file PATH" {
                (Get-ImageTag -Path ".\Media\BillGates.jpg").gettype().Name | Should Be PSCustomObject
            }
            It "Should not throw with a URL" {
                {Get-ImageTag -URL 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Steve_Jobs_Headshot_2010-CROP2.jpg'} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-ImageTag -URL 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Steve_Jobs_Headshot_2010-CROP2.jpg').gettype().Name | Should Be PSCustomObject
            }
        }

        Context 'Get-ImageText' {            
            It "Should not throw with a local file PATH" {
                {Get-ImageText -Path ".\Media\BillGates.jpg"} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a local file PATH" {
                (Get-ImageText -Path ".\Media\BillGates.jpg").gettype().Name | Should Be PSCustomObject
            }
            It "Should not throw with a URL" {
                {Get-ImageText -URL 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Steve_Jobs_Headshot_2010-CROP2.jpg'} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-ImageText -URL 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Steve_Jobs_Headshot_2010-CROP2.jpg').gettype().Name | Should Be PSCustomObject
            }
        }
    }

    Describe "Test ContentModerator API Function" -Tag Build {  
        Context 'Test-AdultRacyContent' {            
            It "Should not throw" {
                {Test-AdultRacyContent -Text "What the hell is wrong with you" -AutoCorrect -PersonalIdentifiableInformation} | Should Not throw
            }
            It "Should return a [PSCustomObject]" {
                Start-Sleep -Seconds 1 # to avoid rate limit thresholds
                (Test-AdultRacyContent -Text "What the hell is wrong with you" -AutoCorrect -PersonalIdentifiableInformation).gettype().Name | Should Be PSCustomObject
            }
            It "Should not throw with a local file PATH" {
                Start-Sleep -Seconds 1 # to avoid rate limit thresholds
                {Test-AdultRacyContent -Path ".\Media\BillGates.jpg"} | Should Not throw
            }
            It "Should not throw with a URL" {
                Start-Sleep -Seconds 1 # to avoid rate limit thresholds
                {Test-AdultRacyContent -URL 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Steve_Jobs_Headshot_2010-CROP2.jpg'} | Should Not throw
            }
        }
    }
    
    Describe "Test TextAnalytics API Function" -Tag Build {  
        Context 'Get-Sentiment' {      
            $ScriptBlock = {Get-Sentiment -Text "This is a test!"}
            It "Should not throw" {
                $ScriptBlock | Should Not throw
            }
            It "Should return a [PSCustomObject]" {
                $result = & $ScriptBlock
                $result.gettype().Name | Should Be PSCustomObject
            }
            It "Should analyze and return documents" {
                $result = & $ScriptBlock
                $result.documents | Should Not BeNullOrEmpty
            }
            It "Should not return any errors" {
                $result = & $ScriptBlock
                $result.errors | Should BeNullOrEmpty
            }
        }

        Context 'Get-KeyPhrase' {      
            $ScriptBlock = {Get-KeyPhrase -Text "This is a test!"}
            It "Should not throw" {
                $ScriptBlock | Should Not throw
            }
            It "Should return a [PSCustomObject]" {
                $result = & $ScriptBlock
                $result.gettype().Name | Should Be PSCustomObject
            }
            It "Should analyze and return documents" {
                $result = & $ScriptBlock
                $result.documents | Should Not BeNullOrEmpty
            }
            It "Should not return any errors" {
                $result = & $ScriptBlock
                $result.errors | Should BeNullOrEmpty
            }
        }

        Context 'Trace-Language' {      
            $ScriptBlock = {Trace-Language -Text "This is a test!"}
            It "Should not throw" {
                $ScriptBlock | Should Not throw
            }
            It "Should return a [PSCustomObject]" {
                $result = & $ScriptBlock
                $result.gettype().Name | Should Be PSCustomObject
            }
            It "Should analyze and return documents" {
                $result = & $ScriptBlock
                $result.documents | Should Not BeNullOrEmpty
            }
            It "Should not return any errors" {
                $result = & $ScriptBlock
                $result.errors | Should BeNullOrEmpty
            }
        }
    }

    Describe "Test Bing API Function" -Tag Build {  
        Context 'Search-Web' {            
            It "Should not throw" {
                {Search-Web -Text "PowerShell"} | Should Not throw
            }
            It "Should return webpages Object[]" {
                (Search-Web -Text "PowerShell").webpages.value.gettype().Name | Should Be 'Object[]'
            }
        }

        Context 'Search-Entity' {            
            It "Should not throw" {
                Start-Sleep -Seconds 1 # to avoid rate limit thresholds
                {Search-Entity -Text "PowerShell"} | Should Not throw
            }
            It "Should return entities Object[]" {
                Start-Sleep -Seconds 1 # to avoid rate limit thresholds
                (Search-Entity -Text "PowerShell").Entities.value.gettype().Name | Should Be 'Object[]'
            }
        }
    }
}
