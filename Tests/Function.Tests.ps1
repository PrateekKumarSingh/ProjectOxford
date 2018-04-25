$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

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
                {Get-Face -URL 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-Face -URL 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg').gettype().Name | Should Be PSCustomObject
            }
        }
    }

    Describe "Test Vision API Function" -Tag Build {
        Context 'Get-ImageAnalysis' {            
            It "Should not throw with a local file PATH" {
                {Get-ImageAnalysis -Path ".\Media\BillGates.jpg"} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a local file PATH" {
                (Get-ImageAnalysis -Path ".\Media\BillGates.jpg").gettype().Name | Should Be PSCustomObject
            }
            It "Should not throw with a URL" {
                {Get-ImageAnalysis -URL 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-ImageAnalysis -URL 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg').gettype().Name | Should Be PSCustomObject
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
                {Get-ImageDescription -URL 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-ImageDescription -URL 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg').gettype().Name | Should Be PSCustomObject
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
                {Get-ImageTag -URL 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-ImageTag -URL 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg').gettype().Name | Should Be PSCustomObject
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
                {Get-ImageText -URL 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'} | Should Not throw
            }
            It "Should return a [PSCustomObject] with a URL" {
                (Get-ImageText -URL 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg').gettype().Name | Should Be PSCustomObject
            }
        }
    }
}
