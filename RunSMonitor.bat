@Echo Off
FOR /f %%i IN ('DIR *.sql /B') do call :RunScript %%i
GOTO :END
:RunScript
Echo Executing %1
"sqlcmd.exe" -U sa -P express@1 -S "SNOWFLAKE\SQLEXPRESS" -d Eduquaydb -i %1 -o "ServiceManageOutput.txt"
Echo Completed %1
:END
