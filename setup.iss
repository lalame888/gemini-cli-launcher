; setup.iss
; Inno Setup script for Gemini CLI Launcher

#define MyAppName "Gemini CLI Launcher"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "lalame888"
#define MyAppURL "https://github.com/lalame888/gemini-cli-launcher"
#define MyAppExeName "Gemini CLI Launcher.exe"
#define MyResetExeName "Reset Settings.exe"

[Setup]
AppId={{AUTO_GUID}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=LICENSE
; Use the version define directly to build the filename
OutputBaseFilename=Gemini-CLI-Launcher-Setup-v{#MyAppVersion}
OutputDir=release
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupIconFile=app.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName}

; --- Version Info for Setup.exe file properties ---
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppName}
VersionInfoCopyright=Copyright (C) {#MyAppPublisher}

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "chinesetraditional"; MessagesFile: "compiler:Languages\ChineseTraditional.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Pack the entire output of the 'onedir' build for the main app
Source: "dist\Gemini CLI Launcher\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs
; Pack the entire output of the 'onedir' build for the reset tool into the same main folder
Source: "dist\Reset Settings\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
; Point to the reset exe in the main {app} folder
Name: "{group}\Reset Settings"; Filename: "{app}\{#MyResetExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
