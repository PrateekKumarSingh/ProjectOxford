Import-Module .\PSCognitiveService\PSCognitiveService.psm1
New-LocalConfiguration -FromAzure -AddKeysToProfile -Verbose | Out-Null
$url = Search-Image -Text 'jeffery snover' -Count 20 -Verbose | ForEach-Object value | ForEach-Object contentURL
$data = $url | ForEach-Object {
    [PSCustomObject]@{
        link = $_
        emotions = (Get-face -URL $_).faceattributes.emotion
    }
}    

$data|fl| Where-Object{$_.emotions.anger -eq 1} | %{start $_.link}
