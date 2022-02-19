$Global:computerSpecFilename = "specs.txt"

function Write-Logo()
{
    @(("         ,.=:^!^!t3Z3z.,`n","red"), ("        :tt:::tt333EE3`n","red"),("        Et:::ztt33EEE","red"),("  @Ee.,      ..,`n","green"),("       ;tt:::tt333EE7","red"),(" ;EEEEEEttttt33#`n","green"),("      :Et:::zt333EEQ.","red"),(" SEEEEEttttt33QL`n","green"),("      it::::tt333EEF","red"),(" @EEEEEEttttt33F`n","green"),("     ;3=*^``````'*4EEV","red"),(" :EEEEEEttttt33@.`n","green"),("     ,.=::::it=.,","cyan"),(" ``","red"),(" @EEEEEEtttz33QF`n","green"),("    ;::::::::zt33)","cyan"),("   '4EEEtttji3P*`n","green"),("   :t::::::::tt33.","cyan"),(":Z3z..","yellow"),("  ````","green"),(" ,..g.`n","yellow"),("   i::::::::zt33F","cyan"),(" AEEEtttt::::ztF`n","yellow"),("  ;:::::::::t33V","cyan"),(" ;EEEttttt::::t3`n","yellow"),("  E::::::::zt33L","cyan"),(" @EEEtttt::::z3F`n","yellow"),(" {3=*^``````'*4E3)","cyan"),(" ;EEEtttt:::::tz```n","yellow"),("             ``","cyan"),(" :EEEEtttt::::z7`n","yellow"),("                 'VEzjt:;;z>*```n","yellow"),("                      ````","yellow")) | Foreach-Object {Write-Host $_[0] -ForegroundColor $_[1] -NoNewline}
}

function Set-Position($x, $y)
{
    $pos = $host.UI.RawUI.CursorPosition; $pos.x += $x; $pos.y -= $y; $host.UI.RawUI.CursorPosition = $pos;

}

function Write-Info($offset = 0)
{
    # Check if info exists, create it if it doesn't
    $powershellPath = Split-Path -Path $profile
    $specFilePath = Join-Path -Path $powershellPath -ChildPath $Global:computerSpecFilename
    if ((Test-Path -Path $specFilePath -PathType Leaf) -eq $false)
    {
        Write-Warning("Performing first time load, thing might take a sec...")
        Get-Specs
    }

    # Read file and get specs
    $specsFile = Get-Content $specFilePath
    $username = ($specsFile | where-object { $_ -like '*CsUserName*'}).split(":")[1].Trim()
    Write-Host $username

}

function Get-Specs()
{
    Get-ComputerInfo | Out-File $specFilePath
    Get-WmiObject win32_videocontroller | Add-Content -Path $specFilePath
    Get-WmiObject win32_networkadapter | Add-Content -Path $specFilePath
}

Write-Logo
Write-Info
Set-Position 5 5
Write-Host "Test"

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
<#
@(("         ,.=:^!^!t3Z3z.,`n","red"), ("        :tt:::tt333EE3`n","red"),("        Et:::ztt33EEE","red"),("  @Ee.,      ..,`n","green"),("       ;tt:::tt333EE7","red"),(" ;EEEEEEttttt33#`n","green"),("      :Et:::zt333EEQ.","red"),(" SEEEEEttttt33QL`n","green"),("      it::::tt333EEF","red"),(" @EEEEEEttttt33F`n","green"),("     ;3=*^``````'*4EEV","red"),(" :EEEEEEttttt33@.`n","green"),("     ,.=::::it=.,","cyan"),(" ``","red"),(" @EEEEEEtttz33QF`n","green"),("    ;::::::::zt33)","cyan"),("   '4EEEtttji3P*`n","green"),("   :t::::::::tt33.","cyan"),(":Z3z..","yellow"),("  ````","green"),(" ,..g.`n","yellow"),("   i::::::::zt33F","cyan"),(" AEEEtttt::::ztF`n","yellow"),("  ;:::::::::t33V","cyan"),(" ;EEEttttt::::t3`n","yellow"),("  E::::::::zt33L","cyan"),(" @EEEtttt::::z3F`n","yellow"),(" {3=*^``````'*4E3)","cyan"),(" ;EEEtttt:::::tz```n","yellow"),("             ``","cyan"),(" :EEEEtttt::::z7`n","yellow"),("                 'VEzjt:;;z>*```n","yellow"),("                      ````","yellow")) | Foreach-Object {Write-Host $_[0] -ForegroundColor $_[1] -NoNewline}

Write-Host
Write-Host("\\\\") -nonewline;
Write-Host((Get-WmiObject win32_computersystem).Domain) -ForegroundColor DarkGreen -nonewline;
Write-Host("\\") -nonewline;Write-Host((Get-WmiObject win32_computersystem).Name + " ") -ForegroundColor Green -nonewline ; 
Write-Host([math]::Round((Get-WmiObject win32_computersystem).TotalPhysicalMemory/1GB)) -ForegroundColor red -nonewline;
Write-Host("GB ") -ForegroundColor red -nonewline; 
#Write-Host((Get-WmiObject win32_processor).Name + " ") -ForegroundColor yellow -nonewline; 
#Write-Host((Get-WmiObject win32_videocontroller).Name) -ForegroundColor cyan; 
Write-Host((gwmi Win32_NetworkAdapterConfiguration|?{$_.ipenabled -and $_.dhcpenabled}).IPAddress) -ForegroundColor Magenta
Write-Host
#>

