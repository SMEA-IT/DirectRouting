# Parameter
$voiceroutingpolicyname = "World"
$pfadzurCSV = "C:\pfadzurcsv\TeamsUser.csv"

# Import Teams Modul
if (Get-Module -ListAvailable -Name MicrosoftTeams)
{
    Import-Module MicrosoftTeams 
}
else
{ 
    Install-Module -Name MicrosoftTeams -AllowClobber -RequiredVersion 3.0.0
    Import-Module MicrosoftTeams

}
# Sitzung erstellen und verbinden
$session = Connect-MicrosoftTeams

# CSV Datei einlesen
$teamscsvcontent = Import-Csv -path $pfadzurCSV -Delimiter ";"

# Benutzer aktivieren und verwalten
foreach ($teamsuser in $teamscsvcontent) {
    Set-CsUser -Identity $teamsuser.mail -EnterpriseVoiceEnabled $true -HostedVoiceMail $true -OnPremLineURI $teamsuser.phone
    Write-Host -ForegroundColor Green $teamsuser.mail " Enterprise Voice Enabled und Telefonnummer zugewiesen"
}

foreach ($user in $teamscsvcontent) {
    Grant-CsOnlineVoiceRoutingPolicy -Identity $user.mail -PolicyName $voiceroutingpolicyname
    Grant-CsDialOutPolicy -Identity $user.mail -PolicyName "Tag:DialoutCPCandPSTNInternational"
    Write-Host -ForegroundColor Green $user.mail " RoutingPolicy zugewiesen"
}
Remove-PSSession $session
