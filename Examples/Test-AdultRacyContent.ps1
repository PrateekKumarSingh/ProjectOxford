# moderate content using [ContentModerator] object and processimage(path) method
$object = [ContentModerator]::new($env:API_SubscriptionKey_contentmoderator, $env:API_Location_contentmoderator)
$path = [System.IO.FileInfo] 'C:\Tmp\test.png'
$object.processimage($path)
Test-AdultRacyContent -Path $Path -Verbose


Test-AdultRacyContent -Text "go fuck yourself" -Verbose
Test-AdultRacyContent -Text "go fuck yourself" -Verbose
Test-AdultRacyContent -Text "go fuck yourself" -AutoCorrect -PersonalIdentifiableInformation -Verbose

# moderate content using [ContentModerator] object and processimage(path, cachesimage) method
$object = [ContentModerator]::new($env:API_SubscriptionKey_contentmoderator, $env:API_Location_contentmoderator)
$path = [System.IO.FileInfo] 'C:\Tmp\test.png'
$object.processimage($path, $true)
Test-AdultRacyContent -Path $Path -Verbose -CachesImage


# moderate content using [ContentModerator] object and processimage(url) method
$object = [ContentModerator]::new($env:API_SubscriptionKey_contentmoderator, $env:API_Location_contentmoderator)
$url = [uri] 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'
$object.processimage($url)


# moderate content using [ContentModerator] object and processimage(url, cachesimage) method
$object = [ContentModerator]::new($env:API_SubscriptionKey_contentmoderator, $env:API_Location_contentmoderator)
$url = [uri] 'https://pbs.twimg.com/profile_images/963507920016216064/Ug29J5-J.jpg'
$object.processimage($url, $true)
$object.processimage($url, $false)
Test-AdultRacyContent -URL $url -Verbose -CachesImage


# moderate content using [ContentModerator] object and processtext(text) method
$object = [ContentModerator]::new($env:API_SubscriptionKey_contentmoderator, $env:API_Location_contentmoderator)
$text = 'Holy shit! this is crap.'
$object.processtext($text)
$object.result.Classification

# moderate content using [ContentModerator] object and processtext(text, autocorrect, personalIdentifiableInfo, listId, classify, language) method
$object = [ContentModerator]::new($env:API_SubscriptionKey_contentmoderator, $env:API_Location_contentmoderator)
$text = 'Holy shit! this is crap.'
$object.processtext($text, $true, $true, '', 'eng')
$object.result.Status


https://westus.api.cognitive.microsoft.com/contentmoderator/moderate/v1.0/ProcessText/Screen?
