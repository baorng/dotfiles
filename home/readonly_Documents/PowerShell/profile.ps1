#region alias set
Set-Alias cat bat
Set-Alias ls eza
Set-Alias vim nvim
Set-Alias find fd
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
function Initialize-Conda {
    $condaPath = "C:\Users\Ngu\miniforge3\Scripts\conda.exe"
    if (Test-Path $condaPath) {
        # Initialize Conda shell integration
        Write-Host "Initializing Conda..."
        # & $condaPath "config" "--set" "auto_activate_base" "false"
        (& $condaPath "shell.powershell" "hook") | Out-String | Where-Object{$_} | Invoke-Expression

        # Remove the conda and mamba function overrides
        Remove-Item function:conda -ErrorAction SilentlyContinue
        Remove-Item function:mamba -ErrorAction SilentlyContinue
    } else {
        Write-Host "Conda not found at $condaPath"
    }
}

function conda {
    Initialize-Conda
    & conda @args
}

function mamba {
    Initialize-Conda
    & mamba @args
}
#endregion

