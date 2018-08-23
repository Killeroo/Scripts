# Binary detection: https://stackoverflow.com/a/1078277
# Multi threading: https://stackoverflow.com/a/3325931
# Wildcard to scrape everything
# Seperate out into multiple files
# Clear results path

param (
    [string]$root = "C:\",
    [string[]]$scrape = ".txt",
    [string[]]$excludes = "",
    [string]$resultsPath = "results.txt"
)

$Global:Stats = @{
    FilesScraped     = [uint64] 0;
    FilesParsed      = [uint64] 0;
    ItemsIgnored     = [uint64] 0;
    FoldersSearched  = [uint64] 0;
    ReadWriteErrors  = [uint64] 0;
    TotalScrapedData = [uint64] 0;
}

# Source: https://stackoverflow.com/a/8024326
function Walk-Directory($path = $pwd, [string[]]$exclude, [string[]]$extract)
{
    foreach ($item in Get-ChildItem $path) # Replace with .net function? mmm maybe not that file type is useful and should be pretty quick anyway compared to copying
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
                Write-Host "Done"
                $Stats.TotalScrapedData += $item.Length / 1KB
                Write-Warning $Stats.TotalScrapedData

            } else {
                Write-Host
            }
        }
    }
}

Function Extract-Content($path)
{
    #https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content?view=powershell-6
    # Speed tests Measure-Command { .cs,.go.txt} 
    #https://kevinmarquette.github.io/2017-03-18-Powershell-reading-and-saving-data-to-files/#saving-and-reading-data
    # Using .net native functions - http://www.happysysadm.com/2014/10/reading-large-text-files-with-powershell.html
    # Add-content vs out-file - basically the same, add content has more parameters?
    try {
        Write-Output("`r`n####################`r`n" + $path + "`r`n####################`r`n") | Out-File -Encoding string -Append "$resultsPath$([IO.Path]::DirectorySeparatorChar)results.txt"
        #Get-Content -Path $path -Encoding String | Out-File -Encoding string -Append "$resultsPath$([IO.Path]::DirectorySeparatorChar)results.txt"
        [System.IO.File]::ReadLines($path) | Out-File -Encoding string -Append "$resultsPath$([IO.Path]::DirectorySeparatorChar)results.txt"
        #Get-Content -Path $path -Encoding String | Out-File -Encoding string -Append "$resultsPath$([IO.Path]::DirectorySeparatorChar)results.txt"
    } catch {
        Write-Warning("Problem occured during scraping: " + $path)
    }
}


Walk-Directory $root $excludes $scrape