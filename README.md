# Microsoft Cognitive Services (aka, ProjectOxford)
Microsoft Cognitive Services (aka -  <b><i>Project Oxford</b></i> - https://www.microsoft.com/cognitive-services ) are some machine learning AI API's to give Human Side to your code and a beatiful user experience. These are RESTfull API's and are easily accessible once subscribed.

I managed to wrap these RESTful API's in a powershell module and results and things we can achieve with this are amazing! 🙂

![](https://raw.githubusercontent.com/PrateekKumarSingh/ProjectOxford/master/GIFs/Main.gif)

This powershell module offers following functionalities -

## Get-EntityLink

Recognizes a named-entity from given text and aligning a textual mention of the entity to an appropriate entry in a knowledge base, like Wikipedia.

![Get-EntityLink](https://geekeefy.files.wordpress.com/2016/07/get-entitylink.gif?w=908&h=281)

## Get-ImageAnalysis

Returns information on visual content found in web hosted images. Like Color schemes, Face rectangles, Tags, caption (Small description of Image), head counts, Age & gender of people in Image, celebrity identification and much much more.

![Get-ImageAnalysis](https://geekeefy.files.wordpress.com/2016/07/get-imageanalysis.gif?w=900)

## Get-AgeAndGender

Returns  Age and Gender of Faces identified in a local Image, and capable to draw rectangle around the faces in the image denoting their Age and Gender

![Get-AgeGender](https://geekeefy.files.wordpress.com/2016/07/get-agegender1.gif?w=807&h=444)

## Get-KeyPhrase

Recognize Key phrases in a given text or string and Documents. Saves lots of time and avoid reading long documents 🙂

![Get-KeyPhrase](https://geekeefy.files.wordpress.com/2016/07/get-keyphrase.gif?w=900)

## Get-Emotion

Capable to detect the Emotion on the Faces identified in an Image on local machine, , and capable to draw rectangle around the faces in the image denoting their Emotion

![Get-Emotion](https://geekeefy.files.wordpress.com/2016/07/get-emotion1.gif?w=819&h=260)

## Get-Celebrity

Capable to identify the Names and total numbers of Celebrities in a web hosted Image. It can identify many celebs from fields like Movies, Sports, Politics.

![Get-Celebrity](https://geekeefy.files.wordpress.com/2016/07/get-celebrity.gif?w=900)

## Get-ImageText

Capable of extracting text from the web hosted Images, you need to just pass the Image URL as a parameter to this function and it will do the work for you.

![Get-Get-ImageText](https://geekeefy.files.wordpress.com/2016/07/get-imagetext.gif?w=900)

## Get-News

Returns NEWS items and headlines depending upon the categories you provide as a parameter, like Sports, Entertainment, Politics etc.

![Get-news](https://geekeefy.files.wordpress.com/2016/07/get-news1.gif?w=829&h=383)

## Get-Sentiment

Recognizes Sentiment in an input string, that is positiveness or Negativeness in the string context.

![Get-Sentiment](https://geekeefy.files.wordpress.com/2016/07/get-sentiment.gif?w=900)

## Invoke-SpellCheck

Identify and Rectify spelling mistakes in an input String and display errors. Also generates all possible permutations of the correct sentence with correct spellings.

![Invoke-SpellCheck](https://geekeefy.files.wordpress.com/2016/07/invoke-spellcheck.gif?w=900)

# Search-Bing

Provides capability to search Bing and facilitate bing results in the powershell
console.

![Search-bing](https://geekeefy.files.wordpress.com/2016/07/search-bing.gif?w=900)

## Split-IntoWords

Provides capability of Inserting spaces in words that lack spaces, like URLS, Hashtags etc.

![Split-IntoWords](https://geekeefy.files.wordpress.com/2016/07/split-intowords.gif?w=900)

## Test-AdultContent

Identifies any Adult or Racy content on a web hosted Image and flags them with a Boolean value [$true/$false]

![Test-AdultContent](https://geekeefy.files.wordpress.com/2016/07/test-adultcontent.gif?w=900)


# Pre-Requisites
You need to do one-time registration for each Microsoft Cognitive Services API from <a href="https://www.microsoft.com/cognitive-services/en-us/sign-up">HERE</a>, before start using the module, because it won’t work without an API Key.

I would suggest to Save the API Keys into your Powershell $Profile so that it automatically loads every time the console is fired.
Below is a screenshot on – how to keep the API keys in your $Profile to make your life a bit easy

![](https://geekeefy.files.wordpress.com/2016/07/apikey.png)

# Project URI (Details of the module on my Powershell blog)

https://geekeefy.wordpress.com/2016/07/08/powershell-module-for-microsoft-congnitive-services/
