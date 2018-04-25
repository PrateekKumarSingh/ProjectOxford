$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module $projectRoot\PSCognitiveService\PSCognitiveService.psm1

InModuleScope -ModuleName PSCognitiveService {
    Describe "Test Face API Function" -Tag Build {  
        $Path = '.\Media\BillGates.jpg'
        $Url = 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'
        Context 'Get-Face' {            
            It "Should not throw with a local file PATH" {
                {Get-Face -Path $Path} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a local file PATH" {
                (Get-Face -Path $Path).gettype().Name | Should Be PSCustomObject
            }
            It "Should not throw with a URL" {
                {Get-Face -URL $Url} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-Face -URL $Url).gettype().Name | Should Be PSCustomObject
            }
        }
    }

    Describe "Test Vision API Function" -Tag Build {
        $Path = '.\Media\BillGates.jpg'
        $Url = 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'
        Context 'Get-ImageAnalysis' {            
            It "Should not throw with a local file PATH" {
                {Get-ImageAnalysis -Path $Path} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a local file PATH" {
                (Get-ImageAnalysis -Path $Path).gettype().Name | Should Be PSCustomObject
            }
            It "Should not throw with a URL" {
                {Get-ImageAnalysis -URL $Url} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-ImageAnalysis -URL $Url).gettype().Name | Should Be PSCustomObject
            }
        }

        Context 'Get-ImageDescription' {            
            It "Should not throw with a local file PATH" {
                {Get-ImageDescription -Path $Path} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a local file PATH" {
                (Get-ImageDescription -Path $Path).gettype().Name | Should Be PSCustomObject
            }
            It "Should not throw with a URL" {
                {Get-ImageDescription -URL $Url} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-ImageDescription -URL $Url).gettype().Name | Should Be PSCustomObject
            }
        }
     
        Context 'Get-ImageTag' {            
            It "Should not throw with a local file PATH" {
                {Get-ImageTag -Path $Path} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a local file PATH" {
                (Get-ImageTag -Path $Path).gettype().Name | Should Be PSCustomObject
            }
            It "Should not throw with a URL" {
                {Get-ImageTag -URL $Url} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-ImageTag -URL $Url).gettype().Name | Should Be PSCustomObject
            }
        }

        Context 'Get-ImageText' {            
            It "Should not throw with a local file PATH" {
                {Get-ImageText -Path $Path} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a local file PATH" {
                (Get-ImageText -Path $Path).gettype().Name | Should Be PSCustomObject
            }
            It "Should not throw with a URL" {
                {Get-ImageText -URL $Url} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-ImageText -URL $Url).gettype().Name | Should Be PSCustomObject
            }
        }
    }
}
