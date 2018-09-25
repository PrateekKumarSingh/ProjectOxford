Function Test-FaceMatch {
    [alias("Face")]
    [cmdletbinding()]
    param(
        [System.Guid]$referenceFaceId,
        [System.Guid]$differenceFaceId
    )

    begin {
    }
    process {
        $Object = @()
        if (Test-LocalConfiguration -ServiceName 'Face') {            
            $Object = [Face]::new($env:API_SubscriptionKey_Face, $env:API_Location_Face)
            $Object.verify($referenceFaceId,$differenceFaceId)    
        }
        Remove-Variable -Name Object
    }
    end {
    }
}

Export-ModuleMember -Function Test-FaceMatch -Alias tfm
