# Import Teams Modul
if (Get-Module -ListAvailable -Name MicrosoftTeams)
{
    Import-Module MicrosoftTeams 
}
else
{ 
    Install-Module -Name MicrosoftTeams
    Import-Module MicrosoftTeams

}
# Sitzung erstellen und verbinden
$session = New-CsOnlineSession
Import-PSSession $session -AllowClobber

Get-CsTenant | Select-Object Domainurlmap 
