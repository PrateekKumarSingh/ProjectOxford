# simple bing search using PowerShell
Search-Web powershell
bing microsoft

# instantiating Cognitive service instance for Bing Search
$Bing = New-CognitiveServiceInstance -Name BingSearchV7
$Bing.Search('powershell 6.2').webpages.value | select name, url 


# more examples with parameters -SafSearch, -Count, -Offset
$r = Search-Web -SafeSearch moderate -Text 'git' -Count 13 -Verbose -OffSet 2
$r = Search-Web -Text 'adult' -Count 5 -Verbose -Market 'English-United States' -SafeSearch off
$r = Search-Web -Text 'adult' -Count 5 -Verbose -Market 'English-United States' -SafeSearch strict
$r.webPages.value | select name, url
