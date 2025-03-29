<#
.SYNOPSIS
Use the Virustotal api in order to get the hashes of the files in a specified folder.
.DESCRIPTION
Calculates the hash of each file in a given folder using the VirusTotal API and the default algorithm  which is SHA256 
#>
function Get-Hashes {
    param(
        [Parameter(Mandatory)]
        [string]$FolderPath = $(Read-Host "Ingresa la ruta de la carpeta: "),
        [Parameter(Mandatory)]
        [string]$ApiKey = $(Read-Host "Ingresa tu apikey: ")
    )
    $url = "https://www.virustotal.com/vtapi/v2/file/report"
    $algorithm = "SHA256"
    $verifyingPath = (Test-Path -Path $folderPath)

    if ($verifyingPath) {
        try {
            $listFiles = Get-ChildItem -Path $folderPath -File
            foreach ($file in $listFiles) {
                $hash = Get-FileHash -Path $file.FullName -Algorithm $algorithm
                Write-Host "Hash del archivo $($file.Name): $hash" 

                try {
                    $params = @{
                        apikey   = $apiKey
                        resource = $hash.Hash
                    }

                } catch {
                    Write-Error "Error al realizar la solicitud a la API de VirusTotal: $_" 
                }
                Start-Sleep -Seconds 3
            }
        } catch {
            Write-Error "Hubo un error al obtener los hashes de los archivos: $_"
        }
    } else {
        Write-Host "No se encontró la carpeta ingresada." 
    }
}

