@echo off


set RH=%1

setlocal EnableDelayedExpansion
set n=0
for %%a in (QMapShack QMapTool) do (
   set vector[!n!]=%%a
   set /A n+=1
)

set n=0
for %%a in (qmapshack qmaptool) do (
   set vector1[!n!]=%%a
   set /A n+=1
)

(for /L %%i in (0,1,1) do (
   del QMS_tmp.rc
   echo #define QMS_UP "!vector[%%i]!" >  QMS_tmp.rc
   echo #define QMS "!vector1[%%i]!"   >> QMS_tmp.rc
   echo #include "QMS_resources.h"     >> QMS_tmp.rc
   
   %RH%  -open QMS_tmp.rc -save QMS_tmp.res -action compile -log con
   %RH%  -open ..\msvc_64\Files\!vector1[%%i]!.exe -save ..\msvc_64\Files\!vector1[%%i]!.exe -action addoverwrite -resource QMS_tmp.res -log con
)) 
