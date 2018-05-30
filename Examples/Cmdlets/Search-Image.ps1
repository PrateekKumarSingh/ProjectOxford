Import-Module .\PSCognitiveService\PSCognitiveService.psm1
New-LocalConfiguration -FromAzure -AddKeysToProfile -Verbose | Out-Null
$url = Search-Image -Text 'Joey Aiello powershell' -Count 20 -Verbose | ForEach-Object value | ForEach-Object contentURL
$data = $url | ForEach-Object {
    [PSCustomObject]@{
        link = $_
        emotions = (Get-face -URL $_).faceattributes.emotion
    }
}    

$data| Where-Object{$_.emotions.happiness -gt .5} | %{start $_.link}