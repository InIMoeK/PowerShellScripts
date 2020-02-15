# User input

$defaultserverport = "443"
$serverport = Read-Host "Press enter to use default port or enter custom [$($defaultserverport)]"
$serverport = ($defaultserverport,$serverport)[[bool]$serverport]

$defaultremoteip = "0.0.0.0"
$remoteip = Read-Host "Press enter to allow any ip address or enter custom [$($defaultremoteip)]"
$remoteip = ($defaultremoteip,$remoteip)[[bool]$remoteip]

# Static variables

$url = 'http://aka.ms/WACDownload'
$dlpath = "C:\Users\$env:UserName\Downloads\WAC.msi"
$start_time = Get-Date

# Download Windows Admin Center installer

Invoke-WebRequest $url -OutFile $dlpath ;

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)" ;

Write-Host "Installing Windows Admins Center" -ForegroundColor Green ;

# Execute installer

msiexec /i $dlpath /qn /L*v log.txt SME_PORT=$serverport SSL_CERTIFICATE_OPTION=generate

# Add firewall rule

Set-NetFirewallRule -DisplayName 'SmeInboundOpenException' -LocalPort $serverport -Protocol TCP -RemoteAddress $remoteip ;

Write-Host "Firewall rule created" -ForegroundColor Green