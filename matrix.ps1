#begin

$b = (Get-Host).UI.RawUI
$b.BackgroundColor = "Black"
$b.WindowTitle = "The Matrix"
clear-host

Function main() {
	for ($count = 0; $count -lt 100; $count = $count) {
		generateRandomBlock
	}
    generateRandomBlock
    main
}
Function generateRandomBlock() {
    $blockLength = Get-Random -InputObject (15..250)
    if ($blockLength -eq 200) {
        Clear-Host
    }
    $colorSelector = Get-Random -InputObject (0..10)
    switch ($colorSelector) {
        1 {
			$color = "Red"
			Write-Host "ERROR: <<# SegmentID : $blockLength \ Line : $colorSelector #>> " -Foregroundcolor "Red" -Backgroundcolor "White" -nonewline
		}
        2 {
			$color = "Green"
			Write-Host "WARNING: <<# SegmentID : $blockLength \ Line : $colorSelector #>> " -Foregroundcolor "Green" -Backgroundcolor "White" -nonewline
		}
        #default {$color = "White"}
		default {
			$color = "Blue"
			Write-Host "<<# SegmentID : $blockLength \ Line : $colorSelector #>> " -Foregroundcolor "Black" -nonewline
		}
    }
    #Write-Host "<<# SegmentID : $blockLength \ Line : $colorSelector #>> " -Foregroundcolor "Black" -nonewline
    for ($count = 0;$count -lt $blockLength;$count++) {
        getRandomSelection
        if ($global:charSelection -eq 1) {
            getRandomCharacter
        } 
        else {
            getRandomNumber
        }
        Write-Host $global:output -Foregroundcolor $color -nonewline
    }
    # Write-Host
    #getRandomDriveInfo
}
Function getRandomSelection() {
    $global:charSelection = Get-Random -InputObject 1,2
}
Function getRandomCharacter() {
    $global:output = Get-Random -Count 1 -InputObject (31..255) | % {[char]$_}
}
Function getRandomNumber() {
    $global:output = Get-Random -Count 1 -InputObject (60..71) | % {[char]$_}
}
Function getRandomDriveInfo() {
    Get-Random -InputObject (97..104) | % {[char]$_}
    
}
main
#end