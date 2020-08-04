# Parameter
#$pstnusageDE =  "DE national"
$pstnusageInternational = "International"
$voicerouteidentity1 = "SBC1 - HFO"
$voicerouteidentity2 = "SBC2 - HFO"
#$numberpatternDE = "^(\+49\d*)"
$numberpatternInternational = "^(\+\d*)"
$voiceroutingpolicyname = "World"
$pfadzurCSV = "C:\pfadzurcsv\TeamsUser.csv"
$sbc1 = "Kunde.sbc1.getdirectrouting.de"
$sbc2 = "Kunde.sbc2.getdirectrouting.de"

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
    Set-CsUser -Identity $teamsuser.UPN -EnterpriseVoiceEnabled $true -HostedVoiceMail $true -OnPremLineURI $teamsuser.phone
    Write-Host -ForegroundColor Green $teamsuser.UPN " Enterprise Voice Enabled und Telefonnummer zugewiesen"
}


# Konfiguration Voice Routing
Set-CsOnlinePstnUsage  -Identity Global -Usage @{Add=$pstnusageInternational}
New-CsOnlineVoiceRoute -Identity $voicerouteidentity1 -NumberPattern $numberpatternInternational -OnlinePstnGatewayList $sbc1 -Priority 1 -OnlinePstnUsages $pstnusageInternational
New-CsOnlineVoiceRoute -Identity $voicerouteidentity2 -NumberPattern $numberpatternInternational -OnlinePstnGatewayList $sbc2 -Priority 2 -OnlinePstnUsages $pstnusageInternational
New-CsOnlineVoiceRoutingPolicy $voiceroutingpolicyname -OnlinePstnUsages $pstnusageInternational

foreach ($user in $teamscsvcontent) {
    Grant-CsOnlineVoiceRoutingPolicy -Identity $user.UPN -PolicyName $voiceroutingpolicyname
    Grant-CsDialOutPolicy -Identity $user.UPN -PolicyName "Tag:DialoutCPCandPSTNInternational"
    Write-Host -ForegroundColor Green $user.UPN " RoutingPolicy zugewiesen"
}
Remove-PSSession $session