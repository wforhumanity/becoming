# Becoming - Tiny Life Experiments

Becoming is an app designed to help users live more intentionally by creating, tracking, and reflecting on tiny life experiments. These experiments are based on the PACT framework (Purposeful, Actionable, Continuous, Trackable) and encourage a mindset of curiosity over perfection.

## 🌱 App Concept

Becoming is an alternative to traditional to-do lists, focusing on identity-building, reflection, and personal growth through light-touch, structured experimentation.

### Core Goals

- Encourage **intentional experimentation**
- Replace rigid goals with **tiny pacts**
- Foster **personal insight and identity evolution**
- Make self-improvement feel **calm, curious, and non-judgmental**

## 🧠 PACT Framework

PACT stands for:
- **Purposeful:** Aligned with personal interests and values
- **Actionable:** Specific actions within your control
- **Continuous:** Repeatable, light, low-stakes
- **Trackable:** Binary tracking (yes/no)

### Steps to Run an Experiment:
1. **Observation:** What am I curious about?
2. **Question:** What if I tried ___?
3. **Hypothesis:** I think doing ___ might lead to ___.
4. **PACT:** I will [action] for [duration].
5. **Reflection:** What did I learn?

## 🚀 Features

- **Create Pacts:** Design experiments using the PACT framework
- **Track Progress:** Simple yes/no daily tracking
- **Reflect:** Capture learnings and insights at the end of experiments
- **AI Suggestions:** Get AI-powered ideas for new experiments
- **Analytics:** View patterns and insights from past experiments

## 🛠️ Technical Architecture

### API-First Approach

The app follows an API-first, testing-second, code-third approach:

1. **Service Interfaces:** Define clear contracts for all functionality
2. **Data Models:** Implement core data structures
3. **Mock Services:** Create test implementations
4. **Tests:** Verify functionality with unit and integration tests
5. **Service Implementations:** Implement actual services
6. **UI Components:** Build the user interface

### Tech Stack

- **Framework:** Flutter
- **State Management:** Riverpod
- **Authentication:** Firebase Auth with Apple Sign-In
- **Cloud Storage:** Cloud Firestore
- **Local Storage:** SharedPreferences
- **AI Integration:** OpenAI API
- **Testing:** Flutter Test

### Project Structure

```
lib/
├── main.dart
├── components/
│   └── pact_card.dart
├── models/
│   ├── pact_model.dart
│   └── user_model.dart
├── providers/
│   ├── ai_providers.dart
│   ├── pact_providers.dart
│   └── service_providers.dart
├── screens/
│   ├── ai_suggestion_screen.dart
│   ├── create_pact_screen.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── onboarding_screen.dart
│   ├── profile_screen.dart
│   ├── reflection_screen.dart
│   └── tracker_screen.dart
├── services/
│   ├── ai_service.dart
│   ├── ai_service_interface.dart
│   ├── auth_service_interface.dart
│   ├── firebase_auth_service.dart
│   ├── firestore_storage_service.dart
│   ├── mock_ai_service.dart
│   ├── mock_auth_service.dart
│   ├── mock_pact_service.dart
│   ├── mock_storage_service.dart
│   ├── pact_service.dart
│   ├── pact_service_interface.dart
│   ├── storage_service.dart
│   └── storage_service_interface.dart
└── utils/
```

## 🧪 Testing

The app includes comprehensive tests:
- **Model Tests:** Verify Pact model functionality
- **Service Tests:** Verify service implementations
- **Provider Tests:** Verify state management

## 🚀 Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Set up Firebase:
   - Create a new Firebase project
   - Add iOS and Android apps to the project
   - Download and add the configuration files
   - Enable Authentication (Email/Password and Apple Sign-In)
   - Create a Firestore database
4. Add your OpenAI API key in `lib/providers/service_providers.dart`
5. Run `flutter run` to start the app

## 🔐 Authentication

The app supports:
- Email/password authentication
- Sign in with Apple
- Anonymous usage (data stored locally)

User data is securely stored in Firestore and synchronized across devices when signed in.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.
