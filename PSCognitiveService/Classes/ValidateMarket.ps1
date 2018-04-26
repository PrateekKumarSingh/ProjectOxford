class ValidateMarket {
    ValidateMarket() {}        
        Static [bool] Exists ($mkt) {
        $market = 'es-AR', 'en-AU', 'de-AT', 'nl-BE', 'fr-BE', 'pt-BR', 'en-CA', 'fr-CA', 'es-CL', 'da-DK', 'fi-FI', 'fr-FR', 'de-DE', 'zh-HK', 'en-IN', 'en-ID', 'en-IE', 'it-IT', 'ja-JP', 'ko-KR', 'en-MY', 'es-MX', 'nl-NL', 'en-NZ', 'no-NO', 'zh-CN', 'pl-PL', 'pt-PT', 'en-PH', 'ru-RU', 'ar-SA', 'en-ZA', 'es-ES', 'sv-SE', 'fr-CH', 'de-CH', 'h-TW', 'r-TR', 'n-GB', 'n-US', 's-US'
        if (!($mkt -in $market)) {return $false}
        return $true
    }
}
