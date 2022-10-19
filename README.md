# DirectRouting
Anleitung zu Einrichten von Direct Routing in Teams
1.	Was wird benötigt
•	Jeder Nutzer benötigt eine Teamslizenz und eine Phonesystem Lizenz
•	Kurzfristig eine Skype For Business Online P1 Lizenz für die Domainaktivierung
•	Powershellkenntnisse und Zugriff als Administrator
•	Zugriff als Tenantadministrator

2.	Vorbereitung

-	O365/M365 Nutzern die PhoneSystem / Business Voice Lizenz zuweisen

-	Laden Sie die ZIP Datei von unserem GitHub Repository herunter:  

-	Entpacken Sie diese ZIP Datei

-	Für die Einrichtung wird die CSV Datei aus der ZIP Datei benötigt. Bitte passen Sie die Datei wie folgt an:

Die CSV Datei hat zwei Spalten -> mail und Phone

Als Mail muss die Mailadresse (Office 365 Nutzer) des Nutzer hinterlegt werden.

Als Phone muss die Telefonnummer im Format: tel:+49123456789 eingetragen werden.

  
Speichern Sie diese Datei Bitte im MS-DOS Format als CSV

 
-	Einrichtung Microsoft Teams für Powershell

o	Powershell Modul installieren mir Install-Module -Name MicrosoftTeams -AllowClobber -RequiredVersion 2.0.0

o	Import-Module MicrosoftTeams 


-	Domain einrichten (2 Domänen)

Einrichtung erfolgt für jede Domäne einzeln

•	Im Admin Portal von Microsoft 365 anmelden (mit Adminrechten) https://admin.microsoft.com

•	Im linken Menüband auf „Alle Anzeigen“ klicken

•	Menüpunkt Einstellungen auswählen

•	Menüpunkt Domänen auswählen 

•	 
•	Eine neue Domäne hinzufügen

•	 
•	Die Domänennamen stehen in der E-Mail

•	 
•	Klicken Sie auf „Diese Domäne verwenden“

•	Im nächsten Schritt wählen Sie „Fügen Sie einen TXT-Eintrag zu den DNS-Einträgen der Domäne hinzu“

•	Notieren Sie den TXT Wert auf der nachfolgenden Seite

•	 
•	Beenden Sie die Domäneneinrichtung auf der Seite mit „Schließen“

•	Wiederholen Sie die Schritte für die zweite Domäne

•	Senden Sie uns diese beiden TXT Einträge per E-Mail, damit wir diese für den SBC registrieren können

•	Sobald wir den Eintrag gesetzt haben, kann die Domäne überprüft werden

•	Um die Überprüfung zu starten, wählen Sie die erstellte Domäne aus, und klicken Sie auf „Einrichtung starten“ 

•	Klicken Sie auf „Weiter“

•	Klicken Sie auf „Überprüfen“

•	Nach erfolgreicher Überprüfung klicken Sie auf Weiter und entfernen Sie den Haken bei „Exchange und Exchange Online Protection“ und klicken Sie auf Weiter

•	Beide Domänen sollten den Status „keine Dienste ausgewählt“ haben

•	Die Domäneneinrichtung ist hiermit beendet


-	Microsoft 365 Benutzer einrichten

•	Im Menü Aktive Benutzer klicken Sie auf Benutzer hinzufügen

•	Vergeben Sie Vor und Nachname z.B.  

•	Entfernen Sie den Haken bei „Anfordern, dass dieser… Kennwort ändert“

•	Klicken Sie auf Weiter

•	Weisen Sie dem Benutzer die zusätzliche Lizenz zu  

•	Klicken Sie auf Weiter

•	Auf der nächsten Seite klicken Sie auf Weiter

•	Klicken Sie auf Hinzufügen fertig stellen

•	Schließen Sie das Fenster

•	Jetzt wird die Domäne bei Microsoft aktiviert. Dieser Vorgang kann bis zu 60 Minuten dauern

o	Nach erfolgreicher Aktivierung kann die Lizenz dem Nutzer wieder entzogen werden

o	Für den zweiten Nutzer wiederholen Sie Bitte die Schritte

•	

3.	Einrichtung mit Hilfe der Powershell
•	Powershell ISE als Administrator öffnen

•	Öffnen Sie die Powershell Script Datei (.ps1) aus der vorab heruntergeladenen entpackten ZIP Datei 

•	Passen Sie folgende Variablen an

•	Zeile 9: Ändern Sie den Pfad zur vorher gespeicherten CSV Datei

•	Zeile 10: Ersetzen Sie den FQDN durch die erste Domäne aus unserer E-Mail

•	Zeile 11: Ersetzen Sie den FQDN durch die zweite Domäne aus unserer E-Mail

•	Führen Sie das Script aus

•	Während der Ausführung werden Sie aufgefordert Office 365 Tenant Administraor Benutzername und Passwort einzugeben 

•	Bis die Änderungen bei Microsoft synchronisiert sind, dauert es mindestens 5 Stunden

•	Überprüft werden kann die Konfiguration der Nutzer mit folgendem Powershell-Befehl (Sie müssen angemeldet sein):

•	Get-CsOnlineUser | Select-Object SipProxyAddress, OnPremLineURI, InterpretedUserType, EnterpriseVoiceEnabled

In der Ausgabe muss dann folgendes stehen:

Unter SipProxyAddress: sip:maxmustermann@smea-it.de

Unter OnPremLineURI: tel:+49123456789

Unter InterpretedUserType sollte nichts mit "failed" oder ähnlichem stehen

Unter EnterpriseVoiceEnabled: True

•	Sobald die Änderungen bei Microsoft synchronisiert sind, erscheint im Teams Client unter Anrufe ein Nummernfeld sowie darüber Ihre Telefonnummer










