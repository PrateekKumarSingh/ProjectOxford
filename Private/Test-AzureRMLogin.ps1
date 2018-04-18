function Test-AzureRmLogin {
    [CmdletBinding()]
    [Alias()]
    Param()

    Begin {
    }
    Process {
        # Verify we are signed into an Azure account
        try {
            Import-Module AzureRM.profile -Verbose:$false   
            Write-Verbose 'Checking if logged into Azure'
            $isLoggedIn = Get-AzureRmSubscription -ErrorAction Stop
        }
        catch [System.Management.Automation.PSInvalidOperationException] {
            Write-Verbose 'Not logged into Azure. Login now.'
            Login-AzureRmAccount
        }
        catch {
            Throw $_.Exception.Message
        }
        [bool]$isLoggedIn
    }
    End {
    }
}
