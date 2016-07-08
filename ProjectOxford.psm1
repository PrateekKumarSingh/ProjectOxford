<#.Synopsis
Returns information about Age and Gender of indentified faces in a local Image.
.DESCRIPTION
Function returns Age and Gender of indentified faces in an Image, in addition if used with "-draw" switch it will draw the identified face rectangles on the local Image, depicting age and gender.And show you results in a GUI.
NOTE : You need to subscribe the "Computer Vision API" before using the powershell script from the following link and setup an environment variable like, $env:MS_ComputerVision_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up

.EXAMPLE
PS Root\> Get-AgeAndGender -Path .\group.jpg

Age Gender FaceRectangle                             Image    
--- ------ -------------                             -----    
 41 Female @{left=40; top=70; width=49; height=49}   group.jpg
 24 Female @{left=231; top=123; width=47; height=47} group.jpg
 35 Female @{left=161; top=98; width=47; height=47}  group.jpg
 30 Female @{left=307; top=88; width=45; height=45}  group.jpg
 38 Male   @{left=127; top=43; width=42; height=42}  group.jpg
 37 Male   @{left=238; top=42; width=37; height=37}  group.jpg

Passing an local image path to the cmdlet will return you the Age and gender of identified faces in the Image.

.EXAMPLE
PS Root\> Get-AgeAndGender -Path .\pic.jpg -Draw

If you use '-Draw' switch with the cmdlet it will draw the face rectangle on the local Image, depicting age and gender.And show you results in a GUI.

.EXAMPLE
PS Root\> "C:\Users\prateesi\Documents\Data\Powershell\Scripts\group.jpg","C:\Users\prateesi\Documents\Data\Powershell\Scripts\profile.jpg" | Get-AgeAndGender

Age Gender FaceRectangle                               Image      
--- ------ -------------                               -----      
 41 Female @{left=40; top=70; width=49; height=49}     group.jpg  
 24 Female @{left=231; top=123; width=47; height=47}   group.jpg  
 35 Female @{left=161; top=98; width=47; height=47}    group.jpg  
 30 Female @{left=307; top=88; width=45; height=45}    group.jpg  
 38 Male   @{left=127; top=43; width=42; height=42}    group.jpg  
 37 Male   @{left=238; top=42; width=37; height=37}    group.jpg  
 31 Male   @{left=418; top=142; width=222; height=222} profile.jpg

 You can also pass multiple local images through pipeline to get the Age and gender information.
#>
Function Get-AgeAndGender
{
[CmdletBinding()]
Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true, position=1)]
        [string] $Path,
        [Switch] $Draw
      )
    
    Begin
    {
        Function DrawAgeAndGenderOnImage($Result)
        {
            #Calling the Assemblies
            [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
            [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

            $Image = [System.Drawing.Image]::fromfile($Item)
            $Graphics = [System.Drawing.Graphics]::FromImage($Image)

            Foreach($R in $Result)
            {
                #Individual Emotion score and rectangle dimensions of all Faces identified
                $Age = $R.Age
                $Gender = $R.Gender
                $FaceRect = $R.faceRectangle

                $LabelText = "$Age, $Gender"
                
                #Create a Rectangle object to box each Face
                $FaceRectangle = New-Object System.Drawing.Rectangle ($FaceRect.left,$FaceRect.top,$FaceRect.width,$FaceRect.height)

                #Create a Rectangle object to Sit above the Face Rectangle and express the emotion
                $AgeGenderRectangle = New-Object System.Drawing.Rectangle ($FaceRect.left,($FaceRect.top-22),$FaceRect.width,22)
                $Pen = New-Object System.Drawing.Pen ([System.Drawing.Brushes]::crimson,5)

                #Creating the Rectangles
                $Graphics.DrawRectangle($Pen,$FaceRectangle)    
                $Graphics.DrawRectangle($Pen,$AgeGenderRectangle)
                $Region = New-Object System.Drawing.Region($AgeGenderRectangle)
                $Graphics.FillRegion([System.Drawing.Brushes]::Crimson,$Region)

                #Defining the Fonts for Emotion Name
                $FontSize = 14
                $Font = New-Object System.Drawing.Font("lucida sans",$FontSize,[System.Drawing.FontStyle]::bold) 
                
                  $TextWidth = ($Graphics.MeasureString($LabelText,$Font)).width
                $TextHeight = ($Graphics.MeasureString($LabelText,$Font)).Height

                    #A While Loop to reduce the size of font until it fits in the Emotion Rectangle
                    While(($Graphics.MeasureString($LabelText,$Font)).width -gt $AgeGenderRectangle.width -or ($Graphics.MeasureString($LabelText,$Font)).Height -gt $AgeGenderRectangle.height )
                    {
                    $FontSize = $FontSize-1
                    $Font = New-Object System.Drawing.Font("lucida sans",$FontSize,[System.Drawing.FontStyle]::bold)  
                    }

                #Inserting the Emotion Name in the EmotionRectabgle
                $Graphics.DrawString($LabelText,$Font,[System.Drawing.Brushes]::White,$AgeGenderRectangle.x,$AgeGenderRectangle.y)
            }

            #Define a Windows Form to insert the Image
            $Form = New-Object system.Windows.Forms.Form
            $Form.BackColor = 'white'
            $Form.AutoSize = $true
            $Form.StartPosition = "CenterScreen"
            $Form.Text = "Get-AgeAndGender | Microsoft Project Oxford"
            $Form.Activate()

            #Create a PictureBox to place the Image
            $PictureBox = New-Object System.Windows.Forms.PictureBox
            $PictureBox.Image = $Image
            $PictureBox.Height =  700
            $PictureBox.Width = 600
            $PictureBox.Sizemode = 'autosize'
            $PictureBox.BackgroundImageLayout = 'stretch'
            
            #Adding PictureBox to the Form
            $Form.Controls.Add($PictureBox)

            [void]$Form.ShowDialog()

            #Disposing Objects and Garbage Collection
            $Image.Dispose()
            $Pen.Dispose()
            $PictureBox.Dispose()
            $Graphics.Dispose()
            $Form.Dispose()
            [GC]::Collect()
        }

        If(!$env:MS_ComputerVision_API_key)
        {
            Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_ComputerVision_API_key= `"YOUR API KEY`" `n`n"
        }
    }
    Process
    {
        Foreach($item in $path)
        {

            $Item = (Get-Item $Item).versioninfo.filename
    
            $Splat = @{
                
                Uri= "https://api.projectoxford.ai/vision/v1/analyses?visualFeatures=All&subscription-key=$env:MS_ComputerVision_API_key"
                Method = 'Post'
                InFile = $Item
                ContentType = 'application/octet-stream'
            }
            Try
            {    
                If($Draw)
                {
                    DrawAgeAndGenderOnImage ((Invoke-RestMethod @Splat).Faces)
                }
                Else
                {
                    (Invoke-RestMethod @Splat).Faces | Select @{n='Age';e={$_.Age}},`
                                                              @{n='Gender';e={$_.Gender}},`
                                                              @{n='FaceRectangle';e={$_.FaceRectangle}},`
                                                              @{n='Image';e={Split-path $item -Leaf}}
                }

            }
            Catch
            {
            Write-Host "Something went wrong, please try running the script again" -fore Cyan
            }
        }
    }
    end
    {}
}

<#
.SYNOPSIS
    Cmdlet is capable to identify the Names and total numbers of Celebrities in a web hosted Image.
.DESCRIPTION
    This cmdlet is Using Microsoft cognitive service's "Computer Vision" API as a service to get the information needed by issuing an HTTP request to the API
    NOTE : You need to subscribe the "Computer Vision API" before using the powershell script from the following link and setup an environment variable like, $env:MS_ComputerVision_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up

.PARAMETER Url
    Image URL where you want to identify the Celebrities.
.EXAMPLE
    PS Root\> Get-Celebrity -URL "http://img2.tvtome.com/i/u/aa0f2214136945d8c57879a5166c4271.jpg"

    Celebrities                                        Count URL                                                            
    -----------                                        ----- ---                                                            
    {David Schwimmer, Matthew Perry, Jennifer Aniston}     3 http://img2.tvtome.com/i/u/aa0f2214136945d8c57879a5166c4271.jpg   
    
    In above example, Function identifies all celebrities in the web hosted image and their head count. Then returns the Information like, Celebrity name, Count and URL searched.

.EXAMPLE
    PS Root\> $URLs = "http://az616578.vo.msecnd.net/files/2015/12/19/635861460485772096-652901092_selfieoscars.jpg", 
        "http://upload.wikimedia.org/wikipedia/commons/6/6c/Satya_Nadella.jpg","http://img2.tvtome.com/i/u/aa0f2214136945d8c57879a5166c4271.jpg",
        "Http://www.newstatesman.com/sites/default/files/images/2014%2B36_Friends_Cast_Poker(1).jpg",
        "http://i.huffpost.com/gen/2018240/images/o-FRIENDS-SHOW-JENNIFER-ANISTON-facebook.jpg"

    $URLs | Get-Celebrity |ft * -AutoSize

    Celebrities                                                    Count URL                                                                                         
    -----------                                                    ----- ---                                                                                         
    {Bradley Cooper, Ellen DeGeneres, Jennifer Lawrence}               3 http://az616578.vo.msecnd.net/files/2015/12/19/635861460485772096-652901092_selfieoscars.jpg
    Satya Nadella                                                      1 http://upload.wikimedia.org/wikipedia/commons/6/6c/Satya_Nadella.jpg                        
    {David Schwimmer, Matthew Perry, Jennifer Aniston}                 3 http://img2.tvtome.com/i/u/aa0f2214136945d8c57879a5166c4271.jpg                             
    David Schwimmer                                                    1 http://www.newstatesman.com/sites/default/files/images/2014%2B36_Friends_Cast_Poker(1).jpg  
    {David Schwimmer, Lisa Kudrow, Matthew Perry, Matt LeBlanc...}     5 http://i.huffpost.com/gen/2018240/images/o-FRIENDS-SHOW-JENNIFER-ANISTON-facebook.jpg

    You can also, pass multiple URL's to the cmdlet as it accepts the Pipeline input and will return the results.
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Get-Celebrity
{
[CmdletBinding()]
Param(
        #[Parameter(ValueFromPipeline=$True)]
		#[String] $Path,
		[Parameter(ValueFromPipeline=$True)]
		[String] $URL
)

    Begin
    {

        If(!$env:MS_ComputerVision_API_key)
        {
            Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_ComputerVision_API_key= `"YOUR API KEY`" `n`n"
        }

    }
    
    Process
    {
        Foreach($Item in $URL)
        {
    
            Try
            {
                $result = Invoke-RestMethod -Uri "https://api.projectoxford.ai/vision/v1.0/models/celebrities/analyze" `
                                            -Method 'Post' `
                                            -ContentType 'application/json' `
                                            -Body $(@{"URL"= $Url} | ConvertTo-Json) `
                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_ComputerVision_API_key } `
                                            -ErrorVariable E

                $Celebs =  $result.result.celebrities.name

                ''|select @{n='Celebrities';e={$Celebs}}, @{n='Count';e={$Celebs.count}}, @{n='URL';e={$URL}}
            }
            Catch
            {
                "Something went wrong While extracting Text from Image, please try running the script again`nError Message : "+$E.Message
            }
        }
    }

    End
    {
    }
}

<#
.SYNOPSIS
    Cmdlet is capable to detect the Emotion on the Faces identified in an Image on local machine. 
.DESCRIPTION
    This cmdlet is Using Microsoft cognitive service's "Emotion" API as a service to get the information needed by issuing an HTTP request to the API
    NOTE : You need to subscribe the "Emotion API" before using the powershell script from the following link and setup an environment variable like, $env:$env:MS_Emotion_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up

.PARAMETER ImagePath
    Image path on the local machine on which you want to identify emotion
.PARAMETER Draw
    Choose this switch to draw rectangle around facees denoting emotion on the image.
.EXAMPLE
    PS Root\> Get-Emotion -ImagePath C:\2.jpg

    Face      : @{height=369; left=503; top=256; width=369}
    Anger     : 0.00
    Contempt  : 0.01
    Disgust   : 0.00
    Fear      : 0.00
    Happiness : 0.81
    Sadness   : 0.00
    Surprise  : 0.00
    
    Face      : @{height=295; left=94; top=189; width=295}
    Anger     : 0.00
    Contempt  : 0.00
    Disgust   : 0.00
    Fear      : 0.00
    Happiness : 1.00
    Sadness   : 0.00
    Surprise  : 0.00  
    
    In above example, Function identifies all Face Rectangle in the Image and returns the Emotion scores (0 to 1) on each and every face.

.EXAMPLE
    PS Root\> Get-Emotion -ImagePath C:\2.jpg -Draw

    You can use '-Draw' switch and to draw a Rectangle around each face in the image denoting the emotion name, like Happiness, Anger, contempt.
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Get-Emotion
{
[CmdletBinding()]
Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string] $Path,
        [Switch] $Draw
      )
    Begin
    {
        Function DrawEmotionOnImage($Result)
        {
    #Calling the Assemblies
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $Image = [System.Drawing.Image]::fromfile($Item)
    $Graphics = [System.Drawing.Graphics]::FromImage($Image)

    Foreach($R in $Result)
    {
    #Individual Emotion score and rectangel dimensions of all Faces identified
    $Scores = $R.scores
    $FaceRect = $R.faceRectangle
    
    #Emotion Objects
    $Anger = New-Object PSObject -Property @{Name='Anger';Value=[decimal]($Scores.anger);BGColor='Black';FGColor='White'}
    $Contempt = New-Object PSObject -Property @{Name='Contempt';Value=[decimal]($Scores.contempt);BGColor='Cyan';FGColor='Black'}
    $Disgust = New-Object PSObject -Property @{Name='Disgust';Value=[decimal]($Scores.disgust);BGColor='hotpink';FGColor='Black'}
    $Fear = New-Object PSObject -Property @{Name='Fear';Value=[decimal]($Scores.fear);BGColor='teal';FGColor='White'}
    $Happiness = New-Object PSObject -Property @{Name='Happiness';Value=[decimal]($Scores.happiness);BGColor='Green';FGColor='White'}
    $Neutral = New-Object PSObject -Property @{Name='Neutral';Value=[decimal]($Scores.neutral);BGColor='navy';FGColor='White'}
    $Sadness = New-Object PSObject -Property @{Name='Sadness';Value=[decimal]($Scores.sadness);BGColor='maroon';FGColor='white'}
    $Surprise = New-Object PSObject -Property @{Name='Surprise';Value=[decimal]($Scores.surprise);BGColor='Crimson';FGColor='White'}   

    #Most Significant Emotion = Highest Decimal Value in all Emotion objects
    $StrongestEmotion = ($Anger,$Contempt,$Disgust,$Fear,$Happiness,$Neutral,$Sadness,$Surprise|sort -Property Value -Descending)[0]
    
    #Create a Rectangle object to box each Face
    $FaceRectangle = New-Object System.Drawing.Rectangle ($FaceRect.left,$FaceRect.top,$FaceRect.width,$FaceRect.height)

    #Create a Rectangle object to Sit above the Face Rectangle and express the emotion
    $EmotionRectangle = New-Object System.Drawing.Rectangle ($FaceRect.left,($FaceRect.top-22),$FaceRect.width,22)
    $Pen = New-Object System.Drawing.Pen ([System.Drawing.Brushes]::$($StrongestEmotion.BGColor),3)

    #Creating the Rectangles
    $Graphics.DrawRectangle($Pen,$FaceRectangle)    
    $Graphics.DrawRectangle($Pen,$EmotionRectangle)
    $Region = New-Object System.Drawing.Region($EmotionRectangle)
    $Graphics.FillRegion([System.Drawing.Brushes]::$($StrongestEmotion.BGColor),$Region)

    #Defining the Fonts for Emotion Name
    $FontSize = 14
    $Font = New-Object System.Drawing.Font("lucida sans",$FontSize,[System.Drawing.FontStyle]::bold) 

    $TextWidth = ($Graphics.MeasureString($StrongestEmotion.name,$Font)).width
    $TextHeight = ($Graphics.MeasureString($StrongestEmotion.name,$Font)).Height

        #A While Loop to reduce the size of font until it fits in the Emotion Rectangle
        While(($Graphics.MeasureString($StrongestEmotion.name,$Font)).width -gt $EmotionRectangle.width -or ($Graphics.MeasureString($StrongestEmotion.name,$Font)).Height -gt $EmotionRectangle.height )
        {
        $FontSize = $FontSize-1
        $Font = New-Object System.Drawing.Font("lucida sans",$FontSize,[System.Drawing.FontStyle]::bold)  
        }

    #Inserting the Emotion Name in the EmotionRectabgle
    $Graphics.DrawString($StrongestEmotion.Name,$Font,[System.Drawing.Brushes]::$($StrongestEmotion.FGcolor),$EmotionRectangle.x,$EmotionRectangle.y)
}

    #Define a Windows Form to insert the Image
    $Form = New-Object system.Windows.Forms.Form
    $Form.BackColor = 'white'
    $Form.AutoSize = $true
    $Form.MinimizeBox = $False
    $Form.MaximizeBox = $False
    $Form.WindowState = "Normal"
    $Form.StartPosition = "CenterScreen"
    $Form.Name = "Get-Emotion | Microsoft Project Oxford"

    #Create a PictureBox to place the Image
    $PictureBox = New-Object System.Windows.Forms.PictureBox
    $PictureBox.Image = $Image
    $PictureBox.Height =  700
    $PictureBox.Width = 600
    $PictureBox.Sizemode = 'autosize'
    $PictureBox.BackgroundImageLayout = 'stretch'
    
    #Adding PictureBox to the Form
    $Form.Controls.Add($PictureBox)
    
    #Making Form Visible
    [void]$Form.ShowDialog()

    #Disposing Objects and Garbage Collection
    $Image.Dispose()
    $Pen.Dispose()
    $PictureBox.Dispose()
    $Graphics.Dispose()
    $Form.Dispose()
    [GC]::Collect()
}
        
        If(!$env:MS_Emotion_API_key)
        {
            Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_Emotion_API_key= `"YOUR API KEY`" `n`n"
        }
    }
    Process
    {
        Foreach($item in $path)
        {

            $Item = (Get-Item $Item).versioninfo.filename

            $Splat = @{ 
                        Uri= "https://api.projectoxford.ai/emotion/v1.0/recognize?language=en&detect=true&subscription-key=$env:MS_Emotion_API_key"
                        Method = 'Post'
                        InFile = $Item
                        ContentType = 'application/octet-stream'
            }

            Try{

                If($Draw)
                {
                    DrawEmotionOnImage (Invoke-RestMethod @Splat)
                }
                Else
                {
                    $result = Invoke-RestMethod @Splat 
                    
                    Foreach($r in $result)
                    { 
                    
                        ''| Select @{n='Face';e={$r.FaceRectangle}}, `
                                   @{n='Anger';e={"{0:N2}" -f [Decimal]$r.scores.anger}},`
                                   @{n='Contempt';e={"{0:N2}" -f [Decimal]$r.scores.contempt}},`
                                   @{n='Disgust';e={"{0:N2}" -f [Decimal]$r.scores.disgust}},`
                                   @{n='Fear';e={"{0:N2}" -f [Decimal]$r.scores.fear}},`
                                   @{n='Happiness';e={"{0:N2}" -f [Decimal]$r.scores.happiness}},`
                                   @{n='Sadness';e={"{0:N2}" -f [Decimal]$r.scores.sadness}},`
                                   @{n='Surprise';e={"{0:N2}" -f [Decimal]$r.scores.Surprise}},`
                                   @{n='Image';e={Split-Path $item -Leaf}}
                    }
                }
            }
            Catch
            {
            Write-Host "Something went wrong, please try running the script again" -fore Cyan
            }
        }
    }
}

<#
.SYNOPSIS
    Recognize a named-entity from given text and aligning a textual mention of the entity to an appropriate entry in a knowledge base.
.DESCRIPTION
    Identifies and Maps named entities to appropriate knowledge base articles using  Microsoft cognitive service's "Entity linking" API.
    NOTE : You need to subscribe the "Entity linking API" before using the powershell script from the following link and setup an environment variable like, $env:MS_EntityLink_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up
.PARAMETER String
    String to search for named entities.
.EXAMPLE
    PS Root\> Get-EntityLink -String "NASA sends space shuttles to ISS"
    
    Name                        Match MatchIndices Wiki Link                                               
    ----                        ----- ------------ ---------                                               
    NASA                        NASA  (0,3)        http://en.wikipedia.org/wiki/NASA                       
    International Space Station ISS   (29,31)      http://en.wikipedia.org/wiki/International_Space_Station

    In above example, I passed an string to cmdlet in order to link some word entities to wikipedia pages/articles
.EXAMPLE 
    PS Root\> "Bill gates invented Windows operating system " | Get-EntityLink
    
    Name              Match                    MatchIndices Wiki Link                                     
    ----              -----                    ------------ ---------                                     
    Bill Gates        Bill gates               (0,9)        http://en.wikipedia.org/wiki/Bill_Gates       
    Microsoft Windows Windows operating system (20,43)      http://en.wikipedia.org/wiki/Microsoft_Windows
       
    You can also pass string from pipeline as the cmdlet accpets input from pipeline
.EXAMPLE
    PS Root\> Get-Content File.txt | Out-String | Get-EntityLink

    Name               Match            MatchIndices                                Wiki Link                                               
    ----               -----            ------------                                ---------                                               
    Windows PowerShell {PowerShell, PS} {(0,1), (37,38), (403,404), (1267,1268)...} http://en.wikipedia.org/wiki/Windows_PowerShell         
    Microsoft          Microsoft        (101,109)                                   http://en.wikipedia.org/wiki/Microsoft                  
    Flow Java          ToString         (3058,3065)                                 http://en.wikipedia.org/wiki/Java_(programming_language)
    UTF-8              Unicode/UTF-8    (3288,3300)                                 http://en.wikipedia.org/wiki/UTF-8                      
   
    Convert content of a file to string and pipe to generate Entity links for the whole Document. 

.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Get-EntityLink
{
[CmdletBinding()]
Param(
		[Parameter(mandatory = $true,ValueFromPipeline=$True, position =0)]
		[String] $String

)

    Begin
    {
        If(!$env:MS_EntityLink_API_key)
        {
            Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_EntityLink_API_key= `"YOUR API KEY`" `n`n"
        }
    }
    
    Process
    {
        Foreach($s in $String)
        {
                    
            Try
            {
               $body=$S

                $Results = Invoke-RestMethod -Uri "https://api.projectoxford.ai/entitylinking/v1.0/link" `
                                                            -Method 'POST' `
                                                            -ContentType 'text/plain' `
                                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_EntityLink_API_key } `
                                                            -Body $body `
                                                            -ErrorVariable E


                $Results.entities| ?{$_.score -gt 0.5} | select @{n="Name";e={$_.name}},`
                                                                 @{n='Match';e={$_.matches.text}}, `
                                                                 @{n='MatchIndices';e={Foreach($offset in $_.matches.Entries.offset){"($Offset,$($offset+($_.matches.text).length-1))"}}}, `
                                                                 @{n='Wiki Link';e={"http://en.wikipedia.org/wiki/$(($_.wikipediaId).replace(" ",'_'))"}}
               
            }
            Catch
            {
                $error = ($E.errorrecord.ErrorDetails.Message | ConvertFrom-Json).errors
                $error.parameter+": "+$error.Message
            }
        }
    }

    End
    {
    }
}

<#
.Synopsis
Returns information about visual content found in web hosted images.
.DESCRIPTION
Function returns variety of information about visual content found in an image, like Color schemes, Face rectangles, Tags, caption (Small description of Image), head couts, Age & gender of people in Image, celebrity identification and much much more.
NOTE : You need to subscribe the "Computer Vision API" before using the powershell script from the following link and setup an environment variable like, $env:MS_ComputerVision_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up

.EXAMPLE
PS Root\> "http://cdn.deccanchronicle.com/sites/default/files/NADELLA2.jpg" | Get-ImageAnalysis


Tags            : {person, man, glasses, cellphone...}
Caption         : Satya Nadella with glasses holding a cell phone
PeopleCount     : 1
Faces           : @{age=44; gender=Male; faceRectangle=}
IsBlackAndWhite : False
ForegroundColor : Blue
BackgroundColor : Blue
ProminentColors : {Blue, White}
URL             : http://cdn.deccanchronicle.com/sites/default/files/NADELLA2.jpg

Passing an image URL through pipeline to the cmdlet will return you the image analysis information

.EXAMPLE
PS Root\> ("http://i.huffpost.com/gen/2018240/images/o-FRIENDS-SHOW-JENNIFER-ANISTON-facebook.jpg" |Get-ImageAnalysis).faces

age gender faceRectangle                               
--- ------ -------------                               
 31 Male   @{left=902; top=394; width=159; height=159} 
 28 Female @{left=300; top=531; width=144; height=144} 
 31 Male   @{left=478; top=316; width=137; height=137} 
 27 Male   @{left=1254; top=254; width=133; height=133}
 29 Female @{left=1486; top=456; width=131; height=131}
 32 Female @{left=685; top=121; width=129; height=129} 

In above example I selected the 'Faces' property of the result and it returned all Identified faces, their Age and gender.
#>
Function Get-ImageAnalysis
{
[CmdletBinding()]
Param(
        #[Parameter(ValueFromPipeline=$True)]
		#[String] $Path,
		[Parameter(ValueFromPipeline=$True)]
		[String] $URL
)

    Begin
    {
        If(!$env:MS_ComputerVision_API_key)
        {
            Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_ComputerVision_API_key= `"YOUR API KEY`" `n`n"
        }     
    }
    
    Process
    {
        ForEach($item in $URL)
        {
    
            Try
            {
                $result = Invoke-RestMethod -Uri "https://api.projectoxford.ai/vision/v1.0/analyze?visualFeatures=description,tags,faces,Color&details=Celebrities" `
                                            -Method 'Post' `
                                            -ContentType 'application/json' `
                                            -Body $(@{"URL"=$item} | ConvertTo-Json) `
                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_ComputerVision_API_key} `
                                            -ErrorVariable E

                $tags=($result.tags| ?{$_.confidence -gt 0.5}).Name
                $Caption  = ($result.description.captions|sort confidence -Descending)[0].text
                $Faces = $result.faces
                $PeopleCount = $result.faces.Count
                $Color = $result.color


                ''|select @{n='Tags';e={$Tags}}, @{n='Caption';e={$Caption}},`
                          @{n='HeadCount';e={$PeopleCount}},@{n='Faces';e={$Faces}},` 
                          @{n='IsBlackAndWhite';e={$Color.isBWImg}}, @{n='ForegroundColor';e={$Color.dominantColorForeground}}, @{n='BackgroundColor';e={$Color.dominantColorBackground}}, @{n='ProminentColors';e={$Color.dominantColors}},`
                          @{n='URL';e={$Item}}
            }
            Catch
            {
                ($E.errorrecord.ErrorDetails.Message -split '"')[-2]
            }
        }
    }

    End
    {
    }
}

<#
.SYNOPSIS
    Cmdlet is capable in extracting text from the web hosted Images.
.DESCRIPTION
    This cmdlet is Using Microsoft cognitive service's "Computer Vision" API as a service to extract text from the web hosted images by issuing an HTTP calls to the API.
    NOTE : You need to subscribe the "Computer Vision API" before using the powershell script from the following link and setup an environment variable like, $env:MS_ComputerVision_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up

.PARAMETER Url
    Image URL from where you want to extract the text.
.EXAMPLE
    PS Root\> "https://assets.entrepreneur.com/article/1440698865_graphic-quote-estee-lauder.jpg" | Get-ImageText
    
    LineNumber LanguageCode Sentence         
    ---------- ------------ --------         
             1 en           I NEVER DREAMED  
             2 en           ABOUT SUCCESS.   
             3 en           I WORKED FOR IT. 
             4 en           -EdtÃ©e Zaudet      
        
    In above example, Function extract the text from the URL passed  returns you the sentences and Identified language

.EXAMPLE
    $URLs = "https://assets.entrepreneur.com/article/1440698865_graphic-quote-estee-lauder.jpg","https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg"
    $URLs | Get-ImageText
    
    LineNumber LanguageCode Sentence             URL                                                                                    
    ---------- ------------ --------             ---                                                                                    
             1 en           I NEVER DREAMED      https://assets.entrepreneur.com/article/1440698865_graphic-quote-estee-lauder.jpg      
             2 en           ABOUT SUCCESS.       https://assets.entrepreneur.com/article/1440698865_graphic-quote-estee-lauder.jpg      
             3 en           I WORKED FOR IT.     https://assets.entrepreneur.com/article/1440698865_graphic-quote-estee-lauder.jpg      
             4 en           -EdtÃ©e Zaudet        https://assets.entrepreneur.com/article/1440698865_graphic-quote-estee-lauder.jpg      
             1 en           STOP HATING          https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             2 en           YOURSELF FOR         https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             3 en           EVERYTHING YOU       https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             4 en           AREN'T AND START     https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             5 en           LOVING YOURSELF      https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             6 en           FOR EVERYTHING       https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             7 en           YOU ALREADY ARE.     https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
             8 en           RECOVERYEXPERTS.COM  https://s-media-cache-ak0.pinimg.com/736x/41/fe/f6/41fef69d2839b6b9122232c75d568a9e.jpg
        
    You can also, pass multiple URL's to the cmdlet as it accepts the Pipeline input and will return the results.
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Get-ImageText
{
[CmdletBinding()]
Param(
        #[Parameter(ValueFromPipeline=$True)]
		#[String] $Path,
		[Parameter(ValueFromPipeline=$True)]
		[String] $URL
)

Begin
{
        If(!$env:MS_ComputerVision_API_key)
        {
            Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_ComputerVision_API_key= `"YOUR API KEY`" `n`n"
        } 
}

Process{
            $SplatInput = @{
            Uri= "https://api.projectoxford.ai/vision/v1/ocr"
            Method = 'Post'
			#InFile = $Path
			ContentType = 'application/json'
			}

            $Headers =  @{
			# Your Secret Subscription Key goes here.
			'Ocp-Apim-Subscription-Key' = $env:MS_ComputerVision_API_key
			}

			If($URL)
			{
				$Body = @{"URL"= "$URL"} | ConvertTo-Json
			}

            Try{
				$Data = Invoke-RestMethod @SplatInput -Body $Body -Headers $Headers -ErrorVariable E
				$Language = $Data.Language
				$i=0; 
                foreach($D in $Data.regions.lines){
				$i=$i+1;$s=''; 
				''|select @{n='LineNumber';e={$i}},@{n='LanguageCode';e={$Language}},@{n='Sentence';e={$D.words.text |%{$s=$s+"$_ "};$s}},@{n='URL';e={$URL}}
                }

            }
            Catch{
                "Something went wrong While extracting Text from Image, please try running the script again`nError Message : "+$E.Message
            }
    }
}

<#
.SYNOPSIS
    Recognize Key phrases in a given text or string.
.DESCRIPTION
    Identifies Key phrases in a given text/string using Microsoft cognitive service's "Text Analytics" API.
    NOTE : You need to subscribe the "Text Analytics API." before using the powershell script from the following link and setup an environment variable like, $env:MS_TextAnalytics_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up
.PARAMETER String
    String to search for named entities.
.EXAMPLE
    PS C:\> Get-KeyPhrase -String "my name is prateek and I live in New Delhi"
    New Delhi
    prateek

    In above example, I passed an string to cmdlet in order to get the key phrases.

.EXAMPLE
    PS C:\> "my name is prateek and I live in New Delhi", "I was born in Ayodhya" | Get-KeyPhrase
    New Delhi
    prateek
    Ayodhya
       
    You can also pass string from pipeline as the cmdlet accpets input from pipeline
.EXAMPLE
    PS C:\> Get-Content C:\Data\File.txt | Out-String | Get-KeyPhrase
    clients
    confident making important business decisions
    Computer Vision API
    data
    information
    reliability

    Convert content of a file to string and pipe to generate Key Phrases for the whole Document. 
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Get-KeyPhrase
{
[CmdletBinding()]
Param(
		[Parameter(mandatory = $true,ValueFromPipeline=$True, position =0)]
		[String] $String
)

    Begin
    {
        If(!$env:MS_TextAnalytics_API_key)
        {
            Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_TextAnalytics_API_key= `"YOUR API KEY`" `n`n"
        } 
    }
    
    Process
    {
        Foreach($s in $String)
        {
                    
            Try
            {
               $body=$S

               $Results = Invoke-RestMethod -Uri "https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/keyPhrases" `
                                            -Method 'POST' `
                                            -ContentType 'application/json' `
                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_TextAnalytics_API_key } `
                                            -Body (@{"documents" = [Object[]] [ordered]@{"language"= "en"; "id"= "1";"text"= $s} } |ConvertTo-Json) `
                                            -ErrorVariable E


               $Results.documents.keyPhrases
                
            }
            Catch
            {
                $error = ($E.errorrecord.ErrorDetails.Message | ConvertFrom-Json).errors
                $error.parameter+": "+$error.Message
            }
        }
    }

    End
    {
    }
}

<#
.SYNOPSIS
    Get News from different categories
.DESCRIPTION
    This cmdlet returns NEWS items depending upon the catogoris you provide as a parameter, for which it employs Microsoft cognitive service's "Bing Search" API, by issuing an HTTP GET request to the API
    NOTE : You need to subscribe the "Bing search API" before using the powershell script from the following link and setup an environment variable like, $env:MS_BingSearch_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up
.PARAMETER Category
    Mention the NEWS category like - Sports, Politics or Entertainment
.PARAMETER HeadlinesOnly
    Choose this switch if you want only headlines to be returned.
.EXAMPLE
PS C:\> Get-News -Category "sports" | sort publisheddate | select -First 1

    Topic         : Roger Federer ready to put â€˜one stupid moveâ€™ behind him ahead of Wimbledon
    Description   : All it took was â€œone stupid moveâ€ for Roger Federerâ€™s season to fall into an abyss. For much of his career, the seven-times Wimbledon champion had been blessed with 
                    a body that seemed bullet-proof against the aches, pains and injuries suffered by ...
    About         : {Roger Federer, Wimbledon}
    Category      : Sports
    NewsProvider  : The Indian Express
    Headline      : False
    PublishedDate : 6/25/2016 7:04:00 PM
    URL           : http://www.bing.com/cr?IG=1D675EE849BD47D1AA576531A6EA3C11&CID=1A99E3DE2CC1633C28A5EAE12DF062D5&rd=1&h=DuRuwfZJBY-ROSM8myTav-xQgxXZJ9IOT_gMMnqvH14&v=1&r=http%3a%2f%2f
                    indianexpress.com%2farticle%2fsports%2ftennis%2froger-federer-ready-to-put-one-stupid-move-behind-him-ahead-of-wimbledon-2875960%2f&p=DevEx,5036.1  
    
    In above example, I queried  news under "Sports" category and sorted it according to published date to get the latest news.
.EXAMPLE

PS C:\> Get-News -HeadlinesOnly |select -First 2

    Topic         : Britain votes to leave EU, Cameron quits, markets rocked | Reuters
    Description   : LONDON Britain has voted to leave the European Union, forcing the resignation of Prime Minister David Cameron and dealing the biggest blow since World War Two to the 
                    European project of forging greater unity. Global stock markets plunged on Friday, and the ...
    About         : {David Cameron, European Union, United Kingdom}
    Category      : World
    NewsProvider  : Firstpost
    Headline      : True
    PublishedDate : 6/25/2016 7:35:00 PM
    URL           : http://www.bing.com/cr?IG=F8C5A488A96B433DBF9A046AFB3142B2&CID=3F39C0A8A9366E090993C997A8076F98&rd=1&h=NYvnARoK615NZ0lqaYQz7CjbV0s106KMwXW18HUM_Zk&v=1&r=http%3a%2f%2f
                    www.firstpost.com%2ffwire%2fbritain-votes-to-leave-eu-cameron-quits-markets-rocked-reuters-2855004.html&p=DevEx,5030.1
    
    Topic         : At Least 14 Killed In Hotel Attack In Somalia's Capital
    Description   : Mogadishu, Somalia: At least 14 people were killed when gunmen stormed a hotel in Somalia's seaside capital and took an unknown number of hotel guests hostage, 
                    police and medical workers said on Saturday, before security forces hunted down the attackers ...
    About         : {Somalia, Capital}
    Category      : World
    NewsProvider  : NDTV
    Headline      : True
    PublishedDate : 6/25/2016 7:31:00 PM
    URL           : http://www.bing.com/cr?IG=F8C5A488A96B433DBF9A046AFB3142B2&CID=3F39C0A8A9366E090993C997A8076F98&rd=1&h=UcoWWIEPchWv0x5FAJQh7e4DlnAkmcYm2tYoLXgHWgM&v=1&r=http%3a%2f%2f
                    www.ndtv.com%2fworld-news%2fat-least-14-killed-in-hotel-attack-in-somalias-capital-1423439&p=DevEx,5035.1
    
    You can choose '-HeadlinesOnly' switch to only get the NEWS in headlines under all categories.
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Get-News
{
[CmdletBinding()]
Param(
        #[Parameter(ValueFromPipeline=$True)]
		#[String] $Path,
		[Parameter(ValueFromPipeline=$True, position =0)]
		[String] $Category,
        [Switch] $HeadlinesOnly

)

    Begin
    {
        If(!$env:MS_BingSearch_API_key)
        {
            Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_BingSearch_API_key= `"YOUR API KEY`" `n`n"
        } 
    }
    
    Process
    {
        Foreach($C in $Category)
        {
                    
            Try
            {
               
                $Result = Invoke-RestMethod -Uri "https://api.cognitive.microsoft.com/bing/v5.0/news/?Category=$C" `
                                            -Method 'GET' `
                                            -ContentType 'application/json' `
                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_BingSearch_API_key } `
                                            -ErrorVariable E

                Write-Verbose "Total of $($Result.webPages.totalEstimatedMatches) keyword matches."

                $news = $Result.value | select @{n="Topic";e={$_.name}},@{n='Description';e={$_.Description}}, @{n='About';e={$_.about.name}},@{n='Category';e={$_.category}}, @{n='NewsProvider';e={$_.provider.name}}, @{n='Headline';e={if($_.headline){$True}else{$false}}},@{n='PublishedDate';e={[datetime]$_.datePublished}} ,@{n='URL';e={$_.url}}

                If($HeadlinesOnly)
                {
                    $news | ?{$_.headline -eq "true"}                   
                }
                else
                {
                    $news
                }

            }
            Catch
            {
                $error = ($E.errorrecord.ErrorDetails.Message | ConvertFrom-Json).errors
                $error.parameter+": "+$error.Message
            }
        }
    }

    End
    {
    }
}

<#
.SYNOPSIS
    Get Sentiment in an input string
.DESCRIPTION
    This cmdlet utlizes Microsoft cognitive service's "Bing Search" API to know the sentiment of the string.
    NOTE : You need to subscribe the "Bing search API" before using the powershell script from the following link and setup an environment variable like, $env:MS_TextAnalytics_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up
.PARAMETER Category
    Mention the NEWS category like - Sports, Politics or Entertainment
.PARAMETER HeadlinesOnly
    Choose this switch if you want only headlines to be returned.
.EXAMPLE
    PS Root\> Get-Sentiment -String "Hello Prateek, how are you?"
    
    String                      Positive % Negetive % OverallSentiment
    ------                      ---------- ---------- ----------------
    Hello Prateek, how are you? 93.37      6.63       Positive        
    
    In above example, I passed an string to cmdlet in order to get the Sentiment of the string.
.EXAMPLE
    PS Root\> "howdy","what the hell","damn" | Get-Sentiment
    
    String        Positive % Negetive % OverallSentiment
    ------        ---------- ---------- ----------------
    howdy         99.12      0.88       Positive        
    what the hell 23.91      76.09      Negitive        
    damn          0.80       99.20      Negitive
    
    You can also pass multiple strings as an argument through pipeline to the cmdlet to get the sentiment analysis
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Get-Sentiment
{
[CmdletBinding()]
Param(
		[Parameter(mandatory = $true,ValueFromPipeline=$True, position =0)]
		[String] $String

)

    Begin
    {
        If(!$env:MS_TextAnalytics_API_key)
        {
            Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_TextAnalytics_API_key= `"YOUR API KEY`" `n`n"
        } 
    }
    
    Process
    {
        Foreach($s in $String)
        {
                    
            Try
            {
               

                $Results = Invoke-RestMethod -Uri "https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/sentiment" `
                                                            -Method 'POST' `
                                                            -ContentType 'application/json' `
                                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_TextAnalytics_API_key } `
                                                            -Body (@{"documents" = [Object[]]@{"language"= "en"; "id"= "1";"text"= $s} } |ConvertTo-Json)`
                                                            -ErrorVariable E
                
                $sentiment = "{0:n2}" -f ($Results.documents.score  *100)

                '' | select @{n="String";e={$s}},@{n='Positive %';e={$sentiment}}, @{n='Negetive %';e={"{0:n2}" -f (100 - $sentiment)}},@{n='OverallSentiment';e={if($sentiment -gt 50){"Positive"}elseif($sentiment -eq 50){"Neutral"}else{"Negitive"}}}

            }
            Catch
            {
                $error = ($E.errorrecord.ErrorDetails.Message | ConvertFrom-Json).errors
                $error.parameter+": "+$error.Message
            }
        }
    }

    End
    {
    }
}

<#.Synopsis
Identify and Rectify spelling mistakes in an input String
.DESCRIPTION
Identify spelling meistakes and repeated token in a string and suggests possible combination of correct spellings, able to identify Nouns in the string and converts first alphabet in Uppercase.
Cmdlet is Using Microsoft cognitive service's "Spell Check" API as a service to get the information needed by making HTTP calls to the API
NOTE : You need to subscribe the "Spell Check API" before using the powershell script from the following link and setup an environment variable like, $env:MS_SpellCheck_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up
.EXAMPLE
Hello world
.EXAMPLE
PS D:\> "owershell is is fun" | Invoke-SpellCheck -ShowErrors |ft -AutoSize

ErrorToken Type          Suggestions
---------- ----          -----------
owershell  UnknownToken  powershell 
is         RepeatedToken         

DESCRIPTION
-----------
When Invoke-SpellCheck function is used with -ShowErrors switch, it identifies unknown tokens (mistakes), repeated token in the string and displays Suggestions.  
.EXAMPLE
PS D:\> "thes is the the graet wall of china" |Invoke-SpellCheck
this is the great wall of China
the is the great wall of China

DESCRIPTION
-----------
Using the Suggestion function generates all possible combination of sentences.
.EXAMPLE
PS D:\> "b!ll g@tes" |Invoke-SpellCheck -RemoveSpecialChars
Bill Gates

DESCRIPTION
-----------
When Invoke-SpellCheck function is used with -RemoveSpecialChars switch, it removes all special character fomr the input string and rectifies the spelling mistakes.
#>
Function Invoke-SpellCheck
{
[CmdletBinding()]
Param(
        [Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$True)]
		[String] $String,
		[Switch] $ShowErrors,
		[Switch] $RemoveSpecialChars
)

Begin
{
        # Function to Remove special character s and punctuations from Input string
        Function Remove-SpecialChars($Str) { Foreach($Char in [Char[]]"!@#$%^&*(){}|\/?><,.][+=-_"){$str=$str.replace("$Char",'')}; Return $str}

        If(!$env:MS_SpellCheck_API_key)
        {
            Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_SpellCheck_API_key= `"YOUR API KEY`" `n`n"
        }    
}

Process{
		If($RemoveSpecialChars){ $String = Clean-String $String	}
		
        Foreach($S in $String)
        {
            $SplatInput = @{
            Uri= "https://bingapis.azure-api.net/api/v5/spellcheck?Proof"
            Method = 'Post'
			}

            $Headers =  @{'Ocp-Apim-Subscription-Key' = $env:MS_SpellCheck_API_key}
			$body =     @{'text'= $s}
            Try{
                $SpellingErrors = (Invoke-RestMethod @SplatInput -Headers $Headers -Body $body ).flaggedTokens
				$OutString = $String # Make a copy of string to replace the errorswith suggestions.

				If($SpellingErrors)  # If Errors are Found
				{
					# Nested Foreach to generate the Rectified string Post Spell-Check
					Foreach($E in $spellingErrors){
					
						If($E.Type -eq 'UnknownToken') # If an unknown word identified, replace it with the respective sugeestion from the API results
						{
							$OutString= Foreach($s in $E.suggestions.suggestion)
										{
											$OutString -replace $E.token, $s
										}
						}
						ElseIf($E.Type -eq 'RepeatedToken')  # If REPEATED WORDS then replace the set by an instance of repetition
						{
							$OutString = $OutString -replace "$($E.Token) $($E.Token) ", "$($E.Token) "
						}
					}

					# InCase ShowErrors switch is ON
					If($ShowErrors -eq $true)
					{
						return $SpellingErrors |select @{n='ErrorToken';e={$_.Token}},@{n='Type';e={$_.Type}}, @{n='Suggestions';e={($_.suggestions).suggestion|?{$_ -ne $null}}}
					}
					Else      # Else return the spell checked string
					{
						Return $OutString 
					}
				}
				else     # When No error is found in the input string
				{			
						Return "No errors found in the String."
				}
				
            }
            Catch{
                "Something went wrong, please try running the script again"
            }
        }
    }

End
{
}
}

<#
.SYNOPSIS
    Bing search based on query.
.DESCRIPTION
    This cmdlet returns Bing web search results Using Microsoft cognitive service's "Bing Search" API, by issuing an HTTP GET request to the API
    NOTE : You need to subscribe the "Bing search API" before using the powershell script from the following link and setup an environment variable like, $env:MS_BingSearch_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up
.PARAMETER Query
    String you want to search on Bing
.PARAMETER Count
    Number of results you want Bing Search to return
.PARAMETER SafeSearch
    Safe search to avoid adult content to be returned from Bing search, default value is set to 'Moderate'
.EXAMPLE
    PS C:\> Search-Bing -Query "Bill Gates" -Count 2

    Query           : Bill Gates
    Result          : Bill Gates - Wikipedia, the free encyclopedia
    URL             : https://en.wikipedia.org/wiki/Bill_Gates
    Snippet         : William Henry "Bill" Gates III (born October 28, 1955) is an American business magnate, entrepreneur, philanthropist, investor, and programmer. In 1975, Gates and 
                      Paul Allen co-founded Microsoft, which became the world's largest PC software company.
    DateLastCrawled : 2016-06-24
    
    Query           : Bill Gates
    Result          : Bill Gates - Biography.com
    URL             : www.biography.com/people/bill-gates-9307520
    Snippet         : Biography.com tracks the life and career of Bill Gates, from his early interest in computer programming to his place as founder of Microsoft, the world's largest 
                      software business.
    DateLastCrawled : 2016-06-20

    
    In above example, I ran a bing search on "Bill gates" and chose to return only 2 matching results values.
.EXAMPLE
    PS C:\> Search-Bing -Query "Bill Gates" -Count 1 -SafeSearch Strict

    Query           : Bill Gates
    Result          : Bill Gates - Wikipedia, the free encyclopedia
    URL             : https://en.wikipedia.org/wiki/Bill_Gates
    Snippet         : William Henry "Bill" Gates III (born October 28, 1955) is an American business magnate, entrepreneur, philanthropist, investor, and programmer. In 1975, Gates and 
                      Paul Allen co-founded Microsoft, which became the world's largest PC software company.
    DateLastCrawled : 2016-06-24

    You can choose different modes (Strict, Moderate, Off) in '-SafeSearch' to make sure no adult content is returned from the Bing Search
.NOTES
    Author: Prateek Singh - @SinghPrateik
       
#>
Function Search-Bing
{
[CmdletBinding()]
Param(
        #[Parameter(ValueFromPipeline=$True)]
		#[String] $Path,
		[Parameter(ValueFromPipeline=$True, position =0, mandatory=$true )]
		[String] $Query,
        [Parameter(position =1)]
        [int] $Count = 10,
        [Validateset('Strict', 'Moderate', 'Off')][String] $SafeSearch = 'Moderate'
)

    Begin
    {
        If(!$env:MS_BingSearch_API_key)
        {
            Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_BingSearch_API_key= `"YOUR API KEY`" `n`n"
        } 
    }
    
    Process
    {
        Foreach($Q in $Query)
        {
            $Item = ($Q.trim()).Replace(' ','+')
                    
            Try
            {
                $Result = Invoke-RestMethod -Uri "https://api.cognitive.microsoft.com/bing/v5.0/search?q=$Item&count=$Count&SafeSearch=$SafeSearch" `
                                            -Method 'GET' `
                                            -ContentType 'application/json' `
                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_BingSearch_API_key } `
                                            -ErrorVariable E `

                
                Write-Verbose "Total of $($Result.webPages.totalEstimatedMatches) keyword matches."

                $Result.webPages.value | select @{n="Query";e={$q}},@{n='Result';e={$_.name}}, @{n='URL';e={$_.displayURL}}, @{n='Snippet';e={$_.snippet}}, @{n='DateLastCrawled';e={($_.dateLastCrawled).split('T')[0]}}

            }
            Catch
            {
                "Something went wrong While extracting Text from Image, please try running the script again`nError Message : "+$E.Message
            }
        }
    }

    End
    {
    }
}

<#.Synopsis
Cmdlet is capable of inserting spaces in words that lack spaces.
.DESCRIPTION
Insert spaces into a string of words lacking spaces, like a hashtag or part of a URL. Punctuation or exotic characters can prevent a string from being broken.
So it's best to limit input strings to lower-case, alpha-numeric characters.
NOTE : You need to subscribe the "Web language Model API (WebLM)" before using this powershell script from the following link and setup an environment variable like, $env:MS_WebLM_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up
.EXAMPLE
PS Root\> "ilovepowershell", "Helloworld" | Split-IntoWords

Original        Formatted        
--------        ---------        
ilovepowershell i love powershell
Helloworld      hello world
#>
Function Split-IntoWords
{
[CmdletBinding()]
Param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
        [string] $String
)

Begin
{
    Function Clean-String($Str)
    {
        Foreach($Char in [Char[]]"!@#$%^&*(){}|\/?><,.][+=-_"){$str=$str.replace("$Char",'')}
        Return $str
    }

    If(!$Env:MS_WebLM_API_KEy)
    {
        Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_WebLM_API_key = `"YOUR API KEY`" `n`n"
    }

}

Process{



        Foreach($S in (Clean-String $String))
        {
            $SplatInput = @{
            
            Uri= "https://api.projectoxford.ai/text/weblm/v1.0/breakIntoWords?model=anchor&text=$S&maxNumOfCandidatesReturned=5"
            Method = 'Post'
        }
            $Headers = @{
            
            'Ocp-Apim-Subscription-Key' = $Env:MS_WebLM_API_KEy
        }
            Try{
                $Data = Invoke-RestMethod @SplatInput -Headers $Headers
                Return  new-object psobject -Property @{               
                Original=$String; 
                Formatted =($data.candidates |select words, Probability|sort -Descending)[0].words
                }|select Original, Formatted
            }
            Catch{
                Write-Host "Something went wrong, please try running the script again" -fore Cyan
            }
        }
    }
}

<#.Synopsis
Get Adult and Racy score of an Web hosted Images.
.DESCRIPTION
Function identifies any adult or racy content on a web hosted Image and flags them with a Boolean value [$true/$false]
NOTE : You need to subscribe the "Computer Vision API" before using the powershell script from the following link and setup an environment variable like, $env:MS_ComputerVision_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up

.EXAMPLE
PS Root\> "http://upload.wikimedia.org/wikipedia/commons/6/6c/Satya_Nadella.jpg" | Test-AdultContent

isAdultContent isRacyContent URL                                                                 
-------------- ------------- ---                                                                 
         False         False http://upload.wikimedia.org/wikipedia/commons/6/6c/Satya_Nadella.jpg

pass the Image URL to the function through a pipeline to get the results.
.EXAMPLE
PS Root\> (Invoke-WebRequest -Uri 'http:\\geekeefy.wordpress.com' -UseBasicParsing).images.src | Test-AdultContent -ErrorAction SilentlyContinue |ft -AutoSize

isAdultContent isRacyContent URL                                                                                                  
-------------- ------------- ---                                                                                                  
         False         False https://geekeefy.files.wordpress.com/2016/06/tip2.gif?w=596&amp;h=300&amp;crop=1                     
         False         False https://geekeefy.files.wordpress.com/2016/06/wil.png?w=900&amp;h=152&amp;crop=1                      
         False         False https://geekeefy.files.wordpress.com/2016/06/windowserror1.gif?w=900&amp;h=300&amp;crop=1            
         False         False https://geekeefy.files.wordpress.com/2016/06/gist3.png?w=711&amp;h=133&amp;crop=1                    
         False         False https://geekeefy.files.wordpress.com/2016/05/ezgif-com-video-to-gif-11.gif?w=900&amp;h=300&amp;crop=1

You can also pass a series of Image URL's to the Cmdlet, like in the above example I passed it Image URL's of all images from my Blog homepage.
Please note that, API has a limitation of 20 requests per min, so you may see errors after the limitation is breached
#>
Function Test-AdultContent
{
[CmdletBinding()]
Param(
        #[Parameter(ValueFromPipeline=$True)]
		#[String] $Path,
		[Parameter(ValueFromPipeline=$True)]
		[String] $URL
)

    Begin
    {

    If(!$env:MS_ComputerVision_API_key)
    {
        Throw "You need to Subscribe the API to get a key from API Subscription Page - https://www.microsoft.com/cognitive-services/en-us/sign-up `nThen save it as environment variable `$env:MS_ComputerVision_API_key= `"YOUR API KEY`" `n`n"
    }

    }
    
    Process
    {
        Foreach($Item in $URL)
        {
    
            Try
            {
                $result = Invoke-RestMethod -Uri "https://api.projectoxford.ai/vision/v1.0/analyze?visualFeatures=Adult" `
                                            -Method 'Post' `
                                            -ContentType 'application/json' `
                                            -Body $(@{"URL"= $URL} | ConvertTo-Json) `
                                            -Headers @{'Ocp-Apim-Subscription-Key' = $env:MS_ComputerVision_API_key} `
                                            -ErrorVariable E

                $result.adult | select IsAdultContent, isRacyContent, @{n='URL';e={$Item}}
            }
            Catch
            {
                Writ ($E.errorrecord.ErrorDetails.Message -split '"')[-2]
            }
        }
    }

    End
    {
    }
}
