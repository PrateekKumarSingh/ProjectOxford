### ProjectOxford
Microsoft Cognitive Services (aka -  <b><i>Project Oxford</b></i> - https://www.microsoft.com/cognitive-services ) are some machine learning AI API's to give Human Side to your code and a beatiful user experience. These are RESTfull API's and are easily accessible once subscribed.

Following are the functionalities I’ve written till date in  my module for Powershell cognitive services known as ProjectOxford

#Get-EntityLink –

Recognizes a named-entity from given text and aligning a textual mention of the entity to an appropriate entry in a knowledge base, like Wikipedia.

![Alt Text](https://geekeefy.files.wordpress.com/2016/07/get-entitylink.gif?w=908&h=281)

#Get-ImageAnalysis –

Returns information on visual content found in web hosted images. Like Color schemes, Face rectangles, Tags, caption (Small description of Image), head counts, Age & gender of people in Image, celebrity identification and much much more.

Get-ImageAnalysis

#Get-AgeAndGender –

Returns  Age and Gender of Faces identified in a local Image, and capable to draw rectangle around the faces in the image denoting their Age and Gender


#Get-KeyPhrase –

Recognize Key phrases in a given text or string and Documents. Saves lots of time and avoid reading long documents 🙂

Get-KeyPhrase

#Get-Emotion –

Capable to detect the Emotion on the Faces identified in an Image on local machine, , and capable to draw rectangle around the faces in the image denoting their Emotion

Get-Emotion

Get-Celebrity –

Capable to identify the Names and total numbers of Celebrities in a web hosted Image. It can identify many celebs from fields like Movies, Sports, Politics.

Get-Celebrity

#Get-ImageText –

Capable of extracting text from the web hosted Images, you need to just pass the Image URL as a parameter to this function and it will do the work for you.

Get-ImageText

#Get-News –

Returns NEWS items and headlines depending upon the categories you provide as a parameter, like Sports, Entertainment, Politics etc.

Get-news

#Get-Sentiment –

Recognizes Sentiment in an input string, that is positiveness or Negativeness in the string context.

get-Sentiment

#Invoke-SpellCheck –

Identify and Rectify spelling mistakes in an input String and display errors. Also generates all possible permutations of the correct sentence with correct spellings.

Invoke-SpellCheck

#Search-Bing –

Provides capability to search Bing and facilitate bing results in the powershell
console.

Search-bing

#Split-IntoWords –

 

Provides capability of Inserting spaces in words that lack spaces, like URLS, Hashtags etc.

Split-IntoWords

#Test-AdultContent –

Identifies any Adult or Racy content on a web hosted Image and flags them with a Boolean value [$true/$false]

Test-AdultContent


Offer wide variety of features including -<br />
<b>Optical Character Reading (OCR)<br />
Spell Check<br />
Image Analysis<br />
Detect Age, Gender and Emotion in Image<br />
Entity linking<br />
Text Analytics<br /></b>

and Much more :)

Following is link to Blog with Details of this project - https://geekeefy.wordpress.com/2016/07/08/powershell-module-for-microsoft-congnitive-services/
