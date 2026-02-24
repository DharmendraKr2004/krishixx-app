# 🔍 Configuration Checker Script
# This PowerShell script checks if your configuration is complete
# Run: .\check-setup.ps1

Write-Host "🌾 Krishi Sakhi - Configuration Checker" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

$issues = @()
$warnings = @()
$success = @()

# Check Flutter
Write-Host "Checking Flutter installation..." -ForegroundColor Cyan
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    $success += "✅ Flutter is installed"
} else {
    $issues += "❌ Flutter is not installed or not in PATH"
}

# Check if we're in the right directory
if (Test-Path "pubspec.yaml") {
    $success += "✅ Running in Flutter project directory"
} else {
    $issues += "❌ Not in project root directory (pubspec.yaml not found)"
    Write-Host ""
    Write-Host "❌ Please run this script from the project root directory!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Checking configuration files..." -ForegroundColor Cyan

# Check Supabase configuration
$supabaseFile = "lib\backend\supabase\supabase.dart"
if (Test-Path $supabaseFile) {
    $content = Get-Content $supabaseFile -Raw
    if ($content -match "YOUR_SUPABASE_PROJECT_URL" -or $content -match "YOUR_SUPABASE_ANON_KEY") {
        $issues += "❌ Supabase configuration still has placeholder values"
    } else {
        $success += "✅ Supabase configuration updated"
    }
} else {
    $issues += "❌ Supabase configuration file not found"
}

# Check Firebase Web configuration
$firebaseConfigFile = "lib\backend\firebase\firebase_config.dart"
if (Test-Path $firebaseConfigFile) {
    $content = Get-Content $firebaseConfigFile -Raw
    if ($content -match "YOUR_FIREBASE_API_KEY" -or $content -match "YOUR_PROJECT_ID") {
        $issues += "❌ Firebase Web configuration still has placeholder values"
    } else {
        $success += "✅ Firebase Web configuration updated"
    }
} else {
    $issues += "❌ Firebase configuration file not found"
}

# Check Android google-services.json
$androidFirebaseFile = "android\app\google-services.json"
if (Test-Path $androidFirebaseFile) {
    $content = Get-Content $androidFirebaseFile -Raw
    if ($content -match "YOUR_PROJECT_NUMBER" -or $content -match "YOUR_PROJECT_ID") {
        $issues += "❌ Android google-services.json still has placeholder values"
    } elseif ($content -match "eduera-7d152") {
        $issues += "❌ Android google-services.json still contains original developer's credentials"
    } else {
        $success += "✅ Android google-services.json configured"
    }
} else {
    $issues += "❌ Android google-services.json not found"
}

# Check iOS GoogleService-Info.plist
$iosFirebaseFile = "ios\Runner\GoogleService-Info.plist"
if (Test-Path $iosFirebaseFile) {
    $content = Get-Content $iosFirebaseFile -Raw
    if ($content -match "YOUR_IOS_API_KEY" -or $content -match "YOUR_PROJECT_ID") {
        $warnings += "⚠️  iOS GoogleService-Info.plist still has placeholder values"
    } elseif ($content -match "eduera-7d152") {
        $warnings += "⚠️  iOS GoogleService-Info.plist still contains original developer's credentials"
    } else {
        $success += "✅ iOS GoogleService-Info.plist configured"
    }
} else {
    $warnings += "⚠️  iOS GoogleService-Info.plist not found (OK if not building for iOS)"
}

# Check API keys
$apiCallsFile = "lib\backend\api_requests\api_calls.dart"
if (Test-Path $apiCallsFile) {
    $content = Get-Content $apiCallsFile -Raw
    
    # Check Weather API
    if ($content -match "YOUR_WEATHER_API_KEY") {
        $warnings += "⚠️  Weather API key not configured"
    } else {
        $success += "✅ Weather API key configured"
    }
    
    # Check News API
    if ($content -match "YOUR_NEWS_API_TOKEN") {
        $warnings += "⚠️  News API token not configured"
    } else {
        $success += "✅ News API token configured"
    }
} else {
    $issues += "❌ API calls file not found"
}

# Check dependencies
Write-Host ""
Write-Host "Checking Flutter dependencies..." -ForegroundColor Cyan
if (Test-Path "pubspec.lock") {
    $success += "✅ Dependencies have been resolved (pubspec.lock exists)"
} else {
    $warnings += "⚠️  Dependencies not resolved. Run: flutter pub get"
}

# Print Results
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "RESULTS" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

if ($success.Count -gt 0) {
    Write-Host "✅ SUCCESS ($($success.Count)):" -ForegroundColor Green
    foreach ($item in $success) {
        Write-Host "   $item" -ForegroundColor Green
    }
    Write-Host ""
}

if ($warnings.Count -gt 0) {
    Write-Host "⚠️  WARNINGS ($($warnings.Count)):" -ForegroundColor Yellow
    foreach ($item in $warnings) {
        Write-Host "   $item" -ForegroundColor Yellow
    }
    Write-Host ""
}

if ($issues.Count -gt 0) {
    Write-Host "❌ ISSUES ($($issues.Count)):" -ForegroundColor Red
    foreach ($item in $issues) {
        Write-Host "   $item" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Green

# Final verdict
if ($issues.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host ""
    Write-Host "ALL CHECKS PASSED! Your configuration looks good!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Run: flutter doctor" -ForegroundColor White
    Write-Host "  2. Run: flutter run" -ForegroundColor White
    Write-Host ""
} elseif ($issues.Count -eq 0) {
    Write-Host ""
    Write-Host "Configuration is mostly complete, but there are warnings above." -ForegroundColor Yellow
    Write-Host "   The app might work, but some features may not function properly." -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "Configuration is INCOMPLETE. Please fix the issues above." -ForegroundColor Red
    Write-Host ""
    Write-Host "See QUICKSTART.md or SETUP_GUIDE.md for help" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}
