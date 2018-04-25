$tokens = [System.Management.Automation.PSParser]::Tokenize((Get-Content $profile), [ref]$null)
$lines = $tokens | Where-Object {$_.content -like "*env:API*" } | ForEach-Object StartLine 

$existingVars = foreach($line in $lines){
    $content = $tokens | Where-Object {$_.type -in 'Variable','String' -and $_.StartLine -in $line} | foreach content
    
    [PSCustomObject]@{
        name = '$'+$content[0]
        value = $content[1]
        line = $line
    }
    #"`${0} = '{1}'" -f $content[0], $content[1] 
}

$a = gc $profile
$a[814] = 