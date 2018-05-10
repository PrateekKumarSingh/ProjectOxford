[![Build status](https://ci.appveyor.com/api/projects/status/jgiom7ww0nhc5kt7?svg=true)](https://ci.appveyor.com/project/PrateekKumarSingh/pscognitiveservice) [![PowerShell Gallery][psgallery-badge]][psgallery]
# PowerShell Module for Microsoft Cognitive Services (aka, ProjectOxford)
<a href='https://www.microsoft.com/cognitive-services'>Microsoft Cognitive Services</a> are some machine learning Artificial intelligent REST API's to give Human-like cognition abilities to your applications.


# What this module can do?

<img src=https://raw.githubusercontent.com/PrateekKumarSingh/PSCognitiveService/master/Media/demo.gif width=100% height=90%>

```PowerShell
# install module
Install-Module PSCognitiveService -Force -Scope CurrentUser -Verbose

# import module
Import-Module PSCognitiveService -Force -Verbose

# get module
Get-Command -Module PSCognitiveService

# login and obtain subscription keys, local config
New-LocalConfiguration -FromAzure -AddKeysToProfile | Out-Null

# face features & emotion recognitionc
Get-Face -Path 'C:\tmp\Bill.jpg' |Format-List *

# image analysis
Get-ImageAnalysis -Path 'C:\tmp\Bill.jpg'

# image description
Get-ImageDescription -Path 'C:\tmp\Bill.jpg' | ForEach-Object Description | Format-List

# tag image and convert to hashtags
Get-ImageTag -URL https://goo.gl/Q73Qtw |
ForEach-Object{$_.tags.name} | ForEach-Object {'#'+$_ -join ' '}

# optical character recognition
Get-ImageText -URL https://goo.gl/XyP6LJ |
ForEach-Object {$_.regions.lines.words.text -join ' '}

# convert to thumbnail
ConvertTo-Thumbnail -URL https://goo.gl/XyP6LJ -SmartCropping

# bing search
Search-Web 'powershell 6.1' -c 3 |
ForEach-Object {$_.webpages.value} | Format-List name, url, snippet
Search-Entity -Text 'brad pitt' |
ForEach-Object {$_.entities.value} | Format-List name, description, image, webSearchUrl

# text analytics
Get-Sentiment -Text "Hey good morning!","Such a wonderful day","I feel sad about you" |  ForEach-Object documents
Get-KeyPhrase -Text "Hey good morning!","Such a wonderful day","I feel sad about these poor people" | ForEach-Object documents
Trace-Language -Text "Hey good morning!", "Bonjour tout le monde", "La carretera estaba atascada" | ForEach-Object {$_.documents.detectedlanguages}

# moderate content - text, image (path/url)
Test-AdultRacyContent -Text "Hello World" | ForEach-Object Classification # clean
Test-AdultRacyContent -Text "go eff yourself" | ForEach-Object Classification # not good/review required
Test-AdultRacyContent -Path 'C:\Tmp\test.png'
Test-AdultRacyContent -URL https://goo.gl/uY2PS6

```


# Pre-Requisites
You need to do one-time registration for each Microsoft Cognitive Services API from <a href="https://www.microsoft.com/cognitive-services/en-us/sign-up">HERE</a>, before start using the module, because it won’t work without an API Key.

## 1. Installation

### [PowerShell v5](https://www.microsoft.com/en-us/download/details.aspx?id=50395) and Later
You can install the `PSCognitiveService` module directly from the PowerShell Gallery

<img src=https://raw.githubusercontent.com/PrateekKumarSingh/PSCognitiveService/master/Media/Install.jpg width=100% height=90%>

* **[Recommended]** Install to your personal PowerShell Modules folder
```PowerShell
Install-Module PSCognitiveService -scope CurrentUser
```
* **[Requires Elevation]** Install for Everyone (computer PowerShell Modules folder)
```PowerShell
Install-Module PSCognitiveService
```
### PowerShell v4 and Earlier
To install to your personal modules folder run:
```PowerShell
iex (new-object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/PrateekKumarSingh/PSCognitiveService/master/Install.ps1')
```

## 2. Subscribe
Microsoft Cognitive services are offered and subscribed through the <a href ='https://portal.azure.com'>Azure Portal</a> to achieve that -

- **Create cognitive service accounts** in azure portal.
- **Obtain subscription keys** 
- **Set $Env variables** locally, which would consumed by the module cmdlets to make REST API call's.

Personally, going to azure portal and obtaining subscription keys is a turn down for me. 

But, ```New-CognitiveServiceAccount```cmdlet that is included in this module to create Azure cognitive service accounts/subscription from your console.

Example, if you want to use the ```Search-Web``` cmdlet that utlizes ```Bing Search``` capabilities, you need to subscribe to Cognitive Service account of type: ```Bing.Search.v7```, just run the below cmdlet.

```PowerShell
New-CognitiveServiceAccount -AccountType Bing.Search.v7

# alternatively, specify ResourceGroup, Location and SKU
New-CognitiveServiceAccount -AccountType ComputerVision -ResourceGroupName ResourceGroup1 -Location centralindia -SKUName S1
```

## 3. Configure Locally

Alright, you are now subscribed, but how to obtain the subscription key(s) and set-up ```$ENV``` variable(s) in the session to run these cmdlets. 

It is as simple as a below cmdlet and Kaboom! you are subscribed and local configuration is complete!

```PowerShell
New-LocalConfiguration -FromAzure -AddKeysToProfile -Verbose
```
**NOTE** - Please add the subscription keys to your ```$Profile``` using ```-AddKeysToProfile``` switch for future use and to avoid above configuration step.

<img src=https://raw.githubusercontent.com/PrateekKumarSingh/PSCognitiveService/master/Media/Subscribe.gif width=100% height=90%>


