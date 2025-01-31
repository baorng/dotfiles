#region XDG Base Dir set
$Env:XDG_CONFIG_HOME = "$HOME\.config"
#endregion

#region alias set
if (Get-Command -Name bat -ErrorAction SilentlyContinue) {
    Set-Alias cat bat
}
if (Get-Command -Name eza -ErrorAction SilentlyContinue) {
    Set-Alias ls eza
}
if (Get-Command -Name nvim -ErrorAction SilentlyContinue) {
    Set-Alias vim nvim
}
if (Get-Command -Name fd -ErrorAction SilentlyContinue) {
    Set-Alias find fd
}
#endregion

#region yazi initialize
$Env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
$Env:YAZI_CONFIG_HOME = "$HOME\.config\yazi"
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}
#endregion

#region zoxide initalize
Invoke-Expression (& { (zoxide init powershell | Out-String) })
#endregion

