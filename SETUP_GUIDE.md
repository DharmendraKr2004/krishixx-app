# Krishi Sakhi - Complete Setup Guide

This guide will help you configure the app with your own Firebase, Supabase, and API credentials.

## 🚀 Quick Overview
This Flutter app uses:
- **Firebase** (Authentication, Firestore Database, Analytics, Performance)
- **Supabase** (Primary Database & Authentication)
- **External APIs** (Weather, News, Google Gemini AI)

---

## 📋 Step-by-Step Setup

### 1️⃣ Firebase Setup

#### A. Create a New Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Enter project name (e.g., "krishi-sakhi-yourname")
4. Enable Google Analytics (recommended)
5. Complete the setup

#### B. Add Android App
1. In Firebase Console, click "Add App" → Android
2. **Android Package Name**: `com.yourcompany.krishisakhi` (update later in gradle)
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

#### C. Add iOS App (if building for iOS)
1. Click "Add App" → iOS
2. **Bundle ID**: `com.yourcompany.krishisakhi` (update later in Xcode)
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

#### D. Add Web App (if building for web)
1. Click "Add App" → Web
2. Register app with a nickname
3. Copy the Firebase configuration values
4. Update `lib/backend/firebase/firebase_config.dart` with these values:
   - API Key
   - Auth Domain
   - Project ID
   - Storage Bucket
   - Messaging Sender ID
   - App ID
   - Measurement ID

#### E. Enable Firebase Services
In Firebase Console, enable:
- **Authentication** → Email/Password, Google Sign-In
- **Firestore Database** → Create database (start in test mode)
- **Storage** → Create default bucket
- **Analytics** → Already enabled if you chose it during setup

---

### 2️⃣ Supabase Setup

#### A. Create Supabase Project
1. Go to [Supabase Dashboard](https://app.supabase.com/)
2. Click "New Project"
3. Choose organization (or create one)
4. Enter project name: `krishi-sakhi` or similar
5. Database password: Choose a strong password (save it!)
6. Region: Choose closest to your users
7. Wait for project to initialize (~2 minutes)

#### B. Get Supabase Credentials
1. In your project dashboard, go to **Settings** → **API**
2. Copy:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **Anon/Public Key** (long JWT token)
3. Update in: `lib/backend/supabase/supabase.dart`

#### C. Set Up Database Tables
1. Go to **Table Editor** in Supabase dashboard
2. Create tables as needed by your app (check existing schema in `lib/backend/supabase/database/`)
3. Set up Row Level Security (RLS) policies for data protection

#### D. Configure Authentication
1. Go to **Authentication** → **Providers**
2. Enable Email authentication
3. Configure any social providers (Google, Apple, etc.)
4. Set up email templates if needed

---

### 3️⃣ External API Keys

#### A. Weather API (WeatherAPI.com)
1. Go to [WeatherAPI.com](https://www.weatherapi.com/)
2. Sign up for a free account
3. Get your API key from dashboard
4. Update in: `lib/backend/api_requests/api_calls.dart` (KeralaWeatherAPICall)
   - Replace: `1589f7e554414a26b8e142913242110`

#### B. News API (TheNewsAPI)
1. Go to [TheNewsAPI.com](https://www.thenewsapi.com/)
2. Sign up for a free account
3. Get your API token
4. Update in: `lib/backend/api_requests/api_calls.dart` (NewsAPICall)
   - Replace: `r7l2PLJa2hfmqDWeYBszPo4fVEoP30enJAFX0EGM`

#### C. Google Gemini AI API
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with Google account
3. Click "Create API Key"
4. Copy the API key
5. This is passed as a parameter in the app - you can:
   - Store it in app state
   - Store in Firestore under user settings
   - Use environment variables

---

### 4️⃣ Update Package Names

#### Android Package Name
1. Open `android/app/build.gradle`
2. Change `applicationId "com.mycompany.krishisakhi2"` to your package name
3. Update namespace if needed
4. Sync gradle files

#### iOS Bundle Identifier
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target → General tab
3. Change Bundle Identifier
4. Update in `ios/Runner/Info.plist` if needed

#### App Name
Update app display name in:
- `android/app/src/main/AndroidManifest.xml` (android:label)
- `ios/Runner/Info.plist` (CFBundleDisplayName)
- `pubspec.yaml` (name and description)

---

### 5️⃣ Configuration Files to Update

| File | What to Update |
|------|---------------|
| `lib/backend/supabase/supabase.dart` | Supabase URL and Anon Key |
| `lib/backend/firebase/firebase_config.dart` | Firebase Web config |
| `android/app/google-services.json` | Replace with your file |
| `ios/Runner/GoogleService-Info.plist` | Replace with your file |
| `lib/backend/api_requests/api_calls.dart` | Weather & News API keys |
| `android/app/build.gradle` | Package name/App ID |
| `ios/Runner.xcodeproj/project.pbxproj` | Bundle identifier |

---

### 6️⃣ Install Dependencies

```bash
# Install Flutter dependencies
flutter pub get

# For iOS (on Mac only)
cd ios
pod install
cd ..

# Clean and rebuild
flutter clean
flutter pub get
```

---

### 7️⃣ Test Your Setup

```bash
# Check for issues
flutter doctor

# Run on device/emulator
flutter run
```

#### Verify:
- [ ] App launches successfully
- [ ] Firebase connection works (check debug console)
- [ ] Supabase authentication works
- [ ] Weather data loads
- [ ] News feed loads
- [ ] Gemini AI features work (if API key configured)

---

## 🔒 Security Best Practices

1. **Never commit sensitive keys to Git**
   - Add to `.gitignore`:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`
     - Any files with API keys

2. **Use Environment Variables** (recommended for production)
   - Consider using `flutter_dotenv` package
   - Store API keys in `.env` file
   - Add `.env` to `.gitignore`

3. **Supabase Security**
   - Set up Row Level Security (RLS) policies
   - Never expose service_role key in client code
   - Use anon key only

4. **Firebase Security**
   - Configure Firestore security rules
   - Set up Authentication properly
   - Enable App Check for production

---

## 🆘 Troubleshooting

### Firebase Issues
- **"Default FirebaseApp not initialized"**
  - Ensure `google-services.json` is in correct location
  - Check package name matches

### Supabase Issues
- **"Invalid API key"**
  - Verify URL and anon key are correct
  - Check for extra spaces or quotes

### Build Issues
- **Android build fails**
  - Run `flutter clean && flutter pub get`
  - Check Gradle version compatibility
  
- **iOS build fails**
  - Run `pod install` in ios folder
  - Check CocoaPods version

---

## 📞 Next Steps

1. ✅ Complete all setup steps above
2. ✅ Test the app thoroughly
3. ✅ Set up proper security rules
4. ✅ Customize branding and content
5. ✅ Deploy to your users!

---

## 📝 Important Notes

- **Current Firebase Project**: `eduera-7d152` (NEEDS TO BE REPLACED)
- **Current Supabase Project**: `lubwxsdgfvzpaojowgau` (NEEDS TO BE REPLACED)
- **Current Package**: `com.mycompany.krishisakhi2` (SHOULD BE CHANGED)

After completing this setup, the app will be completely yours with no dependencies on the original developer's accounts!

---

*Last Updated: February 20, 2026*
