if ($PSVersionTable.PSVersion.Major -lt 6) {
    Write-Output "PowerShell 6+ is recommended, you have version $($PSVersionTable.PSVersion.ToString())"
}

function Get-InstallPath($baseInstallPath) {
    return Join-Path -Path $baseInstallPath -ChildPath 'GitCrypt'
}

$installDir = Get-InstallPath(Get-Location)
$profilePath = $Profile.CurrentUserAllHosts
if ($PSVersionTable.Platform -eq "Unix") {
    if ((id -u) -eq 0) {
        $installDir = Get-InstallPath '/etc'
        $profilePath = $Profile.AllUsersAllHosts
    } else {
        $installDir = Get-InstallPath $env:HOME
    }
} elseif ($PSVersionTable.Platform -eq "Win32NT") {
    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        $installDir = Get-InstallPath $env:ProgramFiles
        $profilePath = $Profile.AllUsersAllHosts
    } else {
        $installDir = Get-InstallPath $env:LOCALAPPDATA
    }
}

Write-Output "=======Uninstalling GitCrypt======="


if (Test-Path -Path $installDir -PathType Container) {
    Write-Output "removing encryption tools..."

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