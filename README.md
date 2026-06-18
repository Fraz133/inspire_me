# InspireMe — Daily Motivation App

[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D%203.11.0-blue.svg?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![GetX State Management](https://img.shields.io/badge/State--Management-GetX-purple.svg?style=for-the-badge)](https://pub.dev/packages/get)
[![Firebase Integrated](https://img.shields.io/badge/Backend-Firebase-orange.svg?style=for-the-badge&logo=firebase)](https://firebase.google.com)
[![Platform Support](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web-green.svg?style=for-the-badge)](#)

`InspireMe` is a premium, high-fidelity daily motivation application built with Flutter. Designed to serve as a stellar showcase for professional job applications, the app exhibits high-end visual design patterns—featuring **ambient glowing canvases, glassmorphism, fluid micro-interactions, stateful audio feedback, and smooth theme switching**—while demonstrating rigorous engineering principles under the hood.

---

## App Highlights & Technical Features

### Visual & Theme Engine
* **Modern Premium Aesthetics**: Sleek modern typography (via Google Fonts' *Outfit* & *Poppins*) mapped onto deep, harmonious HSL gradients, ambient blurred light pools, and translucent frosted glass containers.
* **Animated Theme Transition**: Toggle between light and dark themes with a customized transition system powered by a dedicated `ThemeExtension` (`AppThemeColors`).
* **Micro-Animations**: Uses `flutter_animate` to drive organic card entries, fade-slides, and glowing shadow transformations dynamically.

### Intelligent Content Stream
* **Pre-fetching Carousel**: Built on a horizontal swiping `PageView` carousel. The controller silently pre-fetches and pools new quotes in the background as the user nears the end of their stream, eliminating loading freezes.
* **Hybrid Data Layer**: Merges daily quotes seamlessly from ZenQuotes REST API and community submissions in Cloud Firestore (50/50 pooling ratio) with robust offline fallback structures.

### Text-to-Speech (TTS) Voice Readout
* **Polished Audio Readout**: Tap the speaker icon to stream stateful voice readout of quote text and authors via `flutter_tts`.
* **State Interruption**: The TTS player automatically interrupts and stops speech if the user swipes away to another card or navigates to a different route.

### Persistent Session Verification
* **14-Day Inactivity Rule**: Automatically keeps user authentication active. If the app remains unopened for 14 consecutive days, the local session expires, securely logging the user out and prompting re-authentication.

### First-Time User Guided Tour
* **Interactive 6-Step Onboarding**: New users are greeted by a glassmorphic tutorial highlighting controls step-by-step with bouncing overlay pointers and animated gesture tutorials.

### Custom Motivational Submissions
* **Community Pool Contribution**: Users can upload quotes and authors via a designated card on their profile.
* **Direct Firestore Sync**: Submissions write directly to Firestore's global `quotes` collection and are immediately eligible for display in other users' feeds.

---

## Clean System Architecture

`InspireMe` is engineered following a modular **Feature-First Architecture** combined with separated Service layers to enforce a clean separation of concerns:

```
lib/
├── app/
│   ├── routes.dart                 # Application routing configurations
│   └── widgets/                    # Shared reusable global widgets (buttons, loaders)
├── config/
│   ├── constants.dart              # Global style tokens, keys, and asset references
│   └── theme/
│       └── app_theme.dart          # Dark/Light configurations & AppThemeColors ThemeExtension
├── data/
│   ├── models/
│   │   └── quote_model.dart        # Immutable quote object serialization mapping
│   └── services/
│       ├── analytics_service.dart  # Firebase Analytics interface
│       ├── auth_service.dart       # User sessions, Google Sign-In, and offline validation
│       ├── firestore_service.dart  # Favorites caching and custom quotes queries
│       ├── sound_service.dart      # Interface for audioplayers chime feedback
│       └── tts_service.dart        # Text-to-speech audio control
└── modules/
    ├── auth/                       # Login and Sign-up screens with controllers
    ├── favorites/                  # Bookmarked quotes grid with offline capabilities
    ├── home/                       # Core swipeable quote interface, guided tour overlay
    └── profile/                    # Account configuration, submissions, & uploaded quotes list
```

---

## State Management Implementation

To satisfy professional scalability and keep widgets lightweight:
* **State Management**: Built entirely with **GetX**, utilizing reactive observables (`.obs`) and the `Obx` widget to completely eliminate standard `setState` performance bottlenecks.
* **Dependency Injection**: Services and controllers are lazily loaded and injected at startup (`Get.put` / `Get.find`), decoupling components and making code highly testable.

---

## Firebase Setup

The application features full production-ready Firebase integration:

1. **Authentication**: Sign in with Email/Password or single-tap Google Sign-In.
2. **Cloud Firestore**: Stores bookmarked quotes under a real-time path `users/{uid}/favorites/{quoteId}` and uploads under `quotes/{quoteId}`.
3. **Analytics**: Captures core metrics (`fetch_quote`, `add_favorite`, `share_quote`) and screen transitions.
4. **Crashlytics**: Automatically monitors runtime stability.

### Firebase Deployment Checklist (To-Do for Production)
* **Firestore Security Rules**: Deploy the following rules to secure user data:
  ```javascript
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /users/{userId}/favorites/{quoteId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      match /quotes/{quoteId} {
        allow read: if true;
        allow write: if request.auth != null;
      }
    }
  }
  ```
* **Fingerprint Registration**: To test Google Sign-In on Android, run:
  ```bash
  ./gradlew signingReport
  ```
  Copy the **SHA-1** key and paste it under project settings in your Firebase Console.

---

## Getting Started & How to Run

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.11.0` recommended)
* Android Studio / Xcode configured with emulators or physical testing devices

### Step 1: Clone the Repository & Fetch Dependencies
```bash
git clone https://github.com/your-username/inspire_me.git
cd inspire_me
flutter pub get
```

### Step 2: Configure Firebase Assets (Preconfigured for Android testing)
* The Android module is pre-supplied with an active `google-services.json` targeting the developer's development DB.
* For iOS / macOS builds:
  1. Install Firebase CLI: `npm install -g firebase-tools`
  2. Run `flutterfire configure` and select your target Firebase project to construct `firebase_options.dart` and native PLIST profiles automatically.

### Step 3: Launch the App
```bash
flutter run
```

---

## Deliverables & Feature Checklist

* [x] **Home Screen Center Quote**: Styled in glassmorphic cards with animated entrance.
* [x] **"Inspire Me" Button**: Tacitly responsive button that plays chime and slides page.
* [x] **Theme Switcher**: Fluid Day/Night theme animation utilizing custom `ThemeExtension`.
* [x] **Local & Remote Favorites**: Interactive heart button saving to Cloud Firestore with real-time updates.
* [x] **Quote Sharing**: Integrated native sheet sharing using the `share_plus` utility.
* [x] **Hero Transition**: Seamless visual transition of favorites icon between home and favorites pages.
* [x] **Interactive Guided Tour**: Beautiful 6-step walkthrough for first-time sessions.
* [x] **Voice-to-Text Speech (TTS)**: Seamless TTS readout with automatic interruption on swipe.
* [x] **Clean Architecture & GetX**: Zero setState, clean dependency injection.
* [x] **Zero Warning Build**: Codebase verified with strict `flutter analyze` lint checks.
