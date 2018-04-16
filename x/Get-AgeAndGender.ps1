<#.Synopsis
Returns information about Age and Gender of identified faces in a local Image.
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
                Errorvariable = E
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
    end
    {}
}