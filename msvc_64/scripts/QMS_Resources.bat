@echo off


set RH=%1

pause
 
setlocal EnableDelayedExpansion
set n=0
for %%a in (QMapShack QMapTool qmt_map2jnx qmt_rgb2pct) do (
   set vector[!n!]=%%a
   set /A n+=1
)

set n=0
for %%a in (qmapshack qmaptool qmt_map2jnx qmt_rgb2pct) do (
   set vector1[!n!]=%%a
   set /A n+=1
)

(for /L %%i in (0,1,3) do (
   del QMS_tmp.rc
   echo #define QMS_UP "!vector[%%i]!" >  QMS_tmp.rc
   echo #define QMS "!vector1[%%i]!"   >> QMS_tmp.rc
   echo #include %cd%\QMS_resources.h  >> QMS_tmp.rc
   
   %RH%  -open QMS_tmp.rc -save QMS_tmp.res -action compile -log con
   
   pause 
   
   %RH%  -open ..\Files\!vector1[%%i]!.exe -save ..\Files\!vector1[%%i]!___.exe -action addoverwrite -resource QMS_tmp.res -log con
   
   del ..\Files\!vector1[%%i]!.exe
   ren ..\Files\!vector1[%%i]!___.exe !vector1[%%i]!.exe
   
))

del QMS_tmp.res 
