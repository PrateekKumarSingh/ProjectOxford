(Get-ChildItem $PSScriptRoot\*.ps1 -ErrorAction SilentlyContinue).Fullname | ForEach-Object {
    Try {
        . $_
    }
    Catch {
        Write-Error "Failed to import function '$($_)'"
    }
}

#some random change