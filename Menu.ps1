<#
    MENÚ CON MÓDULOS LOCALES
    - Los módulos están en subcarpetas (Module1, Module2, Module3, Module4)
    - Mismo directorio que el script del menú
    - Manejo de excepciones integrado
    - Ciclo continuo hasta que el usuario elija salir
#>

#Configuration
$ErrorActionPreference = "Stop"
$scriptDirectory = $PSScriptRoot
$moduleFolders = @("Module1", "Module2", "Module4")

function Show-Menu {
    Write-Host "          MENÚ PRINCIPAL            "
    Write-Host " ------------------------------------ "
    Write-Host "1- Hashes y archivos ocultos)"
    Write-Host "2- Archivos ocultos de una carpeta"
    Write-Host "3- Usuarios inactivos y Usuarios administradores"
    Write-Host "4- Salir"
    Write-Host " ------------------------------------ "
}

#Funciton that import the modules
function Import-LocalModule {
    param (
        [string]$ModuleName
    )
    
    $modulePath = Join-Path -Path $scriptDirectory -ChildPath $ModuleName
    $moduleFile = Join-Path -Path $modulePath -ChildPath "$ModuleName.psm1"
    
    try {
        if (Test-Path $moduleFile) {
            Import-Module $moduleFile -Force -ErrorAction Stop
            Write-Host "Módulo $ModuleName importado correctamente"
            return $true
        } else {
            Write-Host "No se encontró el módulo $ModuleName en $modulePath"
            return $false
        }
    }
    catch {
        Write-Host "Error al importar $ModuleName`: $_"
        return $false
    }
}


do {
    Show-Menu
    $opcion = Read-Host "`nSelecciona una opción (1-4)"
    
    try {
        switch ($opcion) {
            '1' { 
                if (Import-LocalModule -ModuleName "Module1") {

                    if (Import-LocalModule -ModuleName "Module1") {
                    
                    $FolderPath = Read-Host "Introduce la ruta del directorio a escanear"
                    $apiKey = Read-Host "Introduce tu API key de VirusTotal"
                    }
                    #Validates the path of the folder
                    if (-not (Test-Path -Path $FolderPath -PathType Container)) {
                        Write-Host "La ruta especificada no existe o no es un directorio"
                     }
                    #
                    if (Get-Command -Name "Get-Hashes" -ErrorAction SilentlyContinue) {
                        Get-Hashes -FolderPath $FolderPath -ApiKey $apiKey
                    } else {
                        Write-Host "La función no está contenida en el módulo"
                    }
                }
                Start-Sleep -Seconds 1
                
            }
            '2' { 
                if (Import-LocalModule -ModuleName "Module2") {
                   $FolderPath = Read-Host "Introduce la ruta del directorio a escanear"
                    if (Get-Command -Name "Get-HiddenFiles" -ErrorAction SilentlyContinue) {
                        Get-HiddenFiles -FolderPath $FolderPath

                    } else {
                        Write-Host "La función no está contenida en el módulo"
                    }
                }
                Start-Sleep -Seconds 1
                
            }
            '3' { 
                if (Import-LocalModule -ModuleName "Module4") {
                    if (Get-Command -Name "Get-InactiveUsers" -ErrorAction SilentlyContinue) {
                        Write-Host "Usuarios inactivos: "
                        Get-InactiveUsers
                        Write-Host "Usuarios administradores: "
                        Get-AdminUsers

                    } else {
                        Write-Host "El módulo no contiene las funciones"
                    }
                }
                Start-Sleep -Seconds 1
                
            }
            '4' { 
                Write-Host "Saliendo del programa..."
                Start-Sleep -Seconds 1
                exit 
            }
            default {
                Write-Host "Opción no válida. Introduce un número del 1 al 5."
                
            }
        }
    }
    catch {
        Write-Host "Error inesperado: $_"
        Pause
    }
} while ($true)