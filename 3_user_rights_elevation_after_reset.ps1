function Ensure-DockerAccessHelper {
    # Check if DockerAccessHelper is installed (pseudo-code, adjust as necessary)
    if (-not (Get-Module -ListAvailable -Name dockeraccesshelper)) {
        # Install DockerAccessHelper (adjust command as necessary)
		Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Install-Module -Name dockeraccesshelper -Force
    }

    # Add current user to Docker access
    Add-AccountToDockerAccess "$env:USERDOMAIN\$env:USERNAME"
    Write-Host "Added $env:USERDOMAIN\$env:USERNAME to Docker access."
}

function Register-DockerAccessTask {
    $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -Command "Add-AccountToDockerAccess \"$env:USERDOMAIN\$env:USERNAME\""'
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    Register-ScheduledTask -TaskName "DockerAccessOnStartup" -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force
    Write-Host "Scheduled task 'DockerAccessOnStartup' registered to run at startup."
}

# Ensure DockerAccessHelper is installed and configure access
Ensure-DockerAccessHelper

# Register the scheduled task for persistent access configuration
Register-DockerAccessTask