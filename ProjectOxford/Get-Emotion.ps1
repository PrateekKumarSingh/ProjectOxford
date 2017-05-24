
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
                        ErrorVariable = E
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
                $Message = ($E.errorrecord.ErrorDetails.message|Out-String|ConvertFrom-Json).message   
                $category = $E.errorrecord.categoryInfo
                
                Write-Error -Exception ($E.errorrecord.Exception) `
                            -Message $message `
                            -Category $category.category `
                            -CategoryActivity $category.Activity `
                            -CategoryReason $category.Reason `
                            -TargetName $category.TargetName `
                            -TargetType $category.TargetType `
                            -RecommendedAction ($E.errorrecord.errordetails.RecommendedAction) `
                            -ErrorId $E.errorRecord.FullyQualifiedErrorId
            }
        }
    }
}