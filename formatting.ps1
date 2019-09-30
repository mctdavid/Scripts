PS C:\Users\foxadmin> $data = get-service | where-object status -eq 'stopped' | select-object name,status
PS C:\Users\foxadmin> $data
PS C:\Users\foxadmin> $data | out-file .\services.csv
PS C:\Users\foxadmin> notepad .\services.csv
PS C:\Users\foxadmin> $data | export-csv .\services2.csv
PS C:\Users\foxadmin> get-content .\services2.csv |more
