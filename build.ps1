param($Task = 'Default')
"Starting build"

# Grab nuget bits, install modules, set build variables, start build.
"  Install Dependent Modules"
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
Install-Module Psake, PSDeploy, Pester, BuildHelpers -Force -Verbose
Install-MOdule -Name 'AzureRM.Profile','AzureRM.CognitiveServices','AzureRM.Profile.NetCore','AzureRM.CognitiveServices.NetCore' -Force -AllowClobber -Verbose

"  Import Dependent Modules"
Import-Module Psake, BuildHelpers, Pester -Verbose
Import-Module -Name 'AzureRM.Profile','AzureRM.CognitiveServices','AzureRM.Profile.NetCore','AzureRM.CognitiveServices.NetCore' -Verbose

Set-BuildEnvironment -GitPath "C:\Program Files\Git\bin\git.exe"

"  InvokeBuild"
Invoke-psake .\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )
