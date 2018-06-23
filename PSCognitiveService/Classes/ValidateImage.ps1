#$assembly = 'C:\Data\Powershell\repository\PSCognitiveService\PSCognitiveService\lib\CoreCompat.System.Drawing.dll
#Write-Host $assembly -fore Green
#Add-Type -AssemblyName $assembly

Class ValidateImage {
    ValidateImage() {}
    static [IO.Fileinfo] Dimensions($path, $WidthLower, $HeightLower, $WidthUpper, $HeightUpper) {
        $Image = [System.Drawing.Image]::FromFile($path)
        $Size = $Image.size
        if (-not ($Size.width -in $($WidthLower..$WidthUpper) -or $Size.height -in $($HeightLower..$HeightUpper)) ) {
            Throw "Image dimensions [{4} x {5}] are out of bounds. Dimensions must be Minimum: [{0} x {1}] to Maximum: [{2} x {3}]" -f $WidthLower, $HeightLower, $WidthUpper, $HeightUpper, $size.Width, $Size.Height
        }

        $Image.Dispose()
        return $path
    }
}

# [ValidateImage]::Dimensions($Path, 60, 60,400,400)
# [ValidateImage]::Dimensions($Path, 60, 60,550,521)
# [ValidateImage]::Dimensions($Path, 600, 600,1000,1000)


