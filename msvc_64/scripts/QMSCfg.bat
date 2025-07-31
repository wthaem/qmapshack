@echo off

rem call this script in "scripts" directory. 
rem Parameters: 
rem    Package name: QMS resp. QUAZIP
rem    name of subdirectory with user configuration, e.g. scripts_qt6



echo Starting configuration process in "%cd%" ...

echo PKG: %1

rem echo %2\built_%1_add.bat

call %2\built_%1_add.bat

rem echo %builddir%
pause

pushd %builddir%

echo       
echo Configuring with -DCMAKE_CXX_FLAGS="/EHsc" ...

cmake --fresh -G "Visual Studio 17 2022" -A x64 -S .. -B . -LA -DPKG=%1 -DQMSUSERCFG=%usercfg% -DUPDATE_TRANSLATIONS=OFF -DCMAKE_CXX_FLAGS="/EHsc" -C  %scriptsdir%\CfgGisinternals.cfg

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