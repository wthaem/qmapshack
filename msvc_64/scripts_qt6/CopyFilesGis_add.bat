
rem Environment variable replacements created with CopyFilesGis.cfg using QMSUser.cfg

set QMSI_QMS_PATH=d:\QtProjects\QMS
set QMSI_GIS_PATH=d:\QtProjects\QMS\gisinternals\1944_260214\release-1944-x64
set QMSI_QT_PATH="c:\Qt\6.10.0\msvc2022_64"
set QMSI_VCREDIST_PATH="C:\Program Files\Microsoft Visual Studio\18\Community\VC\Redist\MSVC\14.50.35710\"
set QMSI_ROUT_PATH="d:\QtProjects\QMS\routino\routino-3.4.3\install"
set QMSI_MYSQL_PATH="d:\QtProjects\QMS\mysql\6.10.0"
set QMSI_MGW6_PATH="c:\msys64\ucrt64\bin"
set QMSI_QUAZIP_PATH="d:\QtProjects\QMS\quazip\quazip-1.5\install"
set QMSI_BUILD_PATH=d:\QtProjects\QMS\QMS4Qt6\build-ninja
set QMSI_SRC_PATH="d:\QtProjects\QMS\QMS4Qt6\src"
set QT=6
 
cd ..\Files
mkdir data
pause
xcopy %QMSI_GIS_PATH%\bin\gdal-data data /s /i
if '260214' LSS '241207' (
    copy  %QMSI_GIS_PATH%\bin\proj_9_7.dll
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
copy %QMSI_GIS_PATH%\..\license.txt GisInternals_license.txt
xcopy %QMSI_QMS_PATH%\mysql\6.10.0\sqldrivers\qsqlmysql.dll .\sqldrivers\ /i
mkdir share\proj
xcopy %QMSI_GIS_PATH%\bin\proj9\share share\proj /s /i
