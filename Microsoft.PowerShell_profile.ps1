function ffind { Get-ChildItem -recurse | select-string -pattern $args | group path | select name }
function cs($path)
{ 
	Set-Location $path
	Get-Childitem . 
} 
function scan { skimmer --address $args --threads 10 --all }
function edit { micro $args }
function config { micro %userprofile%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 }
function update_svn($path = $pwd)
{
    foreach ($item in Get-ChildItem $path)
    {
        if (Test-Path $item.FullName -PathType Container) 
        {
        	Set-Location $item.FullName
            Write-Host("[-] Trying to update " + $item.FullName);
            svn update
            Set-Location ..
        }
    }
}

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

Set-Location E:\
