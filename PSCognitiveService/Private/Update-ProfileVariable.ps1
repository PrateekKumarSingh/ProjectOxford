#
#$fileContent = Get-Content $profile
#$tokens = [System.Management.Automation.PSParser]::Tokenize($fileContent, [ref]$null)
#$lines = $tokens | Where-Object {$_.content -like "*env:API*" } | ForEach-Object StartLine 
#
#
#$existingVars = foreach($line in $lines){
#    $content = $tokens | Where-Object {$_.type -in 'Variable','String' -and $_.StartLine -in $line} | ForEach-Object content
#    
#    [PSCustomObject]@{
#        name = '$'+$content[0]
#        value = $content[1]
#        line = $line
#    }
#    #"`${0} = '{1}'" -f $content[0], $content[1] 
#}
#
#Foreach($ev in $existingVars){
#    $fileContent[$ev.line -1]
#}

function Update-ProfileVariable {
    [cmdletbinding()]
    param($name, $value)
    $fileContent = Get-Content $profile
    $found = $false
    for ($line = 0; $line -lt $fileContent.count; $line++) {
        if ($fileContent[$line] -like "*$name*") {
            $newline = "`$$name = '$value'"
            $fileContent[$line] = $newline # updating the variable
            Write-Verbose "Updated variable: `$$name in `$Profile" -Verbose
            $found = $true
        }
    }
    $fileContent | Out-File $profile
    if(-not $found){
        Add-Content $profile -Value "`$$name = '$value'" -Verbose
    }
}
