function Stop-DockerService {
    $serviceName = "docker"
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service -ne $null -and $service.Status -eq 'Running') {
        Stop-Service -Name $serviceName
        Write-Host "Docker service stopped."
    } else {
        Write-Host "Docker service is not running."
    }
}

function Download-LatestDockerEngine {
    $url = "https://download.docker.com/win/static/stable/x86_64/"
    $page = Invoke-WebRequest -Uri $url
    $latestFile = ($page.Links.href | Where-Object { $_ -match "docker-\d+\.\d+\.\d+\.zip" } | Sort-Object -Descending | Select-Object -First 1).Trim('/')
    $downloadUrl = $url + $latestFile
    $outputPath = "$env:TEMP\$latestFile"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $outputPath
    Write-Host "Downloaded $latestFile to $outputPath"
    return $outputPath
}

function Unpack-DockerEngine {
    param (
        [Parameter(Mandatory)]
        [string]$filePath
    )
    $destination = "C:\"
    if (-not (Test-Path $destination)) {
        New-Item -ItemType Directory -Path $destination
    }
    Expand-Archive -Path $filePath -DestinationPath $destination -Force
    Write-Host "Unpacked to $destination"
}

function Remove-DownloadedFile {
    param (
        [Parameter(Mandatory)]
        [string]$filePath
    )
    if (Test-Path $filePath) {
        Remove-Item -Path $filePath -Force
        Write-Host "Removed downloaded file: $filePath"
    } else {
        Write-Host "File not found: $filePath"
    }
}

function Add-DockerToSystemPath {
    $dockerPath = "C:\docker"
    $systemPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    if (-not ($systemPath -split ";" -contains $dockerPath)) {
        $newPath = $systemPath + ";$dockerPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
        # Update the process-level PATH as well
        $processPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Process)
        [System.Environment]::SetEnvironmentVariable("Path", $processPath + ";$dockerPath", [System.EnvironmentVariableTarget]::Process)
        Write-Host "$dockerPath added to system PATH."
    } else {
        Write-Host "$dockerPath is already in the system PATH."
    }
}

function Register-DockerService {
    try {
        Start-Process dockerd -ArgumentList '--register-service' -NoNewWindow -Wait -ErrorAction Stop
        Write-Host "Docker service registered."
    } catch {
        Write-Host "Failed to register Docker service. Error: $_"
    }
}

function Start-DockerService {
    try {
        Start-Service -Name "docker" -ErrorAction Stop
        Write-Host "Docker service started."
    } catch {
        Write-Host "Failed to start Docker service. Error: $_"
    }
}

# Script Execution Flow
Stop-DockerService
$downloadedFilePath = Download-LatestDockerEngine
Unpack-DockerEngine -filePath $downloadedFilePath
Remove-DownloadedFile -filePath $downloadedFilePath
Add-DockerToSystemPath
Register-DockerService
Start-DockerService