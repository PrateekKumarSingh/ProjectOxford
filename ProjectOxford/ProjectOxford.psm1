(Get-ChildItem $PSScriptRoot\*.ps1 -ErrorAction SilentlyContinue).Fullname | ForEach-Object {
    Try {
        . $_
    }
    Catch {
        Write-Error "Failed to import function '$($_)'"
    }
}