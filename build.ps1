param($Task = 'Default')
"Starting build"

# Grab nuget bits, install modules, set build variables, start build.
Write-Host "   [+] Install Dependent Modules" -Foreground Yellow
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

Uninstall-Module AzureRm -Verbose -Force -Confirm:$false

Install-Module PsScriptAnalyzer, Psake, PSDeploy, Pester, BuildHelpers, az.Profile, az.CognitiveServices, az.Resources -Force -AllowClobber

Write-Host "   [+] Import Dependent Modules" -Foreground Yellow
Import-Module PsScriptAnalyzer, Psake, PSDeploy, Pester, BuildHelpers, az.Profile, az.CognitiveServices, az.Resources

Set-BuildEnvironment -GitPath "C:\Program Files\Git\bin\git.exe"

Write-Host "   [+] InvokeBuild" -Foreground Yellow
Invoke-psake .\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )
