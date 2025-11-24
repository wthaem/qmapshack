
@echo off

echo Script to copy all files necessary for QMS (GISInternals version)
echo Scripts switches to x64 Native Tools Command Prompt and then to `%~dp0` directory!

echo Preparing x64 Native tool ...

for /f "usebackq tokens=*" %%i in (`"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (set VSPATH=%%i)

call "%VSPATH%\VC\Auxiliary\Build\vcvars64.bat"
pause

set QMSD0=%~dp0
    
cd /D %QMSD0%

echo Switched Native tool to %cd%

rem Delete all files --------------------------------------------
rmdir /s /q ..\Files

IF ERRORLEVEL 1 (
    echo [ERROR] RMDIR failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
) ELSE (
    echo RMDIR successful.
)

pause

mkdir ..\Files


rem Include and run user settings
for /f "tokens=2 delims=:" %%a in (QMSUserCfg.dir) do (
echo Include dir: %%a
set USERDIR=%%a

echo Starting file copy  step 1 ...

pause

call %%a\CopyFilesGis_add.bat
)

echo Starting file copy step 2 ...
pause



rem Copy QMapShack Files (removed bin subdir! 28.04.25 ------
copy %QMSI_BUILD_PATH%\Release\qmapshack.exe
copy %QMSI_BUILD_PATH%\Release\qmaptool.exe
copy %QMSI_BUILD_PATH%\Release\qmt_map2jnx.exe
copy %QMSI_BUILD_PATH%\Release\qmt_rgb2pct.exe

copy %QMSI_QT_PATH%\bin\assistant.exe

rem Copy Qt files -------------------------------------------------

set PATH=%QMSI_QT_PATH%\bin;%PATH%

windeployqt.exe  --force-openssl --no-translations .\qmapshack.exe .\qmaptool.exe .\qmt_map2jnx.exe .\qmt_rgb2pct.exe .\assistant.exe

pause

mkdir translations

for %%i in (ca, cs, de, en, es, fr, it, nl, ru) do (

    if exist %QMSI_QT_PATH%\translations\qt_%%i.qm (copy %QMSI_QT_PATH%\translations\qt_%%i.qm translations)
    if exist %QMSI_QT_PATH%\translations\qtbase_%%i.qm (copy %QMSI_QT_PATH%\translations\qtbase_%%i.qm translations)
    if exist %QMSI_QT_PATH%\translations\assistant_%%i.qm (copy %QMSI_QT_PATH%\translations\assistant_%%i.qm translations)
    if exist %QMSI_QT_PATH%\translations\qt_help_%%i.qm (copy %QMSI_QT_PATH%\translations\qt_help_%%i.qm translations)
)

rem Qt6WebEngine translations
cd translations
mkdir qtwebengine_locales

for %%i in (ca, cs, de, en-US, en-GB, es, fr, it, nl, ru) do if exist %QMSI_QT_PATH%\translations\qtwebengine_locales\%%i.pak (copy %QMSI_QT_PATH%\translations\qtwebengine_locales\%%i.pak qtwebengine_locales)

cd ..


if %QT%==5 (
copy %QMSI_QT_PATH%\bin\libEGL.dll
copy %QMSI_QT_PATH%\bin\libGLESv2.dll
copy %QMSI_QT_PATH%\bin\Qt%QT%WebEngine.dll

mkdir printsupport
cd printsupport
copy %QMSI_QT_PATH%\plugins\printsupport\windowsprintersupport.dll
cd ..
) 

rem Copy Routino files ----------------------------------------------
copy %QMSI_ROUT_PATH%\lib\routino.dll
copy %QMSI_ROUT_PATH%\bin\planetsplitter.exe
copy %QMSI_MGW6_PATH%\libwinpthread-1.dll
copy %QMSI_MGW6_PATH%\zlib1.dll
xcopy %QMSI_ROUT_PATH%\xml routino-xml /s /i

rem Copy QuaZip --------------------------------------------------------
copy %QMSI_QUAZIP_PATH%\bin\quazip1-Qt%QT%.dll

rem Copy mysql 

echo.
echo.
echo Copy mysql
rem copy %QMSI_MYSQL_PATH%\qsqlmysql.dll
robocopy %QMSI_MYSQL_PATH% "%cd%" /E /NJH /NJS /NFL /NDL     
pause

rem Copy MSVC Redistributables -------------------------------------
copy %QMSI_VCREDIST_PATH%VC_redist.x64.exe

echo Compiling all .ts files to .qm ...
for %%g in ("qmapshack", "qmaptool", "qmt_rgb2pct") do (

    for %%f in ("%QMSI_SRC_PATH%\%%g\locale\*.ts") do (
        %QMSI_QT_PATH%\bin\lrelease.exe -silent "%%f" -qm translations\%%~nf.qm
    )
)

pause

copy ..\*.ico

rem Copy offline help files ------------------------------------------------
mkdir doc
cd doc
mkdir HTML
copy ..\..\..\src\qmapshack\doc\QMSHelp.* HTML
copy ..\..\..\src\qmaptool\doc\QMTHelp.* HTML
cd ..

rem Copy 3rd party software description and licence ----------------------------
copy ..\3rdparty.txt
copy ..\..\LICENSE 1LICENSE.txt

copy %USERDIR%\UsedVersions.txt

rem Copy qt.conf -----------------------------------------------------------
copy ..\qt.conf

..\scripts\QMSRemoveObjects.py
pause

cd ..\scripts
pause

echo Starting QMS and QMT - Press F1 to get FTS files!


start /WAIT ..\Files\qmaptool.exe
start /WAIT ..\Files\qmapshack.exe

