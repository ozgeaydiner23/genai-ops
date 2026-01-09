# GENAI-OPS Development Tools Installation Script
# Run as Administrator: Right-click PowerShell -> Run as Administrator
# Then run: .\install-tools.ps1

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "GENAI-OPS Tools Installation" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Check if Chocolatey is installed
Write-Host "Checking for Chocolatey package manager..." -ForegroundColor Yellow
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..." -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Refresh environment
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} else {
    Write-Host "Chocolatey is already installed." -ForegroundColor Green
}

Write-Host ""

# Install Node.js
Write-Host "Installing Node.js 18 LTS..." -ForegroundColor Yellow
choco install nodejs-lts -y
Write-Host "Node.js installed!" -ForegroundColor Green
Write-Host ""

# Install Java 17
Write-Host "Installing Java 17 (Temurin)..." -ForegroundColor Yellow
choco install temurin17 -y
Write-Host "Java 17 installed!" -ForegroundColor Green
Write-Host ""

# Install Maven
Write-Host "Installing Apache Maven..." -ForegroundColor Yellow
choco install maven -y
Write-Host "Maven installed!" -ForegroundColor Green
Write-Host ""

# Install Git (if not installed)
Write-Host "Checking for Git..." -ForegroundColor Yellow
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Git..." -ForegroundColor Green
    choco install git -y
} else {
    Write-Host "Git is already installed." -ForegroundColor Green
}
Write-Host ""

# Refresh environment variables
Write-Host "Refreshing environment variables..." -ForegroundColor Yellow
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please RESTART your terminal/PowerShell window for changes to take effect." -ForegroundColor Yellow
Write-Host ""
Write-Host "After restarting, verify installations:" -ForegroundColor Cyan
Write-Host "  node --version" -ForegroundColor White
Write-Host "  npm --version" -ForegroundColor White
Write-Host "  java -version" -ForegroundColor White
Write-Host "  mvn -version" -ForegroundColor White
Write-Host ""
Write-Host "Then run: .\setup-project.ps1" -ForegroundColor Green
Write-Host ""
