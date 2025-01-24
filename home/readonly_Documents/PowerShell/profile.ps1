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

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "C:\Users\Ngu\miniforge3\Scripts\conda.exe") {
    # (& "C:\Users\Ngu\miniforge3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
    $Env:CONDA_EXE = "C:\Users\Ngu\miniforge3\Scripts\conda.exe"
    $Env:_CE_M = $null
    $Env:_CE_CONDA = $null
    $Env:_CONDA_ROOT = "C:\Users\Ngu\miniforge3"
    $Env:_CONDA_EXE = "C:\Users\Ngu\miniforge3\Scripts\conda.exe"
    $CondaModuleArgs = @{ChangePs1 = $True}
    Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1" -ArgumentList $CondaModuleArgs

    # conda activate base

    Remove-Variable CondaModuleArgs
}
#endregion
