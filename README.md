# 🌾 Krishi Sakhi - Agricultural Assistant App

A comprehensive Flutter application for farmers providing AI-powered crop assistance, weather updates, agricultural news, and farming tools.

---

## ⚠️ IMPORTANT: SETUP REQUIRED

**This project has been detached from the original developer's configuration.**

Before running, you MUST:
1. ✅ Set up your own Firebase project
2. ✅ Set up your own Supabase project  
3. ✅ Get your own API keys (Weather, News, Gemini)
4. ✅ Replace configuration files

**👉 START HERE: [QUICKSTART.md](QUICKSTART.md)** (30-45 min setup)

---

## 📚 Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - Fast setup checklist (start here!)
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed configuration guide
- **[CONFIG_BACKUP.md](CONFIG_BACKUP.md)** - What was changed & why

---

## ✨ Features

- 🤖 **AI Assistant**: Gemini-powered chatbot for farming questions
- 🌡️ **Weather Updates**: Real-time weather for Kerala region
- 📰 **Agricultural News**: Latest farming news and updates
- 📊 **Krishi Khata**: Farm accounting and record keeping
- 🌱 **Crop Disease Detection**: AI-powered image analysis
- 📅 **Farmer Calendar**: Agricultural activity planning
- 👥 **Farmers Connect**: Community and social features
- 📚 **Knowledge Base**: Farming tips and resources
- 🏛️ **Government Schemes**: Info on agricultural programs

---

## 🛠️ Tech Stack

- **Framework**: Flutter (Stable release)
- **Backend**: Firebase + Supabase
- **AI**: Google Gemini API
- **APIs**: WeatherAPI, TheNewsAPI
- **State Management**: Provider
- **Authentication**: Supabase Auth + Firebase Auth

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- Dart SDK
- Android Studio / Xcode
- Firebase account
- Supabase account

### Quick Setup

1. **Clone & Install**
   ```bash
   git clone <your-repo>
   cd krishiX-krishi-mitra-flutterflow/krishiX-krishi-mitra-flutterflow
   flutter pub get
   ```

2. **Configure Services** (see [QUICKSTART.md](QUICKSTART.md))
   - Set up Firebase
   - Set up Supabase
   - Get API keys
   - Replace config files

3. **Run**
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── auth/                     # Authentication logic
├── backend/                  # Backend services
│   ├── firebase/            # Firebase configuration
│   ├── supabase/            # Supabase configuration
│   └── api_requests/        # External API calls
├── ai_pages/                # AI-powered features
├── pages/                   # App screens
├── components/              # Reusable widgets
├── flutter_flow/           # FlutterFlow utilities
└── custom_code/            # Custom widgets

FlutterFlow projects are built to run on the Flutter _stable_ release.
