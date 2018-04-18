class ValidateFile {
    ValidateFile() {}
    Static [System.IO.Fileinfo] Path([System.IO.Fileinfo] $path) {
        if ([string]::IsNullOrWhiteSpace($path)) {Throw [System.ArgumentNullException]::new()}
        if (-not (Test-Path -Path $path)) {Throw [System.IO.FileNotFoundException]::new()}
        if (-not (Test-Path $path -PathType Leaf)) {Throw "The Path argument must be a file. Folder paths are not allowed."}
        return $path
    }

    Static [System.IO.Fileinfo] Extension([System.IO.Fileinfo] $path, [String[]] $extension) {
        $regex = "({0})" -f ($extension.foreach( {"\." + $_}) -join '|')
        if ($path -notmatch $regex) {throw "The extension of the file specified must be either of: $extension"}
        return $path
    }

    Static [System.IO.Fileinfo] Size([System.IO.Fileinfo] $path, [double] $maxSizeInMB) {
        if ($path.Length / 1mb -gt $maxSizeInMB) {Throw "The Image file size can not be greater than 4MB"}
        return $path
    }
}

# [ValidateFile]::Path($path)
# [ValidateFile]::Extension($path, @('jpg', 'png'))
# [ValidateFile]::Size($path, 1)
