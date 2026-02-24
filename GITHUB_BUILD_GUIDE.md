# GitHub Actions APK Build Guide

This guide will help you build your Flutter app APK using GitHub Actions (free online build service).

## Prerequisites
- A GitHub account (free)
- Git installed on your computer

## Step-by-Step Instructions

### Step 1: Initialize Git Repository (if not already done)
Open PowerShell in your project directory and run:
```powershell
cd 'c:\Users\dharm\OneDrive\Documents\krishiX-krishi-mitra-flutterflow\krishiX-krishi-mitra-flutterflow'
git init
git add .
git commit -m "Initial commit"
```

### Step 2: Create GitHub Repository
1. Go to https://github.com/new
2. Repository name: `krishix-app` (or any name you prefer)
3. Choose "Public" (free unlimited Actions minutes) or "Private" (2000 free minutes/month)
4. Click "Create repository"

### Step 3: Push Your Code to GitHub
Copy and run the commands shown on GitHub after creating the repository. They will look like:
```powershell
git remote add origin https://github.com/YOUR-USERNAME/krishix-app.git
git branch -M main
git push -u origin main
```

### Step 4: Trigger the Build
Option A - Automatic (already configured):
- The build will start automatically when you push code to main branch

Option B - Manual trigger:
1. Go to your repository on GitHub
2. Click "Actions" tab
3. Click "Build Android APK" workflow
4. Click "Run workflow" button
5. Click "Run workflow" again to confirm

### Step 5: Download Your APK
1. Wait for the build to complete (5-15 minutes)
2. When the green checkmark appears, click on the workflow run
3. Scroll down to "Artifacts" section
4. Download "android-apk-files.zip"
5. Extract the ZIP file to find your APK files

## APK Files Explained
The build creates split APKs for different device architectures:
- **app-armeabi-v7a-release.apk** - For older 32-bit ARM devices
- **app-arm64-v8a-release.apk** - For modern 64-bit ARM devices (most common)
- **app-x86_64-release.apk** - For x86 devices (rare)

**Recommendation**: Use `app-arm64-v8a-release.apk` for most Android phones.

## Alternative: Build Universal APK
If you want a single APK that works on all devices (larger file size):

Edit `.github/workflows/build-apk.yml` and change:
```yaml
- name: Build APK
  run: flutter build apk --release --split-per-abi
```
To:
```yaml
- name: Build APK
  run: flutter build apk --release
```

Then commit and push the changes.

## Troubleshooting

### Build Fails
- Check the Actions tab for error logs
- Ensure all dependencies are properly configured
- Verify `pubspec.yaml` and `android/app/build.gradle` are correct

### Need Private Repository
- GitHub provides 2000 free Actions minutes/month for private repos
- This is enough for ~200 APK builds

### Update Flutter Version
Edit `.github/workflows/build-apk.yml` line 22 to change Flutter version:
```yaml
flutter-version: '3.35.3'
```

## Cost
- **Public repositories**: Completely free, unlimited builds
- **Private repositories**: 2000 free minutes/month (plenty for most projects)

## Next Steps
1. Follow steps above to push your code to GitHub
2. Wait for automatic build or trigger manually
3. Download your APK from the Actions artifacts
4. Install on your Android device

## Security Note
Make sure sensitive files like API keys are either:
- Added to `.gitignore`
- Stored as GitHub Secrets (for production apps)

Your app is ready to be built online! 🚀
