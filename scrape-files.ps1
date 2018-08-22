# Binary detection: https://stackoverflow.com/a/1078277

param (
    [string]$root = "C:\",
    [string[]]$scrape = ".txt",
    [string[]]$excludes = ".py",
    [string]$path = "results.txt"
)

# Source: https://stackoverflow.com/a/8024326
function Walk-Directory($path = $pwd, [string[]]$exclude, [string[]]$extract)
{
    foreach ($item in Get-ChildItem $path)
    {
        # Ignore certain files and types
        if ($exclude | Where {$item -like $_}) { continue }

        if (Test-Path $item.FullName -PathType Container) {
            # If folder
            Write-Host("[-] " + $item.FullName)
            Walk-Directory $item.FullName $exclude $extract
        } else {
            # If file
            Write-Host("- " + $item.FullName) -NoNewline 

            # Check if we want to extract file type
            if ($extract | Where {$item.Extension -like $_}) {
                Write-Host " [*]"
                Extract-Content $item.FullName
            } else {
                Write-Host
            }
        }
    }
}

Function Extract-Content($path)
{
    #https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content?view=powershell-6
    try {
        Write-Output("`r`n####################`r`n" + $path + "`r`n####################`r`n") | Out-File -Encoding string -Append results.txt
        Get-Content -Path $path -Encoding String | Out-File -Encoding string -Append "$resultsPath$([IO.Path]::DirectorySeparatorChar)results.txt"
    } catch {
        Write-Warning("Problem occured during scraping: " + $path)
    }
}

Set-Location 
Walk-Directory $root $excludes $scrape