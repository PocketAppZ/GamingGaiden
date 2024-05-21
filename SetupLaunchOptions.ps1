#Requires -Version 5.1
param(
    [string]$InstallDirectory
) 

Set-Location $InstallDirectory
$DesktopPath = [Environment]::GetFolderPath("Desktop")

function UserPrompt($Msg, $Color = "Green") {
    Write-Host $Msg -ForegroundColor $Color
}

function CreateShortcut() {
    $gamingGaidenScript = (Get-Item ".\GamingGaiden.ps1")
    $gamingGaidenPath = $gamingGaidenScript.FullName
    $workingDirectory = $gamingGaidenScript.Directory.FullName

    $iconPath = (Get-Item ".\icons\running.ico").FullName

    $shortcut = (New-Object -ComObject Wscript.Shell).CreateShortcut("$DesktopPath\Gaming Gaiden.lnk")
    $shortcut.TargetPath = 'powershell'
    $shortcut.Arguments = "-NoLogo -ExecutionPolicy bypass -File `"$gamingGaidenPath`""
    $shortcut.IconLocation = $iconPath
    $shortcut.WorkingDirectory = "$workingDirectory"
    $shortcut.WindowStyle = 7 # Takes only int values, 7 is "Minimized" style
    $shortcut.Save()
    
    Copy-Item "$DesktopPath\Gaming Gaiden.lnk" .
    Copy-Item "$DesktopPath\Gaming Gaiden.lnk" "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\"
}

function SetupAutoStart() {
    $startupPath = [Environment]::GetFolderPath('Startup')

    Copy-Item "$DesktopPath\Gaming Gaiden.lnk" "$startupPath\"
}

UserPrompt "Creating Shortcuts"
CreateShortcut

UserPrompt "Unblocking all Gaming Gaiden files"
Get-ChildItem . -recurse | Unblock-File

$AutoStartChoice = Read-Host -Prompt "Would you like Gaming Gaiden to auto start at boot? Yes/No"
if ( $AutoStartChoice.ToLower() -match 'yes|y' ) { 
    SetupAutoStart
    UserPrompt "Auto start successfully setup."
}
else {
    UserPrompt "Auto start setup cancelled by user."
}
UserPrompt "Installation successful. Press any key to exit..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit 0