@ECHO OFF

SET SQLCMD="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE"

SET PATH="D:\Projects\Muthu\database\DatabaseModels\"

SET SERVER="eduquaydb-aws.cucirccoc5bq.us-east-1.rds.amazonaws.com,1433"

SET DB="Eduquaydb"

SET LOGIN="sa"

SET PASSWORD=express@1

SET OUTPUT="C:\OutputLog.txt"

CD %PATH%

ECHO %date% %time% > %OUTPUT%

for %%f in (*.sql) do (

%SQLCMD% -S %SERVER% -d %DB% -U admin -P express#1 -i %%~f >> OutputLog.txt

)

