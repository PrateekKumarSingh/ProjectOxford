enum CognitiveService {
    ComputerVision
    Face 
    Emotion
    TextAnalytics
    ContentModerator
    BingSearchV7
    BingEntitySearch
    BingImageSearch
}
# "Academic",
# "Bing.Autosuggest",
# "Bing.Autosuggest.v7",
# "Bing.CustomSearch",
# "Bing.Search",
# "Bing.Search.v7",
# "Bing.Speech",
# "Bing.SpellCheck",
# "Bing.SpellCheck.v7",
# "ComputerVision",
# "ContentModerator",
# "CustomSpeech",
# "Emotion",
# "Face",
# "LUIS",
# "Recommendations",
# "SpeakerRecognition",
# "Speech",
# "SpeechTranslation",
# "TextAnalytics"
# "TextTranslation",
# "WebLM"
enum Location {
    eastasia
    southeastasia
    centralus
    eastus
    eastus2
    westus
    northcentralus
    southcentralus
    northeurope
    westeurope
    japanwest
    japaneast
    brazilsouth
    australiaeast
    australiasoutheast
    southindia
    centralindia
    westindia
    canadacentral
    canadaeast
    uksouth
    ukwest
    westcentralus
    westus2
    koreacentral
    koreasouth
    francecentral
    francesouth
    global
}

enum Extension {
    png
    bmp
    jpg
    jpeg
    gif
}

enum VisualFeatures {
    Categories
    Tags
    Description
    Faces
    ImageType
    Color
    Adult    
}

enum Details {
    Celebrities
    Landmarks 
}

enum FaceAttributes {
    age
    gender
    headPose
    smile
    facialHair
    glasses
    emotion
    hair
    makeup
    occlusion
    accessories
    blur
    exposure
    noise
}

enum SafeSearch {
    off
    moderate
    strict
}

enum ResponseFilters {
    Computation
    Entities
    Images
    News
    RelatedSearches
    SpellSuggestions
    TimeZone
    Videos
    Webpages
}
