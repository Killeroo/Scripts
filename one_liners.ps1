# Collection of powershell one-liners

# Look for string in all files of a the current directory (and sub-directories)
Get-ChildItem -recurse | select-string -pattern "search_string" | group path | select name

# Search for files names in current directory (and sub-directories)
get-childitem -include *.sh -recurse

# Lets you change the console cursors position
$pos = $host.UI.RawUI.CursorPosition; $pos.x += 5; $host.UI.RawUI.CursorPosition = $pos;

# Show all properties of an object
Get-WmiObject win32_computersystem | Format-List * -Force