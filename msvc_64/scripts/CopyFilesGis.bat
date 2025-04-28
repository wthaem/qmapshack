@echo off


rem Script to copy all files necessary for QMS (GISInternals version)

rem Delete all files --------------------------------------------
del /s/q ..\Files
mkdir ..\Files


rem Include and run user settings
for /f "tokens=2 delims=:" %%a in (QMSUserCfg.dir) do (
echo Include dir: %%a
set USERDIR=%%a

pause

call %%a\CopyFilesGis_add.bat
)

rem Copy QMapShack Files (removed bin subdir! 28.04.25 ------
copy %QMSI_BUILD_PATH%\Release\qmapshack.exe
copy %QMSI_BUILD_PATH%\Release\qmaptool.exe
copy %QMSI_BUILD_PATH%\Release\qmt_map2jnx.exe
copy %QMSI_BUILD_PATH%\Release\qmt_rgb2pct.exe


rem Copy Qt files -------------------------------------------------

set PATH=%QMSI_QT_PATH%\bin;%PATH%

windeployqt.exe  --force-openssl --no-translations .\qmapshack.exe .\qmt_map2jnx.exe

copy %QMSI_QT_PATH%\bin\assistant.exe

mkdir translations

for %%i in (ca, cs, de, en, es, fr, it, nl, ru) do (

    copy %QMSI_QT_PATH%\translations\qt_%%i.qm translations
    copy %QMSI_QT_PATH%\translations\qtbase_%%i.qm translations
    copy %QMSI_QT_PATH%\translations\assistant_%%i.qm translations
    copy %QMSI_QT_PATH%\translations\qt_help_%%i.qm translations
)

rem Qt6WebEngine translations
cd translations
mkdir qtwebengine_locales

for %%i in (ca, cs, de, en-US, en-GB, es, fr, it, nl, ru) do copy %QMSI_QT_PATH%\translations\qtwebengine_locales\%%i.pak qtwebengine_locales

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

rem Copy MSVC Redistributables -------------------------------------
copy %QMSI_VCREDIST_PATH%VC_redist.x64.exe

rem Copy QMS translations
xcopy %QMSI_BUILD_PATH%\src\qmapshack\*.qm translations /S 
xcopy %QMSI_BUILD_PATH%\src\qmaptool\*.qm translations /S 
xcopy %QMSI_BUILD_PATH%\src\qmt_rgb2pct\*.qm translations /S 

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

copy %USERDIR%\QMSCommit.log

rem Copy qt.conf -----------------------------------------------------------
copy ..\qt.conf

cd ..\scripts
pause
