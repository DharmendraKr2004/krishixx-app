# Quick Start Script for GitHub APK Build
# Run this script to initialize Git and prepare your project for GitHub

Write-Host "=== KrishiX APK Build Setup ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Initialize Git
Write-Host "Step 1: Initializing Git repository..." -ForegroundColor Yellow
git init
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Git is not installed. Please install Git from https://git-scm.com/" -ForegroundColor Red
    exit 1
}

# Step 2: Configure Git (if not already configured)
$gitUser = git config user.name
if (-not $gitUser) {
    Write-Host ""
    Write-Host "Git is not configured. Please enter your details:" -ForegroundColor Yellow
    $name = Read-Host "Enter your name"
    $email = Read-Host "Enter your email"
    git config user.name "$name"
    git config user.email "$email"
    Write-Host "Git configured successfully!" -ForegroundColor Green
}

# Step 3: Add all files
Write-Host ""
Write-Host "Step 2: Adding files to Git..." -ForegroundColor Yellow
git add .

# Step 4: Create initial commit
Write-Host ""
Write-Host "Step 3: Creating initial commit..." -ForegroundColor Yellow
git commit -m "Initial commit - Flutter app with GitHub Actions APK build"

# Step 5: Instructions
Write-Host ""
Write-Host "=== Setup Complete! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Create a new repository on GitHub: https://github.com/new" -ForegroundColor White
Write-Host "2. Copy the repository URL (e.g., https://github.com/username/repo.git)" -ForegroundColor White
Write-Host "3. Run these commands:" -ForegroundColor White
Write-Host ""
Write-Host '   git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPO.git' -ForegroundColor Yellow
Write-Host '   git branch -M main' -ForegroundColor Yellow
Write-Host '   git push -u origin main' -ForegroundColor Yellow
Write-Host ""
Write-Host "4. Go to GitHub Actions tab to see your APK being built!" -ForegroundColor White
Write-Host "5. Download the APK from the Artifacts section when build completes" -ForegroundColor White
Write-Host ""
Write-Host "For detailed instructions, see: GITHUB_BUILD_GUIDE.md" -ForegroundColor Cyan
Write-Host ""
