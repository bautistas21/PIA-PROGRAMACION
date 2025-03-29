<#
.SYNOPSIS
Module that allows you to identify all the hidden files in a given folder#>
function Get-HiddenFiles {
    param([Parameter(Mandatory=$true)][string]$FolderPath)

    try {
        if (-not (Test-Path -Path $FolderPath -PathType Container)) {
            Write-Host "La carpeta especificada no existe o no es válida."
            return
        }

        Write-Host "`n--- Archivos ocultos ---" 
        
        $hiddenFiles = Get-ChildItem -Path $FolderPath -Force -Recurse -ErrorAction SilentlyContinue | 
                      Where-Object { $_.Attributes -match 'Hidden' }

        if ($hiddenFiles) {
            $hiddenFiles | Select-Object FullName, Attributes, LastWriteTime | Format-Table -AutoSize
            Write-Host "`nTotal de archivos ocultos en la carpeta: $($hiddenFiles.Count)" 
        } else {
            Write-Host "No se encontraron archivos ocultos en la carpeta especificada." 
        }
    }
    catch {
        Write-Host "Error al buscar archivos ocultos: $_" 
    }
}
