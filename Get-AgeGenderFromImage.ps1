Function Get-AgeGenderFromImage
{
[CmdletBinding()]
Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string] $ImagePath
      )

    $Splat = @{
        
        Uri= "https://api.projectoxford.ai/vision/v1/analyses?visualFeatures=All&subscription-key=0436bc9abdbe4f6a90d64b68ef4e96cf"
        Method = 'Post'
        InFile = $ImagePath
        ContentType = 'application/octet-stream'
    }
    Try{

        Draw-Image ((Invoke-RestMethod @Splat).Faces)
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

    $Image = [System.Drawing.Image]::fromfile($ImagePath)
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

Get-AgeGenderFromImage -ImagePath C:\Users\prateesi\Desktop\profile.jpg
