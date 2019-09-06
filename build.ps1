param($Task = 'Default')
"Starting build"

# Grab nuget bits, install modules, set build variables, start build.
"  Install Dependent Modules"
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
# Get-Module AzureRM* -ListAvailable | Uninstall-Module -Force -Verbose -Confirm:$false
# Get-Module az* -ListAvailable
Install-Module PsScriptAnalyzer, Psake, PSDeploy, Pester, BuildHelpers, az.Profile, az.CognitiveServices, az.Resources #-Force -AllowClobber

"  Import Dependent Modules"
Import-Module PsScriptAnalyzer, Psake, PSDeploy, Pester, BuildHelpers, az.Profile, az.CognitiveServices, az.Resources

# Uninstall-AzureRm -Verbose
Set-BuildEnvironment -GitPath "C:\Program Files\Git\bin\git.exe"

"  InvokeBuild"
Invoke-psake .\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )
