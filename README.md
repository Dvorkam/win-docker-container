# Windows Containers on Windows Host Setup Guide

This repository is dedicated to demonstrating the setup and usage of Windows containers on a Windows host. It includes a series of PowerShell scripts designed to automate the initial setup process, ensuring that your Windows environment is ready to run containers efficiently. Below, you'll find details on each script, instructions on how to run them, and additional important information to help you get started with Windows containers.
Overview

Running containers on Windows requires specific features to be enabled and configurations to be applied. The scripts provided in this repository automate these steps:

- `1_activate_services.ps1`: Checks and enables necessary Windows Optional Features for containers, such as Containers, Microsoft-Hyper-V, and Windows-Subsystem-for-Linux. It prompts for a system restart if any changes are made, to ensure the features are fully enabled.

- `2_install_latest_docker_engine.ps1`: Downloads and installs the latest Docker Engine, setting it up to run Windows containers. It handles the download, installation, and configuration of Docker as a service on your system. Can also be run to overwrite docker files with lates version.

- `3_user_rights_elevation_after_reset.ps1`: Applies elevated pivileges for docker to the current to manage Docker and containers. It also sets up a scheduled task to maintain these permissions after every system restart. **Note:** This step is optional. If you are ok with using console or IDE as admin, this step is unnecessary.

## Prerequisites

- Windows 10/11 Pro/Enterprise
- A Windows host with PowerShell 5.1 or higher.
- Administrative privileges are required to run the scripts and make system changes.
- Internet connection

## Getting Started
### Running the Scripts

1. Open PowerShell as Administrator: Right-click on the PowerShell icon and select "Run as Administrator" to open a PowerShell window with administrative privileges.

2. Navigate to the Scripts Directory: Change your current directory to where the scripts are located using the cd command, e.g., `cd c:\repos\win-docker-container`.

3. Execute the Scripts in Order: Run the scripts sequentially to prepare your system for Windows containers. Third scrpit is optional, but without it any operation with docker daemon requires elevated priveledges, that includes IDEs, cmd, or powershell:

    ```powershell

    .\1_activate_services.ps1
    .\2_install_latest_docker_engine.ps1
    .\3_user_rights_elevation_after_reset.ps1
	```

4. Wait for each script to complete before moving on to the next.

Important Considerations

- **System Restart**: You may need to restart your computer after running 1_activate_services.ps1 to apply the changes fully.

- **Internet Connection**: Ensure you have an active internet connection when running 2_install_latest_docker_engine.ps1 as it downloads the latest Docker Engine.

- **Scheduled Task**: The `3_user_rights_elevation_after_reset.ps1` script creates a scheduled task to ensure persistent user permissions for Docker management.

## Security and Compatibility

- Please understand the security implications of enabling container features and installing Docker on your system, especially if you're in a production environment.
- Ensure your Windows version is compatible with the features and Docker versions being installed.

## Next Steps

After completing the setup with these scripts, your Windows host will be ready to run and manage Windows containers. Explore further by deploying containerized applications and utilizing Docker to manage your containers effectively.

Stay tuned for additional resources and guides on deploying and managing Windows containers in this repository.