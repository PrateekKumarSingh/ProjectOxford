function Start-Demo
{
    param($file=".\examples\demo.ps1", [int]$command=0)
    Clear-Host

    $_lines = Get-Content $file
    $_starttime = [DateTime]::now
    Write-Host -for Yellow "<Demo [$file] Started>"


    # We use a FOR and an INDEX ($_i) instead of a FOREACH because
    # it is possible to start at a different location and/or jump 
    # around in the order.
    for ($_i = $Command; $_i -lt $_lines.count; $_i++)
    {    
        #Write-Host -NoNewLine $_SimulatedLine
        Write-Host "`n$([char]9829) " -ForegroundColor Red -NoNewline;
        Write-Host "PS " -NoNewline
        Write-Host "[$_i]" -NoNewline -ForegroundColor DarkCyan
        Write-Host '> ' $($_Lines[$_i])

        # Put the current command in the Window Title along with the demo duration
        $_Duration = [DateTime]::Now – $_StartTime
        $Host.UI.RawUI.WindowTitle = "[{0}m, {1}s]        {2}" -f [int]$_Duration.TotalMinutes, [int]$_Duration.Seconds, $($_Lines[$_i])
        if ($_lines[$_i].StartsWith("#"))
        {
            continue
        }
        $_input=[System.Console]::ReadLine()
        switch ($_input)
        {
            "?"    
                    {
                        Write-Host -ForeGroundColor Yellow "Running demo: $file`n(q) Quit (!) Suspend (#x) Goto Command #x (fx) Find cmds using X`n(t) Timecheck (s) Skip (d) Dump demo"
                        $_i -= 1
                    }
            "q"    
                    {
                        Write-Host -ForeGroundColor Yellow "<Quit demo>"
                        return                    
                    }
            "s"
                    {
                        Write-Host -ForeGroundColor Yellow "<Skipping Cmd>"
                    }
            "d"
                    {
                        for ($_ni = 0; $_ni -lt $_lines.Count; $_ni++)
                        {
                             if ($_i -eq $_ni)
                             {     Write-Host -ForeGroundColor Red ("*" * 80)
                             } 
                             Write-Host -ForeGroundColor Yellow ("[{0,2}] {1}" -f $_ni, $_lines[$_ni])
                        }
                        $_i -= 1
                    }
            "t"    
                    {
                         $_Duration = [DateTime]::Now – $_StartTime
                         Write-Host -ForeGroundColor Yellow $("Demo has run {0} Minutes and {1} Seconds" -f [int]$_Duration.TotalMinutes, [int]$_Duration.Seconds)
                         $_i -= 1
                    }
            {$_.StartsWith("f")}
                    {
                        for ($_ni = 0; $_ni -lt $_lines.Count; $_ni++)
                        {
                             if ($_lines[$_ni] -match $_.SubString(1))
                             {
                                    Write-Host -ForeGroundColor Yellow ("[{0,2}] {1}" -f $_ni, $_lines[$_ni])
                             }
                        }
                        $_i -= 1
                    }
            {$_.StartsWith("!")}
                    {
                         if ($_.Length -eq 1)
                         {
                                 Write-Host -ForeGroundColor Yellow "<Suspended demo – type ‘Exit’ to resume>"
                                 $host.EnterNestedPrompt()
                         }else
                         {
                                 trap [System.Exception] {Write-Error $_;continue;}
                                 Invoke-Expression $($_.SubString(1) + "| out-host")
                         }
                         $_i -= 1
                    }
            {$_.StartsWith("#")}    
                    {
                         $_i = [int]($_.SubString(1)) – 1
                         continue
                    }
            default
                    {
                         trap [System.Exception] {Write-Error $_;continue;}
                         Invoke-Expression $($_lines[$_i] + "| out-host")
                         $_Duration = [DateTime]::Now – $_StartTime
                         $Host.UI.RawUI.WindowTitle = "[{0}m, {1}s]        {2}" -f [int]$_Duration.TotalMinutes, [int]$_Duration.Seconds, $($_Lines[$_i])
                         [System.Console]::ReadLine()
                    }
        }
    }
    $_Duration = [DateTime]::Now – $_StartTime
    Write-Host -ForeGroundColor Yellow $("<Demo Complete {0} Minutes and {1} Seconds>" -f [int]$_Duration.TotalMinutes, [int]$_Duration.Seconds)
    Write-Host -ForeGroundColor Yellow $([DateTime]::now)
}
