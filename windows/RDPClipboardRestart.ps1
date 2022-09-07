(Get-WmiObject -Query "select * from Win32_Process where name='RDPClip.exe'"|?{$_.GetOwner().User -eq $ENV:USERNAME}).Terminate()
rdpclip.exe