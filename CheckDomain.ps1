# Import Teams Modul
if (Get-Module -ListAvailable -Name MicrosoftTeams)
{
    Import-Module MicrosoftTeams 
}
else
{  
    Install-Module -Name MicrosoftTeams -AllowClobber -force
    Import-Module MicrosoftTeams

}
# Sitzung erstellen und verbinden
Connect-MicrosoftTeams

$domains = Get-CsTenant | Select-Object VerifiedDomains, SIPDomain
$domains.SipDomain
$domains.VerifiedDomains
