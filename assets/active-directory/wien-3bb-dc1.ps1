Enable-PSRemoting -Force
Set-Item WSMan:localhost\client\TrustedHosts -Value "*" -Force
Set-NetFirewallRule -DisplayName "Windows-Remoteverwaltung (HTTP eingehend)" -Profile Public -Enabled True


# INT-CONFIG

Rename-computer WIEN-3BB-DC1

Rename-Netadapter -Name Ethernet0 -NewName internal
New-NetIPAddress -IPAddress 10.1.18.10 -InterfaceAlias internal -DefaultGateway 10.1.18.254 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias internal -ServerAddresses ("10.1.18.10", "10.1.18.11")

Set-TimeZone -ID "W. Europe Standard time"
w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /reliable:yes /update

Restart-Computer

#---- Neustart



Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName wien.3bb-testlab.at -SafeModeAdministratorPassword $pw

#---- Neustart



# Site WIEN
Get-ADObject -SearchBase (Get-ADRootDSE).ConfigurationNamingContext -filter "objectclass -eq 'site'" | Rename-ADObject -NewName Wien

# Site EISENSTADT
New-ADReplicationSite -Name "Eisenstadt"
New-ADReplicationSiteLink -Name "Wien-Eisenstadt" -SitesIncluded Wien,Eisenstadt -Cost 100 -ReplicationFrequencyInMinutes 15 -InterSiteTransportProtocol IP
Remove-ADReplicationSiteLink -Identity DEFAULTIPSITELINK

# OUs
New-ADOrganizationalUnit -Name "Wien" -Path "DC=wien,DC=3bb-testlab,DC=at"
New-ADOrganizationalUnit -Name "Servers" -Path "OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADOrganizationalUnit -Name "Users" -Path "OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADOrganizationalUnit -Name "Computers" -Path "OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
Get-ADOrganizationalUnit -Filter "Name -like '*'"

# Global Groups
New-ADGroup -Name "Management" -GroupCategory Security -GroupScope Global -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADGroup -Name "Finance" -GroupCategory Security -GroupScope Global -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADGroup -Name "Office" -GroupCategory Security -GroupScope Global -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADGroup -Name "Marketing" -GroupCategory Security -GroupScope Global -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADGroup -Name "IT" -GroupCategory Security -GroupScope Global -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADGroup -Name "SOC" -GroupCategory Security -GroupScope Global -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADGroup -Name "Protected Users" -GroupCategory Security -GroupScope Global -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"

# User erstellen (PW: team3bb123!)
$pw = convertto-securestring -string "Team3bb123!" -asplaintext -force
# New-ADUser -AccountPassword $pw -Name "Sarah Müller" -DisplayName smueller -Enabled $true -SAMAccountName smueller -UserPrincipalName smueller -Department Geschäftsfürhung -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"

# Management
New-ADUser -AccountPassword $pw -Name "Max Mustermann" -DisplayName "Max Mustermann" -Enabled $true -SAMAccountName "mmustermann" -UserPrincipalName "mmustermann@3bb-testlab.at" -Department "Management" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADUser -AccountPassword $pw -Name "Anna Becker" -DisplayName "Anna Becker" -Enabled $true -SAMAccountName "abecker" -UserPrincipalName "abecker@3bb-testlab.at" -Department "Management" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADUser -AccountPassword $pw -Name "Bernd Schmidt" -DisplayName "Bernd Schmidt" -Enabled $true -SAMAccountName "bschmidt" -UserPrincipalName "bschmidt@3bb-testlab.at" -Department "Management" -ChangePasswordAtLogon $false -Path "OU=Users,OU=wien,DC=wien,DC=3bb-testlab,DC=at"

# Finance
New-ADUser -AccountPassword $pw -Name "Sophie Klein" -DisplayName "Sophie Klein" -Enabled $true -SAMAccountName "sklein" -UserPrincipalName "sklein@3bb-testlab.at" -Department "Finance" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADUser -AccountPassword $pw -Name "Lukas Fischer" -DisplayName "Lukas Fischer" -Enabled $true -SAMAccountName "lfischer" -UserPrincipalName "lfischer@3bb-testlab.at" -Department "Finance" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADUser -AccountPassword $pw -Name "Tina Wagner" -DisplayName "Tina Wagner" -Enabled $true -SAMAccountName "twagner" -UserPrincipalName "twagner@3bb-testlab.at" -Department "Finance" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"

# Office
New-ADUser -AccountPassword $pw -Name "Peter Meier" -DisplayName "Peter Meier" -Enabled $true -SAMAccountName "pmeier" -UserPrincipalName "pmeier@3bb-testlab.at" -Department "Office" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADUser -AccountPassword $pw -Name "Clara Schmidt" -DisplayName "Clara Schmidt" -Enabled $true -SAMAccountName "cschmidt" -UserPrincipalName "cschmidt@3bb-testlab.at" -Department "Office" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADUser -AccountPassword $pw -Name "Nina Hoffmann" -DisplayName "Nina Hoffmann" -Enabled $true -SAMAccountName "nhoffmann" -UserPrincipalName "nhoffmann@3bb-testlab.at" -Department "Office" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"

# Marketing
New-ADUser -AccountPassword $pw -Name "Julia Schwarz" -DisplayName "Julia Schwarz" -Enabled $true -SAMAccountName "jschwarz" -UserPrincipalName "jschwarz@3bb-testlab.at" -Department "Marketing" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADUser -AccountPassword $pw -Name "David Müller" -DisplayName "David Müller" -Enabled $true -SAMAccountName "dmueller" -UserPrincipalName "dmueller@3bb-testlab.at" -Department "Marketing" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADUser -AccountPassword $pw -Name "Eva Richter" -DisplayName "Eva Richter" -Enabled $true -SAMAccountName "erichter" -UserPrincipalName "erichter@3bb-testlab.at" -Department "Marketing" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"

# IT
New-ADUser -AccountPassword $pw -Name "Maximilian Bauer" -DisplayName "Maximilian Bauer" -Enabled $true -SAMAccountName "mbauer" -UserPrincipalName "mbauer@3bb-testlab.at" -Department "IT" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADUser -AccountPassword $pw -Name "Sandra Weber" -DisplayName "Sandra Weber" -Enabled $true -SAMAccountName "sweber" -UserPrincipalName "sweber@3bb-testlab.at" -Department "IT" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADUser -AccountPassword $pw -Name "Christian Bauer" -DisplayName "Christian Bauer" -Enabled $true -SAMAccountName "cbauer" -UserPrincipalName "cbauer@3bb-testlab.at" -Department "IT" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"

# SOC
New-ADUser -AccountPassword $pw -Name "Lena Fischer" -DisplayName "Lena Fischer" -Enabled $true -SAMAccountName "lefischer" -UserPrincipalName "lefischer@3bb-testlab.at" -Department "SOC" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADUser -AccountPassword $pw -Name "Jonas Klein" -DisplayName "Jonas Klein" -Enabled $true -SAMAccountName "jklein" -UserPrincipalName "jklein@3bb-testlab.at" -Department "SOC" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"
New-ADUser -AccountPassword $pw -Name "Franziska Weber" -DisplayName "Franziska Weber" -Enabled $true -SAMAccountName "fweber" -UserPrincipalName "fweber@3bb-testlab.at" -Department "SOC" -ChangePasswordAtLogon $false -Path "OU=Users,OU=Wien,DC=wien,DC=3bb-testlab,DC=at"

# Add User to Groups
Add-ADGroupMember -Identity 'Management' -Members mmustermann, abecker, bschmidt
Add-ADGroupMember -Identity "Finance" -Members sklein, lfischer, twagner
Add-ADGroupMember -Identity "Office" -Members pmeier, cschmidt, nhoffmann
Add-ADGroupMember -Identity "Marketing" -Members jschwarz, dmueller, erichter
Add-ADGroupMember -Identity "IT" -Members mbauer, sweber, cbauer
Add-ADGroupMember -Identity "SOC" -Members lefischer, jklein, fweber
Add-ADGroupMember -Identity "Protected Users" -Members mmustermann, twagner, mbauer, lefischer


# DHCP
Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerv4Scope -Name "WIEN-3BB-SCOPE-CLIENTS" -StartRange 10.4.18.1 -EndRange 10.4.18.254 -SubnetMask 255.255.255.0 -LeaseDuration 24:00:00 -State Active
Set-DhcpServerv4OptionValue -ScopeID 10.4.18.0 -DNSServer 10.1.18.10,10.1.18.11 -DNSDomain wien.3bb-testlab.at -Router 10.4.18.254
Add-Dhcpserverv4ExclusionRange -ScopeID 10.4.18.0 -StartRange 10.4.18.1 -Endrange 10.4.18.10

Add-DhcpServerv4Failover -Name "WIEN-3BB-FAILOVER" -PartnerServer wien-3bb-dc1.wien.3bb-testlab.at -ScopeId 10.4.18.0 -LoadBalancePercent 50 -SharedSecret $pw -MaxClientLeadTime 2:00:00 -AutoStateTransition $true -StateSwitchInterval 2:00:00

# Scavenging
Set-DnsServerScavenging -ScavengingState $true -ApplyOnAllZones -RefreshInterval 6.00:00:00 -NoRefreshInterval 6.00:00:00
Set-dnsserverScavenging -ScavengingInterval 1.00:00:00

$allZones = Get-DnsServerZone | Where-Object {$_.ZoneName -like "*3bb*"}
Foreach ($zone in $allZones) {
Set-DNSServerZoneAging -ZoneName $zone.ZoneName -Aging $true
}

Foreach ($zone in $allZones) {
Set-DNSServerZoneAging -Name $zone.ZoneName -ScavengeServers 10.3.18.10
}


# Secure Dynamic Updates
Set-DhcpServerv4DnsSetting -ComputerName "wins1.3bb.htl3r.at" -DynamicUpdates "Always" -DeleteDnsRRonLeaseExpiry $True
Set-DhcpServerv4DnsSetting -ComputerName "wins2.3bb.htl3r.at" -DynamicUpdates "Always" -DeleteDnsRRonLeaseExpiry $True






# Benutzerdaten-Ordner Rechte vergeben
# Administratoren Domain Local Group SID
$AdminSID = Get-ADGroup -Identity "S-1-5-32-544"  | select -ExpandProperty SID
# Domain User Global Group SID
$DomainUsersSID = Get-ADGroup -Identity "S-1-5-21-1862901537-785795615-1005539289-513"  | select -ExpandProperty SID

$BenutzerdatenACL = Get-Acl "X:\Benutzerdaten"
$AdminRULE = New-Object System.Security.AccessControl.FileSystemAccessRule($AdminSID, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$SystemRULE = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$DomainUserRULE = New-Object System.Security.AccessControl.FileSystemAccessRule($DomainUsersSID, "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")

$BenutzerdatenACL.SetAccessRule($AdminRULE)
$BenutzerdatenACL.SetAccessRule($SystemRULE)
$BenutzerdatenACL.SetAccessRule($DomainUserRULE)

# DNS
# Reverse Lookup Zone
Add-DnsServerPrimaryZone -NetworkID "172.16.0.0/24" -ReplicationScope Domain
# Pointer
Add-DnsServerResourceRecordPtr -Name 172.16.0.1 -PtrDomainName WinS1.3bb.htl3r.at -ZoneName 0.16.172.in-addr.arpa
Add-DnsServerResourceRecordPtr -Name 172.16.0.2 -PtrDomainName WinS2.3bb.htl3r.at -ZoneName 0.16.172.in-addr.arpa
Add-DnsServerResourceRecordPtr -Name 172.16.0.3 -PtrDomainName WinC1.3bb.htl3r.at -ZoneName 0.16.172.in-addr.arpa
Add-DnsServerResourceRecordPtr -Name 172.16.0.4 -PtrDomainName LinC2.3bb.htl3r.at -ZoneName 0.16.172.in-addr.arpa

Add-DnsServerResourceRecordPtr -Name 172.16.0.1 -ComputerName WinS1 -ZoneName 0.16.172.in-addr.arpa -ptrdomainname 3bb.htl3r.at
Add-DnsServerResourceRecordPtr -Name 172.16.0.2 -ComputerName WinS2 -ZoneName 0.16.172.in-addr.arpa -ptrdomainname 3bb.htl3r.at
Add-DnsServerResourceRecordPtr -Name 172.16.0.3 -ComputerName WinC1 -ZoneName 0.16.172.in-addr.arpa -ptrdomainname 3bb.htl3r.at
Add-DnsServerResourceRecordPtr -Name 172.16.0.5 -ComputerName LinC2 -ZoneName 0.16.172.in-addr.arpa -ptrdomainname 3bb.htl3r.at

Get-DnsServerResourceRecord -ZoneName "0.16.172.in-addr.arpa"
Get-DnsServerZone
