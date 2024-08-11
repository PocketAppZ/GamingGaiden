@echo off
setlocal enabledelayedexpansion

md "%ALLUSERSPROFILE%\GamingGaiden"

set "InstallDirectory=%ALLUSERSPROFILE%\GamingGaiden"
set "DesktopPath=%USERPROFILE%\Desktop"
set "StartupPath=%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp"
set "StartMenuPath=%APPDATA%\Microsoft\Windows\Start Menu\Programs"
set "IconPath=%InstallDirectory%\icons\running.ico"

REM Quit GamingGaiden if Already running
echo Closing Gaming Gaiden before installation
taskkill /f /im GamingGaiden.exe

REM Cleanup Install directory before installation
echo Cleaning install directory
powershell.exe -NoProfile -Command "Get-ChildItem '%InstallDirectory%' -Exclude backups,GamingGaiden.db | Remove-Item -recurse -force"

REM Install to C:\ProgramData\GamingGaiden
echo Copying Files
xcopy /s/e/q/y "%CD%" "%InstallDirectory%"
del "%InstallDirectory%\Install.bat"

REM Create shortcut using powershell and copy to desktop and start menu
echo.
echo Creating Shortcuts
powershell.exe -NoProfile -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%InstallDirectory%\Gaming Gaiden.lnk'); $Shortcut.TargetPath = '%InstallDirectory%\GamingGaiden.exe'; $Shortcut.WorkingDirectory = '%InstallDirectory%'; $Shortcut.WindowStyle = 7; $Shortcut.Save()"
copy "%InstallDirectory%\Gaming Gaiden.lnk" "%DesktopPath%"
copy "%InstallDirectory%\Gaming Gaiden.lnk" "%StartMenuPath%"

REM Unblock all gaming gaiden files as they are downloaded from internet and blocked by default
echo.
echo Unblocking all Gaming Gaiden files
powershell.exe -NoProfile -Command "Get-ChildItem '%InstallDirectory%' -Recurse | Unblock-File"

REM Copy shortcut to startup directory if user chooses to
echo.
set /p AutoStartChoice="Would you like Gaming Gaiden to auto start at boot? Yes/No: "
if /i "%AutoStartChoice%"=="Yes" (
    copy "%InstallDirectory%\Gaming Gaiden.lnk" "%startupPath%"
    echo Auto start successfully setup.
) else if /i "%AutoStartChoice%"=="Y" (
    copy "%InstallDirectory%\Gaming Gaiden.lnk" "%startupPath%"
    echo Auto start successfully setup.
) else (
    echo Auto start setup cancelled by user.
)

echo.
echo Installation successful at %InstallDirectory%. Run application using shortcuts on desktop / start menu.
echo.
echo Your data is in 'GamingGaiden.db' file and backups are in 'backups\' folder under %InstallDirectory%.
echo.
echo Backup both to external storage regularly. Otherwise you risk loosing all your data if you reinstall Windows.
echo.
echo You can access %InstallDirectory% by clicking "Settings => Open Install Directory" in app menu.
echo.
echo You can now delete the downloaded files if you wish. Press any key to Exit.
pause >nul
exit /b 0