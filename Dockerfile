FROM mcr.microsoft.com/windows:20H2-amd64

# Install Chocolatey
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
# Install Python 3.9.9
RUN choco install python --version=3.9.9 -y

# Upgrade pip
#RUN python.exe -m pip install --upgrade pip


# Install Poetry
RUN powershell -Command \
    pip install poetry

# Install Visual Studio Build Tools 2022 with C++ workload
RUN choco install visualstudio2022buildtools \
-y \
--package-parameters \
"--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended" \
--timeout 21600 \
--verbose

# Install latest CMake
RUN choco install cmake -y

# Install Git (required for vcpkg)
RUN choco install git -y

# Install vcpkg
RUN git clone https://github.com/Microsoft/vcpkg.git C:\vcpkg \
    && C:\vcpkg\bootstrap-vcpkg.bat

# Set the environment variable for vcpkg
ENV VCPKG_ROOT C:\\vcpkg
RUN setx /M PATH "%PATH%;C:\vcpkg"

# Perform any additional configuration and clean up
RUN powershell -Command \
    Remove-Item -Force C:\vcpkg\downloads\*; \
    vcpkg integrate install