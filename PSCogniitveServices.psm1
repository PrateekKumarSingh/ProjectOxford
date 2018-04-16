# Dot Sourcing files
Get-ChildItem $PSScriptRoot | Where-Object Extension *.ps1 | ForEach-Object {
    . $_.FullName
}

