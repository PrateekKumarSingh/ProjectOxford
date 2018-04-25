InModuleScope -ModuleName PSCognitiveService {
    Describe "Test Face API Function" -Tag Build {
        It "Get-Face with a local path should not throw" {
            {Get-Face -Path .\Media\BillGates.jpg} | Should Not throw
        }
        It "Get-Face with a local path should return a value" {
            Get-Face -Path .\Media\BillGates.jpg | Should Not BeNullOrEmpty
        }
        It "Get-Face with a local path should return a [PSCustomObject]" {
            (Get-Face -Path .\Media\BillGates.jpg).gettype().Name | Should Be PSCustomObject
        }
        $Url = 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'
        It "Get-Face with a URL should not throw" {
            {Get-Face -URL $Url} | Should Not throw
        }
        It "Get-Face with a URL should return a value" {
            Get-Face -URL $Url | Should Not BeNullOrEmpty
        }
        It "Get-Face with a URL should return a [PSCustomObject]" {
            (Get-Face -URL $Url).gettype().Name | Should Be PSCustomObject
        }
    }
}
