# moderate content using [Moderate] object and processimage(path) method
$object = [Moderate]::new($env:API_SubscriptionKey_ContentModerator, $env:API_Location_ContentModerator)
$path = [System.IO.FileInfo] 'C:\Tmp\test.png'
$object.processimage($path)

Test-AdultRacyContent -Text "Hello World" -Verbose | % Classification
Test-AdultRacyContent -Text "go eff yourself" -Verbose | % Classification
Test-AdultRacyContent -Text "go eff yourself" -AutoCorrect -PersonalIdentifiableInformation -Verbose

# moderate content using [Moderate] object and processimage(path, cachesimage) method
$object = [Moderate]::new($env:API_SubscriptionKey_ContentModerator, $env:API_Location_ContentModerator)
$path = [System.IO.FileInfo] 'C:\Tmp\test.png'
$object.processimage($path, $true)
Test-AdultRacyContent -Path $Path -Verbose -CachesImage

# moderate content using [Moderate] object and processimage(url) method
$object = [Moderate]::new($env:API_SubscriptionKey_ContentModerator, $env:API_Location_ContentModerator)
$url = [uri] 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'
$object.processimage($url)

# moderate content using [Moderate] object and processimage(url, cachesimage) method
$object = [Moderate]::new($env:API_SubscriptionKey_ContentModerator, $env:API_Location_ContentModerator)
$url = [uri] 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'
$object.processimage($url, $true)
$object.processimage($url, $false)
Test-AdultRacyContent -URL $url -Verbose -CachesImage

# moderate content using [Moderate] object and processtext(text) method
$object = [Moderate]::new($env:API_SubscriptionKey_ContentModerator, $env:API_Location_ContentModerator)
$text = 'Holy shit! this is crap.'
$object.processtext($text)
$object.result.Classification

# moderate content using [Moderate] object and processtext(text, autocorrect, personalIdentifiableInfo, listId, classify, language) method
$object = [Moderate]::new($env:API_SubscriptionKey_ContentModerator, $env:API_Location_ContentModerator)
$text = 'Holy shit! this is crap.'
$object.processtext($text, $true, $true, '', 'eng')
$object.result.Status

