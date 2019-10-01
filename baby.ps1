#Command History
get-history | out-file c:\history.txt

Start-transcript -path c:\transcript.txt -append
stop-transcript

get-service -computername Client01
Enter-PSsession -computername Client01

enable-psremoting -force
Set-PSSessionConfiguration -name Microsoft.powershell -showsecuritydescriptorUI
get-netfirewallrule |where displayname -like "windows management instrumentation*" |set-netfirewallrule -enable True -verbose
get-netfirewallrule |where displaygroup -EQ 'remote service management' |set-netfirewallrule -enable True -verbose



get-childitem env: |more
$env:path
get-variable |more
