$o = [Analytics]::new($env:API_SubscriptionKey_text, $env:API_Location_text)  
$o.detectLanguage($text).documents
$o.getKeyPhrase($text).documents
$o.getSentiment($text).documents
$o.detectLanguage($t).documents
$o.getKeyPhrase($t).documents
$o.getSentiment($t).documents
