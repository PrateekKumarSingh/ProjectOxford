Search-Web powershell
bing microsoft
New-CognitiveServiceInstance -Name BingSearchV7 -Verbose

bing powershell | % webpages | % value | select name, snippet, url 

$r = Search-Web -SafeSearch moderate -Text 'git' -Count 13 -Verbose -OffSet 2
$r = Search-Web -Text 'adult' -Count 5 -Verbose -Market 'English-United States' -SafeSearch off
$r = Search-Web -Text 'adult' -Count 5 -Verbose -Market 'English-United States' -SafeSearch strict
$r.webPages.value | measure
$r.webPages.value | select name, url
