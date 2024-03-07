# Use a base image compatible with Windows 10 20H2
FROM mcr.microsoft.com/windows:20H2

# Install Chocolatey
USER ContainerAdministrator
RUN powershell -Command \
        Set-ExecutionPolicy Bypass -Scope Process -Force; \
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

# Use Chocolatey to install CMake, Git, and adding vcpkg
RUN powershell -Command \
        choco install cmake git -y;

# Install specific Python version (3.9.9) and add it to PATH
RUN powershell -Command \
        choco install python --version=3.9.9 -y; \
        $env:Path += ';C:\Python39;C:\Python39\Scripts'; \
        [Environment]::SetEnvironmentVariable('Path', $env:Path, [EnvironmentVariableTarget]::Machine);

# Clone vcpkg
RUN powershell -Command \
		git clone https://github.com/Microsoft/vcpkg.git; \
        .\vcpkg\bootstrap-vcpkg.bat

# Adding vcpkg to PATH
RUN powershell -Command \
        $env:Path += ';C:\vcpkg'; \
        [Environment]::SetEnvironmentVariable('Path', $env:Path, [EnvironmentVariableTarget]::Machine);

# Install Python packages

RUN powershell -Command python -m pip install --upgrade pip

RUN powershell -Command \
        pip install pyarmor poetry pytest pytest-cov
		
# Install Visual Studio Build Tools 2022 with the C++ build tools
# https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2022
RUN powershell -Command choco install visualstudio2022buildtools -y;

RUN powershell -Command choco install visualstudio2022-workload-vctools -y;


# Note: Adjust the Dockerfile according to your specific needs. The PATH might need specific adjustments.
