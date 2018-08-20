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
            Write-Host("- " + $item.FullName)
            Extract-Content $item.FullName
        }
    }
}

Function Extract-Content($path)
{
    #https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content?view=powershell-6
    Write-Output("`r`n####################`r`n" + $path + "`r`n####################`r`n") | Out-File -Encoding string -Append results.txt
    Get-Content -Path $path -Encoding String | Out-File -Encoding string -Append results.txt
}

Walk-Directory C:\ic-utils 9_Populate_Documents.py,*.exe,*.dll,*.msi,*.mui,*.sdi,*.wim