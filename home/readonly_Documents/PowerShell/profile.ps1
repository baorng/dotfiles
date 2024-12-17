#region alias set
Set-Alias cat bat
Set-Alias ls eza
Set-Alias vim nvim
Set-Alias find fd
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

