# Parameter
$voiceroutingpolicyname = "World"
$pfadzurCSV = "C:\pfadzurcsv\TeamsUser.csv"

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
