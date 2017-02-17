@ECHO OFF

REM +--------------------+
REM : Checking Arguments :
REM +--------------------+
IF NOT EXIST %1\bin\nant.exe GOTO :USAGE
IF NOT EXIST %2msbuild.exe GOTO :USAGE
IF !%3!==!! GOTO :USAGE
IF !%4!==!! GOTO :USAGE
IF !%5!==!! GOTO :USAGE

ECHO +-------------------+
ECHO : Starting BUILD    :
ECHO +-------------------+
%1\bin\nant -buildfile:tSQLt.build -D:msbuild.path=%2 || goto :error

ECHO +-------------------+
ECHO : Copying BUILD     :
ECHO +-------------------+
%1\bin\nant -buildfile:tSQLt.local_build_output.build || goto :error

ECHO +-------------------+
ECHO : Validating BUILD  :
ECHO +-------------------+
%1\bin\nant -buildfile:tSQLt.validatebuild -D:db.version=%3 -D:db.server=%4 -D:db.name=%5 || goto :error

ECHO +-------------------+
ECHO : BUILD SUCCEEDED   :
ECHO +-------------------+
goto :EOF

:USAGE
ECHO Builds tSQLt locally using nAnt 
ECHO.
ECHO localNbuild.bat nant.path msbuild.path db.version db.server db.name
ECHO.
ECHO      nant.path      Path to nant install, eg 'C:\nant-0.92'
ECHO      msbuild.path   Path to msbuild.exe, 
ECHO                     eg 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\'
ECHO      db.version     Maximum database version for tests, 
ECHO                     eg '2008', '2008R2', '2012', '2014'
ECHO      db.server      Local Database Server for Test Deploy 
ECHO                     Must have accounts for 'tSQLt.Build' and 'tSQLt.Build.SA'
ECHO      db.name        Target Database for Test Deploy
ECHO.
exit /b 1

:error
ECHO +-------------------+
ECHO : BUILD FAILED      :
ECHO +-------------------+
exit /b %errorlevel%