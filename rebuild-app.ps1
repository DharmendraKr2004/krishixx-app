# ====================================================
# AUTOMATED FIX SCRIPT - Rebuild with Correct Config
# ====================================================

Write-Host "`n🔧 Starting automated rebuild...`n" -ForegroundColor Cyan

# Navigate to project directory
Set-Location "c:\Users\dharm\OneDrive\Documents\krishiX-krishi-mitra-flutterflow\krishiX-krishi-mitra-flutterflow"

# Step 1: Clean cache
Write-Host "Step 1: Cleaning Flutter cache..." -ForegroundColor Yellow
flutter clean
Write-Host "✅ Cache cleaned`n" -ForegroundColor Green

# Step 2: Get dependencies
Write-Host "Step 2: Getting dependencies..." -ForegroundColor Yellow
flutter pub get
Write-Host "✅ Dependencies updated`n" -ForegroundColor Green

# Step 3: Run app
Write-Host "Step 3: Starting app with correct configuration..." -ForegroundColor Yellow
Write-Host "This will use: pjpaegjjynxnczwpvyqo.supabase.co ✅`n" -ForegroundColor Green

flutter run -d chrome --web-port=55190
