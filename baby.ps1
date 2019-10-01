#Command History
get-history | out-file c:\history.txt

#Capture Powershell Console Activity
Start-transcript -path c:\transcript.txt -append
stop-transcript

get-service -computername Client01
Enter-PSsession -computername Client01

#Enable local server for PS remoting
enable-psremoting -force
Set-PSSessionConfiguration -name Microsoft.powershell -showsecuritydescriptorUI # Add remote account
get-netfirewallrule |where displayname -like "windows management instrumentation*" |set-netfirewallrule -enable True -verbose
get-netfirewallrule |where displaygroup -EQ 'remote service management' |set-netfirewallrule -enable True -verbose

#List Default Variables
get-childitem env: |more
$env:path
get-variable |more

#Store secret
$credential = get-credential

#List commands with -pssession
gcm *-pssession

#Run commands remotely - PS Core
invoke-command -computername dc1 -cred(get-credential) -scriptblock {get-aduser -identity felixb |format-list}

