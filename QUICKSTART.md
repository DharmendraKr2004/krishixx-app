# 🚀 Quick Start Checklist

## ⚡ Setup Your Own Krishi Sakhi App in 10 Steps

This project has been **detached from the original developer's accounts**. Follow these steps to connect it to YOUR own services.

---

## ✅ Quick Checklist

### 1️⃣ Firebase Setup (Required)
- [ ] **1.1** Go to [Firebase Console](https://console.firebase.google.com/)
- [ ] **1.2** Create new project (name it anything you like)
- [ ] **1.3** Add Android app:
  - Package name: `com.yourcompany.krishisakhi` (or your choice)
  - Download `google-services.json`
  - Replace file at: `android/app/google-services.json`
- [ ] **1.4** Add iOS app:
  - Bundle ID: `com.yourcompany.krishisakhi`
  - Download `GoogleService-Info.plist`
  - Replace file at: `ios/Runner/GoogleService-Info.plist`
- [ ] **1.5** Add Web app:
  - Copy all Firebase config values
  - Update: `lib/backend/firebase/firebase_config.dart`

### 2️⃣ Supabase Setup (Required)
- [ ] **2.1** Go to [Supabase](https://app.supabase.com/)
- [ ] **2.2** Create new project
- [ ] **2.3** Go to Settings → API
- [ ] **2.4** Copy Project URL and Anon Key
- [ ] **2.5** Update: `lib/backend/supabase/supabase.dart`

### 3️⃣ API Keys (Required for Features)
- [ ] **3.1** Weather API:
  - Sign up at [WeatherAPI.com](https://www.weatherapi.com/)
  - Get free API key
  - Update in: `lib/backend/api_requests/api_calls.dart` (line ~19)
  
- [ ] **3.2** News API:
  - Sign up at [TheNewsAPI](https://www.thenewsapi.com/)
  - Get free API token
  - Update in: `lib/backend/api_requests/api_calls.dart` (line ~38)
  
- [ ] **3.3** Gemini AI (Optional but recommended):
  - Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
  - Create API key
  - Store it (you'll pass it to the app)

### 4️⃣ Package Name Update
- [ ] **4.1** Android: Update `applicationId` in `android/app/build.gradle`
- [ ] **4.2** iOS: Update Bundle Identifier in Xcode
- [ ] **4.3** Make sure it matches what you set in Firebase

### 5️⃣ Flutter Setup
```bash
# Run these commands
flutter clean
flutter pub get

# For iOS (Mac only)
cd ios
pod install
cd ..
```
- [ ] **5.1** Run `flutter clean`
- [ ] **5.2** Run `flutter pub get`
- [ ] **5.3** iOS: Run `pod install` in ios folder

### 6️⃣ Firebase Backend Setup
In Firebase Console:
- [ ] **6.1** Authentication → Enable Email/Password
- [ ] **6.2** Firestore Database → Create database (test mode)
- [ ] **6.3** Storage → Create default bucket

### 7️⃣ Supabase Database Setup
In Supabase Dashboard:
- [ ] **7.1** Check Table Editor for existing tables
- [ ] **7.2** Set up any required tables for your data
- [ ] **7.3** Authentication → Enable Email provider

### 8️⃣ Test Installation
```bash
# Check Flutter setup
flutter doctor

# Run app
flutter run
```
- [ ] **8.1** Run `flutter doctor` (fix any issues)
- [ ] **8.2** Connect device/emulator
- [ ] **8.3** Run `flutter run`
- [ ] **8.4** Test app launches without errors

### 9️⃣ Test Features
- [ ] **9.1** Create account / Sign in works
- [ ] **9.2** Weather data loads
- [ ] **9.3** News feed loads
- [ ] **9.4** AI features work (if Gemini key added)
- [ ] **9.5** Data saves to databases

### 🔟 Security & Cleanup
- [ ] **10.1** Verify `.gitignore` includes Firebase config files
- [ ] **10.2** Delete `ORIGINAL_CREDENTIALS_BACKUP.txt` (after you're done)
- [ ] **10.3** Set up Firebase Security Rules (production)
- [ ] **10.4** Set up Supabase RLS policies (production)

---

## 📁 Files You MUST Edit

| Priority | File | What to Update |
|----------|------|---------------|
| 🔴 **HIGH** | `lib/backend/supabase/supabase.dart` | Supabase URL & Key |
| 🔴 **HIGH** | `lib/backend/firebase/firebase_config.dart` | Firebase Web config |
| 🔴 **HIGH** | `android/app/google-services.json` | **REPLACE** entire file |
| 🔴 **HIGH** | `ios/Runner/GoogleService-Info.plist` | **REPLACE** entire file |
| 🟡 **MEDIUM** | `lib/backend/api_requests/api_calls.dart` | Weather & News API keys |
| 🟡 **MEDIUM** | `android/app/build.gradle` | Package name |
| 🟢 **LOW** | App name in manifest files | Branding |

---

## ⚠️ Common Issues

### "Default FirebaseApp not initialized"
→ Check `google-services.json` is in correct location and package name matches

### "Invalid Supabase credentials"
→ Double-check URL and Anon Key have no extra spaces or quotes

### Weather/News not loading
→ Make sure you replaced the API keys in `api_calls.dart`

### Build errors
→ Run: `flutter clean && flutter pub get`

---

## 🎯 You're Done When...

✅ App builds without errors  
✅ You can create an account  
✅ Data saves to YOUR Firebase/Supabase projects  
✅ Weather and news load correctly  
✅ All features work as expected  

---

## 📚 Need Help?

- **Detailed Guide**: See [SETUP_GUIDE.md](SETUP_GUIDE.md)
- **What Changed**: See [CONFIG_BACKUP.md](CONFIG_BACKUP.md)
- **Flutter Issues**: Run `flutter doctor -v`

---

**Time Estimate**: 30-45 minutes for complete setup

*Last Updated: February 20, 2026*
