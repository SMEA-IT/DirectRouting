# Parameter
#$pstnusageDE =  "DE national"
$pstnusageInternational = "International"
$voicerouteidentity1 = "SBC1"
$voicerouteidentity2 = "SBC2"
#$numberpatternDE = "^(\+49\d*)"
$numberpatternInternational = "\d+"
$voiceroutingpolicyname = "World"
$pfadzurCSV = "C:\pfadzurcsv\TeamsUser.csv"
$sbc1 = "kunden.sbc1.getdirectrouting.de"
$sbc2 = "kunden.sbc2.getdirectrouting.de"

# Import Teams Modul
if (Get-Module -ListAvailable -Name MicrosoftTeams)
{
    Import-Module MicrosoftTeams 
}
else
{ 
    Install-Module -Name MicrosoftTeams -AllowClobber -RequiredVersion 4.8.0
    Import-Module MicrosoftTeams

}
# Sitzung erstellen und verbinden
Connect-MicrosoftTeams

# CSV Datei einlesen
$teamscsvcontent = Import-Csv -path $pfadzurCSV -Delimiter ";"
try
{
    # Benutzer aktivieren und verwalten
    foreach ($teamsuser in $teamscsvcontent) {
    Set-CsPhoneNumberAssignment -Identity $teamsuser.mail -PhoneNumber $teamsuser.phone -PhoneNumberType DirectRouting
    Set-CsPhoneNumberAssignment -Identity $teamsuser.mail -EnterpriseVoiceEnabled $true
    Write-Host -ForegroundColor Green $teamsuser.mail " Enterprise Voice Enabled und Telefonnummer zugewiesen"
    }
}
catch
{
    Write-Host -ForegroundColor Red $_.Exception
}


# Konfiguration Voice Routing
try 
{
    Set-CsOnlinePstnUsage  -Identity Global -Usage @{Add=$pstnusageInternational}
    New-CsOnlineVoiceRoute -Identity $voicerouteidentity1 -NumberPattern $numberpatternInternational -OnlinePstnGatewayList $sbc1 -Priority 1 -OnlinePstnUsages $pstnusageInternational
    New-CsOnlineVoiceRoute -Identity $voicerouteidentity2 -NumberPattern $numberpatternInternational -OnlinePstnGatewayList $sbc2 -Priority 2 -OnlinePstnUsages $pstnusageInternational
    New-CsOnlineVoiceRoutingPolicy $voiceroutingpolicyname -OnlinePstnUsages $pstnusageInternational
}
catch 
{
    Write-Host -ForegroundColor Red $_.Exception
}

# Voice Routing Policy den Usern zuweisen
try 
{
    foreach ($user in $teamscsvcontent) {
        Grant-CsOnlineVoiceRoutingPolicy -Identity $user.mail -PolicyName $voiceroutingpolicyname
        Grant-CsDialOutPolicy -Identity $user.mail -PolicyName "Tag:DialoutCPCandPSTNInternational"
        Write-Host -ForegroundColor Green $user.mail " RoutingPolicy zugewiesen"
    }
}
catch 
{
    Write-Host -ForegroundColor Red $_.Exception
}

disconnect-MicrosoftTeams
