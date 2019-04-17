param (
    [Parameter(Mandatory=$true)][string]$root = "C:\",
    [int]$size = 200mb
)

function Walk-Directory($path = $pwd)
{
    foreach ($item in Get-ChildItem $path)
    {
        if (Test-Path $item.FullName -PathType Container) {
            # Recurse back into any directories that we find
            Walk-Directory $item.FullName
        } else {
            if ((Get-Item $item.FullName).Length -lt $size) {
                Write-Warning("[-] " + $item.FullName + " " + [math]::Round((Get-Item $item.FullName).Length / 1mb, 2) + "mb")
            }
        }
    }
}

function Check-File-Size($path)
{
    
}

Walk-Directory $path