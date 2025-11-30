
; "C:\Program Files (x86)\NSIS\makensis.exe" /DQMSUSERCFG=scripts_qt6 /V4 /INPUTCHARSET UTF8 d:\QtProjects\QMS\QMS4Qt6\msvc_64\scripts\QMS_gisinternals.nsi
; start in scripts\..\..

;NSIS Installer Script for GISInternals-based QMapShack package

; 30.09.2025 Added optional uninstall of existing version

;NSIS References/Documentation 
;http://nsis.sourceforge.net/Docs/Modern%20UI%202/Readme.html
;http://nsis.sourceforge.net/Docs/Modern%20UI/Readme.html
;http://nsis.sourceforge.net/Docs/Chapter4.html
;http://nsis.sourceforge.net/Many_Icons_Many_shortcuts


;Properly display all languages (Installer will not work on Windows 95, 98 or ME!)
Unicode true

!pragma warning error all

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !include "nsDialogs.nsh"
  !include "LogicLib.nsh" ; not valid for nsis 3.0.1
  !include "x64.nsh"
  !include "WinVer.nsh"
  !include "StrFunc.nsh"  ; not valid for nsis 3.0.1
  
  ; include current version info
  !include "..\${QMSUSERCFG}\QMS_gisinternals_add.nsi"

;--------------------------------
;General

  Setcompressor LZMA

  !define PACKAGE "QMapShack"

  ;Name and file
  Name ${PACKAGE}
  
  
  ; Installer executable info
  VIProductVersion "${SUBVERSION}"
  VIAddVersionKey  "ProductVersion" ${VERSION}
  VIAddVersionKey  "FileVersion" "${SUBVERSION}"
  VIAddVersionKey  "ProductName" ${PACKAGE}
  VIAddVersionKey  "LegalCopyright" "Copyright (©) 2025, Oliver Eichler"
  VIAddVersionKey  "FileDescription" "${PACKAGE} installer (x64)"

  Icon "..\QMapShack.ico"

  OutFile "${PACKAGE}-${EXEFILE}_x64_setup.exe"

  ;Default installation folder - must be ASCII only name - otherwise QMS (Routino!)/QMT won't start properly
  InstallDir "$PROGRAMFILES64\${PACKAGE}"
  
  ;Get installation folder from registry if available and overwrite InstallDir with it
  InstallDirRegKey HKLM "Software\${PACKAGE}" "Install_Dir"

  Var OldUninstaller
  Var hCtl_RadioYes
  Var hCtl_RadioNo
  Var StartMenuFolder
  
  
  ;Request application privileges for Windows UAC
  RequestExecutionLevel admin 

  ; Don't let the OS scale(blur) the installer GUI
  ManifestDPIAware true

  InstProgressFlags smooth
  
;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

  ;Show all languages, despite user's codepage
  !define MUI_LANGDLL_ALLLANGUAGES

;--------------------------------
;Language Selection Dialog Settings

  ;Remember the installer language
  !define MUI_LANGDLL_REGISTRY_ROOT "HKLM" 
  !define MUI_LANGDLL_REGISTRY_KEY "Software\${PACKAGE}" 
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

;------------------------------------------------------------------------
; Modern UI definition                                                    -
;------------------------------------------------------------------------
;!define MUI_COMPONENTSPAGE_SMALLDESC ;No value
!define MUI_INSTFILESPAGE_COLORS "FFFFFF 000000" ;Two colors

!define MUI_ICON   "..\QMapShack.ico"
!define MUI_UNICON "..\QMapShack.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP   "..\MUI_HEADERIMAGE.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "..\MUI_HEADERIMAGE.bmp"

!define MUI_WELCOMEFINISHPAGE_BITMAP "..\MUI_WELCOMEFINISHPAGE.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "..\MUI_WELCOMEFINISHPAGE.bmp"

; Page welcome description
!define MUI_WELCOMEPAGE_TITLE "QMapShack "
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_WELCOMEPAGE_TEXT $(DESC_MUI_WELCOMEPAGE_TEXT)

!define MUI_DIRECTORYPAGE_TEXT_TOP $(DESC_MUI_DIRECTORYPAGE_TEXT_TOP)

!define MUI_FINISHPAGE_LINK $(DESC_MUI_FINISHPAGE_LINK)
!define MUI_FINISHPAGE_LINK_LOCATION "https://github.com/Maproom/qmapshack/wiki"

!define MUI_FINISHPAGE_RUN "$INSTDIR\QMS_Start.bat"
!define MUI_FINISHPAGE_NOREBOOTSUPPORT
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME  
  !insertmacro MUI_PAGE_LICENSE "..\..\LICENSE"
  !insertmacro MUI_PAGE_LICENSE "LICENSE_Gisinternals.txt"

  Page custom OldVersionPageCreate OldVersionPageLeave

  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  
  ; Start menu page configuration  
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKLM" 
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\${PACKAGE}" 
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PACKAGE}"

  !insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_WELCOME
  UninstPage   custom un.InfoPage 
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English" ; The first language is the default language
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "Spanish"

;--------------------------------
;Reserve Files
  
  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.
  
  !insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------
;Installer Sections

;------------------------------------------------------------------------
;Components description

Section "MSVC++ 2022 Runtime" MSVC

  DetailPrint "Running vc_redist.x64.exe ..."

  SetOutPath $TEMP
  File ..\Files\VC_redist.x64.exe
  ExecWait '"$TEMP\VC_redist.x64.exe" /install /quiet /norestart'
  Delete "$TEMP\VC_redist.x64.exe"
  SetOutPath "$INSTDIR"
 
SectionEnd

Section "QMapShack/QMapTool" QMapShack
  
  DetailPrint "Copying application files ..."


  ReadEnvStr $2 "USERPROFILE"
  
  IfFileExists $2\.config\QLandkarte\workspace.db 0 LBL1
      CopyFiles $2\.config\QLandkarte\workspace.db $2\.config\QLandkarte\workspace.db.bak
      
  LBL1:    
  SetShellVarContext all
  SetRegView 64
  
  ;BEGIN QMapShack Files
  SetOutPath "$INSTDIR"
  File /r ..\Files\*.*
  
  FileOpen  $9 QMS_Start.bat w 
  FileWrite $9 'set QMS_ROOT=%~dp0$\r$\n'
  FileWrite $9 'set GDAL_DRIVER_PATH=%QMS_ROOT%gdalplugins$\r$\n'
  FileWrite $9 'set GDAL_DATA=%QMS_ROOT%data$\r$\n'
  FileWrite $9 'set PROJ_DATA=%QMS_ROOT%share\proj$\r$\n'  
  FileWrite $9 'cd /d %~dp0$\r$\n'
  FileWrite $9 'start "QMS" /B qmapshack.exe --style fusion %1$\r$\n'
  FileClose $9 
  
  FileOpen  $9 QMT_Start.bat w 
  FileWrite $9 'set QMS_ROOT=%~dp0$\r$\n'
  FileWrite $9 'set GDAL_DRIVER_PATH=%QMS_ROOT%gdalplugins$\r$\n'
  FileWrite $9 'set GDAL_DATA=%QMS_ROOT%data$\r$\n'
  FileWrite $9 'set PROJ_DATA=%QMS_ROOT%share\proj$\r$\n' 
  FileWrite $9 'cd /d %~dp0$\r$\n'
  FileWrite $9 'start "QMT" /B qmaptool.exe --style fusion$\r$\n'
  FileClose $9   
  
  FileOpen  $9 GDAL_shell.bat w 
  FileWrite $9 '@echo off$\r$\n'
  FileWrite $9 '@echo Setting environment for using the GDAL Utilities.$\r$\n'
  FileWrite $9 'set QMS_ROOT=%~dp0$\r$\n'
  FileWrite $9 'set GDAL_DRIVER_PATH=%QMS_ROOT%gdalplugins$\r$\n'
  FileWrite $9 'set GDAL_DATA=%QMS_ROOT%data$\r$\n'
  FileWrite $9 'set PROJ_DATA=%QMS_ROOT%share\proj$\r$\n' 
  FileWrite $9 'cd /d %~dp0$\r$\n'
  FileWrite $9 'cmd /K$\r$\n'
  FileClose $9 

SectionEnd


Section "Start Menu" StartMenu

  DetailPrint "Creating start menu ..."

  SetOutPath "$INSTDIR"
  
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

    ;Create shortcuts
    
    ClearErrors    
        
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"

    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\QMapShack.lnk"     '"$INSTDIR\QMS_Start.bat"' "" "$INSTDIR\QMapShack.ico" 0 "SW_SHOWMINIMIZED" "" "Start QMapShack"

    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\QMapTool.lnk"     '"$INSTDIR\QMT_Start.bat"' "" "$INSTDIR\QMapTool.ico" 0 "SW_SHOWMINIMIZED" "" "Start QMapTool"

    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\GDAL_shell.lnk"    '"$INSTDIR\GDAL_shell.bat"' "" "$INSTDIR\QMapShack.ico" 0 "SW_SHOWNORMAL" "" "Start GDAL shell with correct environment"

    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\QMapShack Help offline.lnk" '"$INSTDIR\assistant.exe"' '-collectionFile  "$INSTDIR\doc\HTML\QMSHelp.qhc" --style fusion' 
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\QMapShack Help online Wiki.lnk" "https://github.com/Maproom/qmapshack/wiki" "" "$INSTDIR\kfm_home.ico"

    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"     '"$INSTDIR\Uninstall.exe"'
    
  !insertmacro MUI_STARTMENU_WRITE_END

SectionEnd

Section "Register software" Register
  
  ;DetailPrint "Registering software ..."

  ; Set output path to the installation directory.
  SetOutPath "$INSTDIR"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\${PACKAGE} "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  
  ;Create registry entries
  WriteRegStr   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PACKAGE}" "DisplayName"     "QMapShack (remove only)"
  WriteRegStr   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PACKAGE}" "UninstallString" "$INSTDIR\Uninstall.exe"
  
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PACKAGE}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PACKAGE}" "NoRepair" 1
  
  WriteUninstaller $INSTDIR\uninstall.exe
  
SectionEnd

;--------------------------------
;Descriptions

LangString LanguageSelect ${LANG_ENGLISH} "Please select your language:"
LangString LanguageSelect ${LANG_GERMAN}  "Bitte wählen Sie Ihre Sprache:"
LangString LanguageSelect ${LANG_SPANISH} "Seleccione el idioma:"

LangString MSG_W10 ${LANG_ENGLISH} "${PACKAGE} can only be installed on Windows 10 or later!"
LangString MSG_W10 ${LANG_GERMAN}  "${PACKAGE} kann nur auf Windows 10 und später installiert werden!"
LangString MSG_W10 ${LANG_SPANISH} "${PACKAGE} solo se puede instalar en Windows 10 o versiones posteriores!"

LangString MSG_B32 ${LANG_ENGLISH} "The 64b version of ${PACKAGE} can not be run on 32b systems!"
LangString MSG_B32 ${LANG_GERMAN}  "Die 64b Version von ${PACKAGE} kann nicht auf 32b Systemen benutzt werden!"
LangString MSG_B32 ${LANG_SPANISH} "La versión de 64b de ${PACKAGE} no se puede ejecutar en sistemas de 32b!"

LangString MSG_ISQMS ${LANG_ENGLISH} 'QMapShack running. Close it and restart installer!'
LangString MSG_ISQMS ${LANG_GERMAN}  'QMapShack ist gestartet. Bitte schließen und Installer neu starten!'
LangString MSG_ISQMS ${LANG_SPANISH} 'QMapShack en ejecución. Ciérrelo y reinicie el instalador!'


LangString DESC_MUI_DIRECTORYPAGE_TEXT_TOP ${LANG_ENGLISH} "Hints:$\r$\n* The name of the selected folder must be ASCII only!$\r$\n* The offline help works best if selected folder has write permission!"
LangString DESC_MUI_DIRECTORYPAGE_TEXT_TOP ${LANG_GERMAN} "Hinweise:$\r$\n* Der ausgewählte Ordnername darf nur ASCII-Zeichen enthalten!$\r$\n* Die Offline-Hilfe funktioniert am besten, wenn der ausgewählte Ordner Schreibrechte hat!"
LangString DESC_MUI_DIRECTORYPAGE_TEXT_TOP ${LANG_SPANISH} "Sugerencia::$\r$\n* El nombre de la carpeta seleccionada debe estar compuesto únicamente por caracteres ASCII!:$\r$\n* La ayuda sin conexión funciona mejor si la carpeta seleccionada tiene permiso de escritura."

; LangString DESC_MUI_DIRECTORYPAGE_TEXT_TOP ${LANG_ENGLISH} "The user must have write permission for the selected folder!"
; LangString DESC_MUI_DIRECTORYPAGE_TEXT_TOP ${LANG_GERMAN}  "Der Nutzer muss Schreibberechtigung für das ausgewählte Verzeichnis haben!"
; LangString DESC_MUI_DIRECTORYPAGE_TEXT_TOP ${LANG_SPANISH} "El usuario debe tener permisos de escritura para la carpeta seleccionada!"

;LangString DESC_EXISTS ${LANG_ENGLISH} "An existing version of ${PACKAGE} was found in:$\n$0.$\n$\nDo you want to uninstall it first?"
;LangString DESC_EXISTS ${LANG_GERMAN} "${PACKAGE} wurde in:$\n$0 gefunden.$\n$\nSoll dies zunächst entfernt werden?"
;LangString DESC_EXISTS ${LANG_SPANISH} "Se ha encontrado una versión existente de ${PACKAGE} en:$\n$0.$\n$\n¿Desea desinstalarla primero?"

;LangString DESC_EXISTS_CANCEL ${LANG_ENGLISH} "Installation canceled."
;LangString DESC_EXISTS_CANCEL ${LANG_GERMAN} "Installation abgebrochen."
;LangString DESC_EXISTS_CANCEL ${LANG_SPANISH} "Instalación cancelada."

LangString DESC_OLDVERSION0 ${LANG_ENGLISH} "Old version detected" 
LangString DESC_OLDVERSION0 ${LANG_GERMAN} "Alte Version gefunden" 
LangString DESC_OLDVERSION0 ${LANG_SPANISH} "Se ha detectado una versión antigua" 

LangString DESC_OLDVERSION1 ${LANG_ENGLISH} "Choose whether to uninstall the previous version."
LangString DESC_OLDVERSION1 ${LANG_GERMAN}  "Auswählen, ob vorherige Version entfernt wird."
LangString DESC_OLDVERSION1 ${LANG_SPANISH} "Selecciona si deseas desinstalar la versión anterior."

LangString DESC_OLDVERSION2 ${LANG_ENGLISH} "An older version of ${PACKAGE} is installed in$\r$\n$\r$\n    $OldUninstaller$\r$\n$\r$\nDo you want to uninstall it before continuing?"
LangString DESC_OLDVERSION2 ${LANG_GERMAN}  "Eine ältere ${PACKAGE} Version ist bereits installiert in$\r$\n$\r$\n    $OldUninstaller$\r$\n$\r$\nSoll diese zunächst entfernt werden?"
LangString DESC_OLDVERSION2 ${LANG_SPANISH} "Hay una versión anterior de ${PACKAGE} instalada en$\r$\n$\r$\n    $OldUninstaller$\r$\n$\r$\n¿Desea desinstalarla antes de continuar?"
    
LangString DESC_OLDVERSION3 ${LANG_ENGLISH} "Yes, uninstall old version"
LangString DESC_OLDVERSION3 ${LANG_GERMAN}  "Ja, alte Version entfernen"
LangString DESC_OLDVERSION3 ${LANG_SPANISH} "Sí, desinstalar la versión antigua"

LangString DESC_OLDVERSION4 ${LANG_ENGLISH} "No, keep old version"    
LangString DESC_OLDVERSION4 ${LANG_GERMAN}  "Nein, alte Version behalten"
LangString DESC_OLDVERSION4 ${LANG_SPANISH} "No, mantén la versión antigua"

LangString DESC_MUI_FINISHPAGE_LINK ${LANG_ENGLISH} "Visit the QMapShack site for the latest news, FAQs and support"
LangString DESC_MUI_FINISHPAGE_LINK ${LANG_GERMAN}  "Besuchen Sie die QMapShack im Internet für Neuigkeiten, FAQ und support"
LangString DESC_MUI_FINISHPAGE_LINK ${LANG_SPANISH} "Visite el sitio web de QMapShack para conocer las últimas noticias, preguntas frecuentes y asistencia técnica"

LangString DESC_MUI_WELCOMEPAGE_TEXT ${LANG_ENGLISH} "QMapShack is a consumer grade software to work with data acquired by GPS devices. The data can be displayed on a variety of maps and stored in a database. Additionally new data can be created to plan tours.$\r$\nThe installed package is a preliminary single-user test version. Please, report any issues to https://github.com/Maproom/qmapshack/issues.$\r$\nBefore proceeding with this installer completely uninstall any existing QMapShack software."
LangString DESC_MUI_WELCOMEPAGE_TEXT ${LANG_GERMAN}  "QMapShack ist eine Software zur Verarbeitung der von GPS-Geräten erfassten Daten. Die Daten können auf einer Vielzahl von Karten angezeigt und in einer Datenbank gespeichert werden. Zusätzlich können neue Daten zur Planung von Touren erstellt werden.$\r$\nDas installierte Paket ist eine Vorab- und Testversion für einen Einzelnutzer. Bitte https://github.com/Maproom/qmapshack/issues benutzen, um über Probleme zu berichten.$\r$\nVor der Installation muss alle vorhandene QMapShack Software deinstalliert werden."
LangString DESC_MUI_WELCOMEPAGE_TEXT ${LANG_SPANISH} "QMapShack es un software de consumo para trabajar con datos adquiridos por dispositivos GPS. Los datos pueden visualizarse en diversos mapas y almacenarse en una base de datos. Además, se pueden crear nuevos datos para planificar recorridos.$\r$\nEl paquete instalado es una versión preliminar de prueba para un solo usuario. Por favor, informe de cualquier problema a https://github.com/Maproom/qmapshack/issues.$\r$\nAntes de proceder con este instalador desinstalar completamente cualquier software QMapShack existente."

LangString DESC_MSVC ${LANG_ENGLISH} "Microsoft Visual C++ 2022 Runtime Libraries. Typically already installed on your PC. You only need to install them if it doesn't work without."
LangString DESC_MSVC ${LANG_GERMAN}  "Microsoft Visual C++ 2022 Laufzeitbibliotheken. Diese sind meist bereits auf dem Rechner installiert. Versuchen Sie die Installation zunächst einmal ohne dies."
LangString DESC_MSVC ${LANG_SPANISH} "Bibliotecas de ejecución de Microsoft Visual C++ 2022. Normalmente ya están instaladas en el ordenador. Sólo es necesario instalarlas si no funciona sin."

LangString DESC_QMapShack ${LANG_ENGLISH} "Install QMapShack and QMapTool."
LangString DESC_QMapShack ${LANG_GERMAN}  "QMapShack und QMapTool installieren."
LangString DESC_QMapShack ${LANG_SPANISH} "Instalar QMapShack y QMapTool."

LangString DESC_StartMenu ${LANG_ENGLISH} "Create Start Menu (deselect if you want to install QMapShack as portable app)"
LangString DESC_StartMenu ${LANG_GERMAN}  "Erzeuge Start Menü (weglassen, wenn QMapShack als portable app installiert werden soll)"
LangString DESC_StartMenu ${LANG_SPANISH} "Crear Menú de Inicio (desmarca si quieres instalar QMapShack como app portable)"

LangString DESC_Register ${LANG_ENGLISH}  "Register software (deselect if you want to install QMapShack as portable app)"
LangString DESC_Register ${LANG_GERMAN}   "Software registrieren (weglassen, wenn QMapShack als portable app installiert werden soll)"
LangString DESC_Register ${LANG_SPANISH}  "Registrar software (desmarca si quieres instalar QMapShack como app portable)"

LangString DESC_Uninstall ${LANG_ENGLISH} "Uninstall QMapShack software package"
LangString DESC_Uninstall ${LANG_GERMAN}  "QMapShack Softwarepaket deinstallieren"
LangString DESC_Uninstall ${LANG_SPANISH} "Desinstalar el paquete de software QMapShack"

LangString DESC_UninstallInfo ${LANG_ENGLISH} "The program will now be uninstalled.$\r$\n$\r$\nAll application files will be removed, but the following files and folders will remain intact:$\r$\n$\r$\n  * %USERPROFILE%\.config\QLandkarte\workspace.db (configuration settings)$\r$\n$\r$\n  * %USERPROFILE%\.QMapShacks (cached online map tiles)$\r$\n$\r$\n  * %LOCALAPPDATA%\Temp\org.qlandkarte.QMapShack.log (logfile)$\r$\n$\r$\nClick Next to continue."
LangString DESC_UninstallInfo ${LANG_GERMAN}  "Das Programm wird nun deinstalliert.$\r$\n$\r$\nAlle Anwendungsdateien werden entfernt, aber die folgenden Dateien und Ordner bleiben erhalten:$\r$\n$\r$\n  * %USERPROFILE%\.config\QLandkarte\workspace.db (Konfigurationseinstellungen)$\r$\n$\r$\n  * %USERPROFILE%\. QMapShacks (zwischengespeicherte Online-Kartenkacheln)$\r$\n$\r$\n  * %LOCALAPPDATA%\Temp\org.qlandkarte.QMapShack.log (Protokolldatei)$\r$\n$\r$\nKlicken Sie auf Weiter, um fortzufahren."
LangString DESC_UninstallInfo ${LANG_SPANISH} "El programa se desinstalará ahora.$\r$\n$\r$\nSe eliminarán todos los archivos de la aplicación, pero los siguientes archivos y carpetas permanecerán intactos:$\r$\n$\r$\n  * %USERPROFILE%\.config\QLandkarte\workspace.db (configuración)$\r$\n$\r$\n  * %USERPROFILE%\. QMapShacks (mosaicos de mapas en línea almacenados en caché)$\r$\n$\r$\n  * %LOCALAPPDATA%\Temp\org.qlandkarte.QMapShack.log (archivo de registro)$\r$\n$\r$\nHaga clic en Siguiente para continuar."


;Assign descriptions to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${MSVC}      $(DESC_MSVC)
    !insertmacro MUI_DESCRIPTION_TEXT ${QMapShack} $(DESC_QMapShack)
    !insertmacro MUI_DESCRIPTION_TEXT ${StartMenu} $(DESC_StartMenu)
    !insertmacro MUI_DESCRIPTION_TEXT ${Register}  $(DESC_Register)

!insertmacro MUI_FUNCTION_DESCRIPTION_END

;-------------------------------------

!macro StrContains OUTVAR HAYSTACK NEEDLE

StrLen $R0 "${NEEDLE}" ; length of needle
StrLen $R1 "${HAYSTACK}" ; length of haystack
StrCpy ${OUTVAR} "" ; default: not found
StrCpy $R2 0 ; current index


IntCmp $R2 $R1 StrContainsDone StrContainsLoopContinue StrContainsLoopContinue

StrContainsLoopContinue:
StrCpy $R3 "${HAYSTACK}" $R0 $R2
StrCmp $R3 "${NEEDLE}" StrContainsFound
IntOp $R2 $R2 + 1
IntCmp $R2 $R1 StrContainsDone StrContainsLoopContinue StrContainsLoopContinue

StrContainsFound:
StrCpy ${OUTVAR} $R2
Goto StrContainsDone

StrContainsDone:
!macroend

;--------------------------------
;Installer Functions

Function .onInit
   
  ClearErrors
  
  !insertmacro MUI_LANGDLL_DISPLAY

 
  
  ${IfNot} ${AtLeastWin10}
    MessageBox MB_OK "$(MSG_W10)"
    Quit
  ${EndIf}

  ${If} ${RunningX64}
    SetRegView 64
  ${Else}
    MessageBox MB_OK "$(MSG_B32)"
    Quit
  ${EndIf}  
  
  ; Check if previous install path exists in registry for all users
      ReadRegStr $OldUninstaller HKLM "Software\${PACKAGE}" "Install_Dir"
;MessageBox MB_OK 'Old installer0: *$OldUninstaller* "Software\${PACKAGE}" "Install_Dir"'
  ${If} $OldUninstaller == ""
      ; Check if previous install path exists in registry for current user
      ReadRegStr $OldUninstaller HKCU "Software\${PACKAGE}" "Install_Dir"
  ${EndIf}
  
  ; $OldUninstaller points to the existing old installer either for all users of for current user
  
;MessageBox MB_OK 'Old installer: *$OldUninstaller*'
  

  
FunctionEnd

;--------------------------------
; Custom page: Old version check
;--------------------------------

Function OldVersionPageCreate

   nsExec::ExecToStack 'tasklist /FO CSV /NH /FI "IMAGENAME eq qmapshack.exe"' ; other recommended methods fail!
    Pop $0  ; exit code, should be 0
    Pop $1  ; first line of output ; if failure: "INFORMATION: Es werden keine Aufgaben mit den angegebenen Kriterien ausgeführt."
                                   ; if success: "qmapshack.exe","16580","Console","1","89.744 K"
    
    ;MessageBox MB_OK "Sub $0. string *$1*"
    
    !insertmacro StrContains $2 $1 "qmapshack.exe"  ; $2 variable gets result, $1 is string output of tasklist
 
    StrCmp $2 "" notfound

    MessageBox MB_OK "$(MSG_ISQMS)"
    Quit
  
    notfound:
    ;MessageBox MB_OK 'Did not find running QMS'
   
  ${If} $OldUninstaller == ""
    Abort ; skip this page if no old version
  ${EndIf}

  !insertmacro MUI_HEADER_TEXT $(DESC_OLDVERSION0) $(DESC_OLDVERSION1)

  nsDialogs::Create 1018
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}

  ; Info label
  ${NSD_CreateLabel} 0 0 100% 60u $(DESC_OLDVERSION2)
  Pop $1

  ; Radio buttons
  ${NSD_CreateRadioButton} 0 60u 100% 12u $(DESC_OLDVERSION3)
  Pop $hCtl_RadioYes
  SendMessage $hCtl_RadioYes ${BM_SETCHECK} ${BST_CHECKED} 0

  ${NSD_CreateRadioButton} 0 80u 100% 12u $(DESC_OLDVERSION4)
  Pop $hCtl_RadioNo

  nsDialogs::Show
FunctionEnd

Function OldVersionPageLeave
  ${NSD_GetState} $hCtl_RadioYes $0
  ${If} $0 == ${BST_CHECKED}
  
    ; Run old uninstaller silently
    IfFileExists "$OldUninstaller\Uninstall.exe" 0 +4
        ExecWait '"$OldUninstaller\Uninstall.exe"  _?=$OldUninstaller'
        Delete "$OldUninstaller\Uninstall.exe"
        RMDir /r "$OldUninstaller"        
        
  ${EndIf}
FunctionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall" un.Uninstall

  DetailPrint "Uninstalling ..."

  SetRegView 64
  SetShellVarContext all

  Delete "$INSTDIR\Uninstall.exe"
  RMDir /r "$INSTDIR"

  !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder

  Delete "$SMPROGRAMS\$StartMenuFolder\*.*"
  RMDir /r "$SMPROGRAMS\$StartMenuFolder"

  DeleteRegKey HKLM "Software\${PACKAGE}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PACKAGE}"

SectionEnd

!insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN 
    !insertmacro MUI_DESCRIPTION_TEXT ${un.Uninstall} $(DESC_Uninstall)
!insertmacro MUI_UNFUNCTION_DESCRIPTION_END 

;--------------------------------
;Uninstaller Functions

Function un.onInit

  !insertmacro MUI_UNGETLANGUAGE
  
FunctionEnd

;---------------------------------

# Custom info page for uninstaller
Function un.InfoPage

    nsDialogs::Create 1018
       
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}

    ${NSD_CreateLabel} 0 0 100% 100% "$(DESC_UninstallInfo)"

    Pop $1

    nsDialogs::Show
FunctionEnd


