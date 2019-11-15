param (
    [Parameter(Mandatory=$true)][string]$root = "C:\",
    [Parameter(Mandatory=$true)][int]$size = 200mb,
    [Parameter(Mandatory=$true)][string[]]$include = (".php", ".gem")
)

$Global:fileSizeLimit = ($size * 1024 * 1024)

function Walk-Directory($path = $pwd)
{
    # Loop through everything in the folder 
    foreach ($item in Get-ChildItem $path)
    {
        # Check if its a folder, or a file
        if (Test-Path $item.FullName -PathType Container) {
            # Recurse back into any directories that we find
            Walk-Directory $item.FullName
        } else {
            # Only check files of a certain type
            if (!$include.Contains($item.Extension)) { continue }

            Check-File-Size $item
        }
    }
}

function Check-File-Size($filePath)
{
    if ((Get-Item $filePath.FullName).Length -lt $fileSizeLimit) {
        Write-Host("[" + [math]::Round((Get-Item $filePath.FullName).Length / 1mb, 2) + "mb] ") -ForegroundColor Red -NoNewline
        Write-Host($filePath.FullName)
    }
}

Write-Host "Searching for files with extensions ($($include)) that are smaller than $($fileSizeLimit/1mb)mb..."
Walk-Directory $path