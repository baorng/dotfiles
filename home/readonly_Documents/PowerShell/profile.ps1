# Custom prompt function to show path above the cursor
function prompt {
    "$PWD`nPS> "
}

#region env set
$Env:XDG_CONFIG_HOME = "$HOME\.config"
$Env:EDITOR = "hx"
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

#region helix windows symlink
#sudo pwsh -c "New-Item -ItemType SymbolicLink -Path $env:APPDATA\helix -Target $HOME\.config\helix"
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

