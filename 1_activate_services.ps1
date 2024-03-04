# List of features to check and possibly enable
$features = @("Containers", "Microsoft-Hyper-V", "Microsoft-Windows-Subsystem-Linux")

# Track if any feature was enabled
$featureEnabled = $false

foreach ($feature in $features) {
    # Check if the feature is already enabled
    $featureStatus = Get-WindowsOptionalFeature -FeatureName $feature -Online
    
    if ($featureStatus.State -eq "Enabled") {
        Write-Host "$feature is already enabled."
    } else {
        # If the feature is not enabled, enable it
        Write-Host "$feature is not enabled. Attempting to enable..."
        Enable-WindowsOptionalFeature -Online -FeatureName $feature -All -NoRestart
        
        # Check if the feature was successfully enabled
        if ($?) {
            Write-Host "$feature has been successfully enabled."
            $featureEnabled = $true
        } else {
            Write-Host "Failed to enable $feature."
        }
    }
}

# If any feature was enabled, prompt the user to restart the PC
if ($featureEnabled) {
    Write-Host "At least one feature was enabled. Please restart your PC to complete the installation of features."
    Restart-Computer -Reason "At least one feature was enabled. Please restart your PC to complete the installation of features." -Confirm
}