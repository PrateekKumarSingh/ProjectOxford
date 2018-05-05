# checks and verifies if the logged in to AzureRm
# returns $True if yes else throws error
function Test-AzureRmLogin {
    [CmdletBinding()]
    [OutputType([boolean])]
    [Alias()]
    Param()

    Begin {
    }
    Process {
        # Verify we are signed into an Azure account
        try {
            Import-Module AzureRM.profile -Verbose:$false   
            Write-Verbose 'Testing Azure login'
            $isLoggedIn = Get-AzureRmSubscription -ErrorAction Stop
        }
        catch [System.Management.Automation.PSInvalidOperationException] {
            Write-Verbose 'Not logged into Azure. Initiate login now.'
            Write-Host 'Enter your credentials in the pop-up window' -ForegroundColor Yellow
            $isLoggedIn = Login-AzureRmAccount
        }
        catch {
            Throw $_.Exception.Message
        }
        [bool]$isLoggedIn
    }
    End {
    }
}
