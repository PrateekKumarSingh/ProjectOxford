using namespace System.Drawing;
using namespace System.Drawing.Image;

Class ValidateImage {
    ValidateImage() {
    }
    static [IO.Fileinfo] Dimensions($path, $WidthLower, $HeightLower, $WidthUpper, $HeightUpper) {
        $Size = [System.Drawing.Image]::FromFile($path).size
        if (-not ($Size.width -in $($WidthLower..$WidthUpper) -or $Size.height -in $($HeightLower..$HeightUpper)) ) {
            Throw "Image dimensions [{4} x {5}] are out of bounds. Dimensions must be Minimum: [{0} x {1}] to Maximum: [{2} x {3}]" -f $WidthLower, $HeightLower, $WidthUpper, $HeightUpper, $size.Width, $Size.Height
        }
        return $path
    }
}

# [ValidateImage]::Dimensions($Path, 60, 60,400,400)
# [ValidateImage]::Dimensions($Path, 60, 60,550,521)
# [ValidateImage]::Dimensions($Path, 600, 600,1000,1000)
