﻿# TODO: 
#       - parameterize the following: username and password for $credentials, ConnectionUri for $session (make it use server name by default)
#       - make it so if no username or password is specified, it jsut uses the current credentials which will work if the script is being run on the exchange server

# Connect to the Exchange Server
$username = "capstone\administrator"
$password = ConvertTo-SecureString 'Password1' -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $password
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://WIN-90T98I75S6C.capstone.net/PowerShell -Credential $credentials
Import-PSSession $session -AllowClobber

# Configure a Send Connector that connects to the internet
New-SendConnector -Name "SMTP Mail Send" -Internet -AddressSpaces capstone.net -SourceTransportServers WIN-90T98I75S6C

#Set Default Email Policy
Set-EmailAddressPolicy -Identity "Default Policy" -EnabledEmailAddressTemplates "SMTP:%g.%s@capstone.net"
Update-EmailAddressPolicy -Identity "Default Policy"

# Update Firewall Rules
New-NetFirewallRule -DisplayName "SMTP UDP In" -Direction Inbound -Action Allow -Protocol UDP -LocalPort 25
New-NetFirewallRule -DisplayName "SMTP TCP In" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 25
New-NetFirewallRule -DisplayName "SMTP UDP Out" -Direction Outbound -Action Allow -Protocol UDP -LocalPort 25
New-NetFirewallRule -DisplayName "SMTP TCP Out" -Direction Outbound -Action Allow -Protocol TCP -LocalPort 25