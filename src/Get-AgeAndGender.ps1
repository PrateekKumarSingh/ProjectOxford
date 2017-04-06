<#.Synopsis
Returns information about Age and Gender of indentified faces in a local Image.
.DESCRIPTION
Function returns Age and Gender of indentified faces in an Image, in addition if used with "-draw" switch it will draw the identified face rectangles on the local Image, depicting age and gender.And show you results in a GUI.
NOTE : You need to subscribe the "Computer Vision API" before using the powershell script from the following link and setup an environment variable like, $env:MS_ComputerVision_API_key = "YOUR API KEY"
    
    API Subscription Page - https://www.microsoft.com/cognitive-services/en-US/subscriptions

.EXAMPLE
PS Root\> Get-AgeAndGender -Path .\pic.jpg

age gender faceRectangle                              
--- ------ -------------                              
 28 Male   @{left=352; top=128; width=342; height=342}
 35 Male   @{left=136; top=364; width=51; height=51}

Passing an local image path to the cmdlet will return you the Age and gender of identified faces in the Image.

.EXAMPLE
PS Root\> Get-AgeAndGender -Path C:\Users\prateesi\Desktop\pic.jpg -Draw

If you use '-Draw' switch with the cmdlet it will draw the face rectangle on the local Image, depicting age and gender.And show you results in a GUI.
#>
Function Get-AgeAndGender
{
[CmdletBinding()]
Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string] $Path,
        [Switch] $Draw
      )

    $Splat = @{
        
        Uri= "https://api.projectoxford.ai/vision/v1/analyses?visualFeatures=All&subscription-key=$env:MS_ComputerVision_API_key"
        Method = 'Post'
        InFile = $Path
        ContentType = 'application/octet-stream'
    }
    Try
    {    
        If($Draw)
        {
            Draw-Image ((Invoke-RestMethod @Splat).Faces)
        }
        Else
        {
            (Invoke-RestMethod @Splat).Faces
        }

    }
    Catch
    {
    Write-Host "Something went wrong, please try running the script again" -fore Cyan
    }
}

Function Draw-Image($Result)
{
    #Calling the Assemblies
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $Image = [System.Drawing.Image]::fromfile($Path)
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
