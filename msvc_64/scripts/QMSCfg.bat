@echo off

rem call this script in "scripts" directory. 
rem Parameters: 
rem    Package name: QMS resp. QUAZIP
rem    Name of subdirectory with user configuration, e.g. scripts_qt6
rem    UPDATE_TRANSLATIONS: ON/OFF


echo Starting configuration process in "%cd%" ...

echo PKG: %1

rem echo %2\built_%1_add.bat

call %2\built_%1_add.bat

rem echo %builddir%
pause

pushd %builddir%

echo       
echo Configuring with -DCMAKE_CXX_FLAGS="/EHsc" ...

echo msvc_generator: x%msvc_generator%xcopy
echo cmake: xcmake --fresh -G %msvc_generator% -A x64 -S .. -B . -LA -DPKG=%1 -DQMSUSERCFG=%usercfg% -DUPDATE_TRANSLATIONS=%3 -DCMAKE_CXX_FLAGS="/EHsc" -C  %scriptsdir%\CfgGisinternals.cfgx

pause

cmake --fresh -G %msvc_generator% -A x64 -S .. -B . -LA -DPKG=%1 -DQMSUSERCFG=%usercfg% -DUPDATE_TRANSLATIONS=%3 -DCMAKE_CXX_FLAGS="/EHsc" -C  %scriptsdir%\CfgGisinternals.cfg

pause

echo       
echo Building...

cmake --build . --config Release -j8

if %1==QUAZIP (
pause

echo      
echo Installing...

cmake --build . --config Release -j8 --target install
)

popd