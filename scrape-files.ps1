# TODO:
# Binary detection: https://stackoverflow.com/a/1078277
# Wildcard to scrape everything
# Seperate out into multiple files

param (
    [Parameter(Mandatory=$true)][string]$root = "C:\",
    [string[]]$scrape = "*",
    [string[]]$excludes = "",
    [string]$outPath = $PWD,
    [string]$outFileName = "results.txt"
)

$Global:extractAll = if ($scrape.Contains("*")) {$true} else {$false}
$Global:outFullPath = "$outPath$([IO.Path]::DirectorySeparatorChar)$outFileName"
$Global:stats = @{
    FilesScraped     = [uint64] 0;
    FilesProcessed   = [uint64] 0;
    FoldersProcessed = [uint64] 0;
    ItemsIgnored     = [uint64] 0;
    TotalSeconds     = [int32] 0;
    Errors           = [uint64] 0;
    DataScrapedKB = [uint64] 0;
}

# Recursively walks through a directory, ignoring wildcards and paths in $exclude and extracting the contents of file types
# in $extract
# Based on: https://stackoverflow.com/a/8024326
function Walk-Directory($path = $pwd, [string[]]$exclude, [string[]]$extract)
{
    foreach ($item in Get-ChildItem $path)
    {
        # Ignore certain files and types
        if ($exclude | Where {$item -like $_}) { $stats.ItemsIgnored += 1; continue }

        if (Test-Path $item.FullName -PathType Container) { # If folder
            $stats.FoldersProcessed += 1
            
            Write-Host("[-] " + $item.FullName)
            Walk-Directory $item.FullName $exclude $extract
        } else { # If file
            $stats.FilesProcessed += 1

            # Check if we want to scrape file type
            if ($extract | Where {$item.Extension -like $_}) {
                if (Extract-Contents($item.FullName)) {
                    Write-Host("- " + $item.FullName) -BackgroundColor Green -ForegroundColor Black
                } else {
                    Write-Host("- " + $item.FullName) -BackgroundColor Red -ForegroundColor Black
                }
            } else {
                Write-Host("- " + $item.FullName)
            }
        }
    }

}

# Reads contents of a given file and outputs the raw data to a results text file (specified in $Global:outFullPath)
Function Extract-Contents([System.IO.FileInfo]$file) #$path)
{
    #TODO: Test speeds of different functions - http://www.happysysadm.com/2014/10/reading-large-text-files-with-powershell.html
    try {
        Write-Output("`r`n####################`r`n" + $file.FullName + "`r`n####################`r`n") | Out-File -Encoding string -Append $outFullPath
        [System.IO.File]::ReadLines($file.FullName) | Out-File -Encoding string -Append $outFullPath -ErrorAction Stop

        $stats.FilesScraped += 1
        $stats.DataScrapedKB += $item.Length / 1KB
        return $true
    } catch {
        Write-Warning("Error scraping file: $($_.Exception.GetType().FullName): $($_.Exception.Message)")

        $stats.Errors += 1
        return $false
    }
}

# Checks if results file is over certain size and creates new file for results
#TODO: implement
Function Check-Outfile-Size()
{
    $size = ([System.IO.FileInfo]($outFullPath).Length) / 1KB
    if ($size > 5000)
    {
        Write-Warning "Oversized"
    }
}


Function Print-Stats() 
{
    Write-Host ("


Files Scraped      : $($stats.FilesScraped)
Files Processed    : $($stats.FilesProcessed)
Folders Processed  : $($stats.FoldersProcessed)
Items Ignored      : $($stats.ItemsIgnored)
Errors             : $($stats.Errors)
Data Scraped       : $([math]::Round(($stats.DataScrapedKB)))KB
Total Seconds      : $([math]::Round($stats.TotalSeconds))
Out file           : $($outFullPath)


    ");
}

Clear-Content $outFullPath -ErrorAction SilentlyContinue
$stats.TotalSeconds = $(Measure-Command { Walk-Directory $root $excludes $scrape }).TotalSeconds
Print-Stats