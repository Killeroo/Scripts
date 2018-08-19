# Source: https://stackoverflow.com/a/8024326
function Walk-Directory($path = $pwd, [string[]]$exclude)
{
    foreach ($item in Get-ChildItem $path)
    {
        # Ignore certain files and types
        if ($exclude | Where {$item -like $_}) { continue }

        if (Test-Path $item.FullName -PathType Container) {
            # If folder
            Write-Host("[-] " + $item.FullName)
            Walk-Directory $item.FullName $exclude
        } else {
            # If file
            Write-Host("- " +$item.FullName)
        }
    }
}

Walk-Directory J:\ *.txt,*.bat,"Scripts",9_Populate_Documents.py