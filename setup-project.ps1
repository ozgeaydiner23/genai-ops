# GENAI-OPS Project Setup Script
# Run this after installing tools with install-tools.ps1

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "GENAI-OPS Project Setup" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check if tools are installed
Write-Host "Checking required tools..." -ForegroundColor Yellow

$toolsOk = $true

if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Node.js is not installed!" -ForegroundColor Red
    $toolsOk = $false
}

if (!(Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: npm is not installed!" -ForegroundColor Red
    $toolsOk = $false
}

if (!(Get-Command java -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Java is not installed!" -ForegroundColor Red
    $toolsOk = $false
}

if (!(Get-Command mvn -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Maven is not installed!" -ForegroundColor Red
    $toolsOk = $false
}

if (-not $toolsOk) {
    Write-Host ""
    Write-Host "Please run install-tools.ps1 first (as Administrator)" -ForegroundColor Yellow
    exit 1
}

Write-Host "All tools are installed!" -ForegroundColor Green
Write-Host ""

# Display versions
Write-Host "Installed versions:" -ForegroundColor Cyan
node --version
npm --version
java -version
mvn -version
Write-Host ""

# Setup Frontend
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Setting up Frontend..." -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

if (Test-Path "frontend") {
    Set-Location frontend
    
    # Create .env file if it doesn't exist
    if (!(Test-Path ".env")) {
        Write-Host "Creating .env file..." -ForegroundColor Yellow
        "VITE_API_URL=http://localhost:8080" | Out-File -FilePath ".env" -Encoding UTF8
        Write-Host ".env file created!" -ForegroundColor Green
    }
    
    Write-Host "Installing frontend dependencies..." -ForegroundColor Yellow
    npm install
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Frontend setup complete!" -ForegroundColor Green
    } else {
        Write-Host "Frontend setup failed!" -ForegroundColor Red
    }
    
    Set-Location ..
} else {
    Write-Host "ERROR: frontend directory not found!" -ForegroundColor Red
}

Write-Host ""

# Setup Backend
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Setting up Backend..." -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

if (Test-Path "backend") {
    Set-Location backend
    
    Write-Host "Building backend with Maven..." -ForegroundColor Yellow
    mvn clean install -DskipTests
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Backend setup complete!" -ForegroundColor Green
    } else {
        Write-Host "Backend setup failed!" -ForegroundColor Red
    }
    
    Set-Location ..
} else {
    Write-Host "ERROR: backend directory not found!" -ForegroundColor Red
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To start the application:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Start Backend (in one terminal):" -ForegroundColor Yellow
Write-Host "   cd backend" -ForegroundColor White
Write-Host "   mvn spring-boot:run" -ForegroundColor White
Write-Host ""
Write-Host "2. Start Frontend (in another terminal):" -ForegroundColor Yellow
Write-Host "   cd frontend" -ForegroundColor White
Write-Host "   npm run dev" -ForegroundColor White
Write-Host ""
Write-Host "3. Open browser:" -ForegroundColor Yellow
Write-Host "   http://localhost:3000" -ForegroundColor White
Write-Host ""
Write-Host "Login with any username/password (mock auth)" -ForegroundColor Green
Write-Host ""
