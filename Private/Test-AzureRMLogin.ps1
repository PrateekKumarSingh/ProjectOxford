# checks and verifies if the logged in to AzureRm
# returns $True if yes else throws error
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
            Write-Host 'Enter your Credentials in the Pop-up window' -ForegroundColor Yellow
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
