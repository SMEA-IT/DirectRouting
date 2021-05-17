# Import Teams Modul
if (Get-Module -ListAvailable -Name MicrosoftTeams)
{
    Import-Module MicrosoftTeams 
}
else
{ 
    Install-Module -Name MicrosoftTeams -AllowClobber -RequiredVersion 2.0.0
    Import-Module MicrosoftTeams

}
# Sitzung erstellen und verbinden
$session = Connect-MicrosoftTeams

Get-CsTenant | Select-Object Domainurlmap 
