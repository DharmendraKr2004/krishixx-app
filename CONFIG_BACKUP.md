# 🔐 Configuration Backup & Notes

## ⚠️ IMPORTANT
**The original Firebase and Supabase configurations have been removed from this project.**

This file documents what was changed and what you need to set up.

---

## 📝 Original Configuration (Friend's Account)

### Firebase Project
- **Project ID**: `eduera-7d152`
- **Project Number**: `228303241113`
- **Package Name**: `com.mycompany.krishisakhi2`

### Supabase Project
- **Project URL**: `https://lubwxsdgfvzpaojowgau.supabase.co`
- ⚠️ **Anon Key**: Removed for security

### API Keys (Friend's - DO NOT USE)
- **Weather API**: `1589f7e554414a26b8e142913242110`
- **News API**: `r7l2PLJa2hfmqDWeYBszPo4fVEoP30enJAFX0EGM`

---

## ✅ What Has Been Changed

### 1. Configuration Files Updated
- ✅ `lib/backend/supabase/supabase.dart` - Placeholders added
- ✅ `lib/backend/firebase/firebase_config.dart` - Placeholders added  
- ✅ `lib/backend/api_requests/api_calls.dart` - Placeholders added

### 2. Files That Need Manual Replacement
- ⚠️ `android/app/google-services.json` - **Replace with your own from Firebase Console**
- ⚠️ `ios/Runner/GoogleService-Info.plist` - **Replace with your own from Firebase Console**

### 3. Template Files Created
- ✅ `android/app/google-services.json.template` - Template for Android
- ✅ `ios/Runner/GoogleService-Info.plist.template` - Template for iOS

---

## 🚀 What You Need To Do

### Step 1: Set Up Firebase
1. Create new Firebase project at https://console.firebase.google.com/
2. Add Android app → Download `google-services.json` → Replace existing file
3. Add iOS app → Download `GoogleService-Info.plist` → Replace existing file
4. Add Web app → Copy config → Update `lib/backend/firebase/firebase_config.dart`

### Step 2: Set Up Supabase
1. Create new Supabase project at https://app.supabase.com/
2. Get Project URL and Anon Key from Settings → API
3. Update `lib/backend/supabase/supabase.dart`

### Step 3: Get API Keys
1. **Weather API**: Sign up at https://www.weatherapi.com/
2. **News API**: Sign up at https://www.thenewsapi.com/
3. **Gemini AI**: Get key at https://makersuite.google.com/app/apikey
4. Update `lib/backend/api_requests/api_calls.dart`

### Step 4: Update Package Name
1. Change package in `android/app/build.gradle`
2. Change bundle ID in Xcode for iOS
3. Update in Firebase console for both platforms

---

## 📋 Quick Checklist

- [ ] Firebase project created
- [ ] Android app added to Firebase
- [ ] iOS app added to Firebase
- [ ] Web app added to Firebase
- [ ] `google-services.json` replaced
- [ ] `GoogleService-Info.plist` replaced
- [ ] `firebase_config.dart` updated
- [ ] Supabase project created
- [ ] Supabase credentials updated
- [ ] Weather API key obtained and added
- [ ] News API key obtained and added
- [ ] Gemini AI key obtained
- [ ] Package name updated (Android)
- [ ] Bundle ID updated (iOS)
- [ ] Database tables created in Supabase
- [ ] Firebase Authentication enabled
- [ ] Firestore database created
- [ ] App tested on device/emulator

---

## 🔒 Security Reminders

1. **NEVER** commit these files to public repositories:
   - `google-services.json`
   - `GoogleService-Info.plist`
   - Any file with real API keys

2. Add to `.gitignore`:
   ```
   android/app/google-services.json
   ios/Runner/GoogleService-Info.plist
   .env
   ```

3. Use environment variables for production

---

## 📚 Additional Resources

- [Firebase Setup Guide](https://firebase.google.com/docs/flutter/setup)
- [Supabase Flutter Guide](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
- [Flutter Build Configuration](https://docs.flutter.dev/deployment)

---

*Configuration detached on: February 20, 2026*
