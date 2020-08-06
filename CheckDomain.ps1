# Import SkypeOnlineConnector Modul / Check ob SkypeOnlineConnector Modul installiert ist 
if (Get-Module -ListAvailable -Name SkypeOnlineConnector)
{
    Import-Module SkypeOnlineConnector 
}
else
{ 
    Write-Host "Please Download SkypeOnlineConnector Modul here: https://www.microsoft.com/en-us/download/details.aspx?id=39366 and start again"

}
# Sitzung erstellen und verbinden
$session = New-CsOnlineSession  
Import-PSSession $session -AllowClobber

Get-CsTenant | Select-Object Domainurlmap 