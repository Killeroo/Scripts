#begin
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
        #Clear-Host
    }
    #$colorSelector = Get-Random -InputObject (0..10)
	$colorSelector = Get-Random -InputObject (0..16)
    switch ($colorSelector) {
        1 {$color = "DarkBlue"}
        2 {$color = "DarkGreen"}
        3 {$color = "DarkCyan"}
        4 {$color = "DarkRed"}
        5 {$color = "DarkMagenta"}
        6 {$color = "DarkYellow"}
        7 {$color = "Gray"}
        8 {$color = "DarkGray"}
        9 {$color = "Blue"}
        10 {$color = "Green"}
        11 {$color = "Cyan"}
        12 {$color = "Red"}
        13 {$color = "Magenta"}
        14 {$color = "Yellow"}
        15 {$color = "white"}
        default {$color = "Black"}
    }
    #Write-Host "<<# SegmentID : $blockLength \ Line : $colorSelector #>> " -Foregroundcolor "White" -nonewline
    #for ($count = 0;$count -lt $blockLength;$count++) {
        getRandomSelection
        if ($global:charSelection -eq 1) {
            getRandomCharacter
        } 
        else {
            getRandomNumber
        }
        Write-Host $global:output -Foregroundcolor $color -nonewline
    #}
    #Write-Host
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