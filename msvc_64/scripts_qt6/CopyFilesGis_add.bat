
rem Environment variable replacements created with CopyFilesGis.cfg using QMSUser.cfg

set QMSI_QMS_PATH=d:\QtProjects\QMS
set QMSI_GIS_PATH=d:\QtProjects\QMS\gisinternals\1930_250621\release-1930-x64
set QMSI_QT_PATH="d:\Qt\5.12.3\6.9.1\msvc2022_64"
set QMSI_VCREDIST_PATH="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Redist\MSVC\14.44.35112\"
set QMSI_ROUT_PATH="d:\QtProjects\QMS\routino\routino-3.4.3\install"
set QMSI_MGW6_PATH="D:\msys64\ucrt64\bin"
set QMSI_QUAZIP_PATH="d:\QtProjects\QMS\quazip\quazip-1.5\install"
set QMSI_BUILD_PATH="d:\QtProjects\QMS\QMapShack\build"
set QT=6
 
cd ..\Files
mkdir data
pause
xcopy %QMSI_GIS_PATH%\bin\gdal-data data /s /i
if '250621' LSS '241207' (
    copy  %QMSI_GIS_PATH%\bin\proj_9_6.dll
) else (
    copy  %QMSI_GIS_PATH%\bin\proj_9.dll
)
xcopy %QMSI_GIS_PATH%\bin\*.dll /I /EXCLUDE:..\gisexclude.txt
mkdir gdalplugins
xcopy %QMSI_GIS_PATH%\bin\gdal\plugins gdalplugins /s /i /EXCLUDE:..\gisexclude.txt
copy %QMSI_GIS_PATH%\bin\curl-ca-bundle.crt
copy %QMSI_GIS_PATH%\bin\gdal\apps\*.exe
copy %QMSI_GIS_PATH%\bin\proj9\apps\*.exe
copy %QMSI_GIS_PATH%\bin\curl.exe
copy %QMSI_GIS_PATH%\bin\openssl.exe
copy %QMSI_GIS_PATH%\bin\sqlite3.exe
xcopy %QMSI_QMS_PATH%\mysql\6.9.1\sqldrivers\qsqlmysql*.dll sqldrivers /i
mkdir share\proj
xcopy %QMSI_GIS_PATH%\bin\proj9\share share\proj /s /i
