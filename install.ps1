if ($PSVersionTable.PSVersion.Major -lt 6) {
    Write-Output "PowerShell 6+ is recommended, you have version $($PSVersionTable.PSVersion.ToString())"
}

function Get-InstallPath($baseInstallPath) {
    return Join-Path -Path $baseInstallPath -ChildPath 'GitCrypt'
}

$installDir = Get-InstallPath(Get-Location)
$pythonCommand = "python"
$profilePath = $Profile.CurrentUserAllHosts
if ($PSVersionTable.Platform -eq "Unix") {
    if ((id -u) -eq 0) {
        $installDir = Get-InstallPath '/etc'
        $profilePath = $Profile.AllUsersAllHosts
    } else {
        $installDir = Get-InstallPath $env:HOME
    }
    $pythonCommand = (Join-Path -Path $installDir -ChildPath '/bin/python3').ToString()
} elseif ($PSVersionTable.Platform -eq "Win32NT") {
    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        $installDir = Get-InstallPath $env:ProgramFiles
        $profilePath = $Profile.AllUsersAllHosts
    } else {
        $installDir = Get-InstallPath $env:LOCALAPPDATA
    }
    $pythonCommand = (Join-Path -Path $installDir -ChildPath '\Scripts\python.exe').ToString()
}

Write-Output "=======Installing GitCrypt======="


if (Test-Path -Path $installDir -PathType Container) {
    Write-Output "encryption tools already exists, removing..."

    if (Test-Path -Path $profilePath -PathType Leaf) {
        "removing key from PowerShell profile at $profilePath"
        $backupPath = $profilePath + ".bak"
        Copy-Item -Path $profilePath -Destination $backupPath
        (Get-Content $profilePath) | Where-Object { $_ -notmatch ".*ENCRYPTION_TOOLS_KEY.*" } | Set-Content $profilePath
    }

    Write-Output "removing files"
    Remove-Item -Recurse -Force $installDir

    Write-Output "Unsetting git aliases"
    git config --global --unset alias.hide
    git config --global --unset alias.reveal
    git config --global --unset alias.initEncrypt
}

Write-Output "moving files to $installDir"
Copy-Item -Recurse -Path (Get-Location) -Destination $installDir

$password = Read-Host -Prompt "Encryption key password"
$key = Invoke-Expression "$pythonCommand key_generator.py $password"

if (Test-Path -Path $profilePath -PathType Leaf) {
    Write-Output "exporting key to PowerShell profile at $profilePath"
    Add-Content -Path $profilePath -Value ('$Env:ENCRYPTION_TOOLS_KEY = ' + "`"$key`"")
}

Write-Output "setting aliases"
$pythonCmdString = $pythonCommand.Replace("\", "\\")
$hideScript = $(Join-Path -Path $installDir -ChildPath "crypter.py").Replace("\", "\\")
git config --global alias.hide "!$pythonCmdString $hideScript"
$revealScript = $(Join-Path -Path $installDir -ChildPath "decrypt.py").Replace("\", "\\")
git config --global alias.reveal "!$pythonCmdString $revealScript"
$initEncryptScript = $(Join-Path -Path $installDir -ChildPath "initEncrypt.py").Replace("\", "\\")
git config --global alias.initEncrypt "!$pythonCmdString $initEncryptScript"

$successMsg = @"

--------------------------------------------
Install Complete!


"@ + "Your encryption key is: $key" + @"

You should set the ENCRYPTION_TOOLS_KEY environment variable equal to this key in each shell you will be using with GitCrypt.

"@ + "e.g. in ~/.bash_profile, add this line: export ENCRYPTION_TOOLS_KEY=$key" + @"


To initialize GitEncrypt in a directory: git initEncrypt
To encrypt: git hide
To decrypt: git reveal
--------------------------------------------

"@
Write-Output $successMsg

