Becoming - Tiny Life Experiments

Becoming is an app designed to help users live more intentionally by creating, tracking, and reflecting on tiny life experiments. These experiments are based on the PACT framework (Purposeful, Actionable, Continuous, Trackable) and encourage a mindset of curiosity over perfection.
🌱 App Concept

Becoming is an alternative to traditional to-do lists, focusing on identity-building, reflection, and personal growth through light-touch, structured experimentation.
Core Goals

    Encourage intentional experimentation
    Replace rigid goals with tiny pacts
    Foster personal insight and identity evolution
    Make self-improvement feel calm, curious, and non-judgmental

🧠 PACT Framework

PACT stands for:

    Purposeful: Aligned with personal interests and values
    Actionable: Specific actions within your control
    Continuous: Repeatable, light, low-stakes
    Trackable: Binary tracking (yes/no)

Steps to Run an Experiment:

    Observation: What am I curious about?
    Question: What if I tried ___?
    Hypothesis: I think doing ___ might lead to ___.
    PACT: I will [action] for [duration].
    Reflection: What did I learn?

🚀 Features

    Create Pacts: Design experiments using the PACT framework
    Track Progress: Simple yes/no daily tracking
    Reflect: Capture learnings and insights at the end of experiments
    AI Suggestions: Get AI-powered ideas for new experiments
    Analytics: View patterns and insights from past experiments

🛠️ Technical Architecture
API-First Approach

The app follows an API-first, testing-second, code-third approach:

    Service Interfaces: Define clear contracts for all functionality
    Data Models: Implement core data structures
    Mock Services: Create test implementations
    Tests: Verify functionality with unit and integration tests
    Service Implementations: Implement actual services
    UI Components: Build the user interface

Tech Stack

    Framework: Flutter
    State Management: Riverpod
    Local Storage: SharedPreferences
    AI Integration: OpenAI API
    Testing: Flutter Test

Project Structure

lib/
├── main.dart
├── components/
│   └── pact_card.dart
├── models/
│   └── pact_model.dart
├── providers/
│   ├── ai_providers.dart
│   ├── pact_providers.dart
│   └── service_providers.dart
├── screens/
│   ├── ai_suggestion_screen.dart
│   ├── create_pact_screen.dart
│   ├── home_screen.dart
│   ├── reflection_screen.dart
│   └── tracker_screen.dart
├── services/
│   ├── ai_service.dart
│   ├── ai_service_interface.dart
│   ├── mock_ai_service.dart
│   ├── mock_pact_service.dart
│   ├── mock_storage_service.dart
│   ├── pact_service.dart
│   ├── pact_service_interface.dart
│   ├── storage_service.dart
│   └── storage_service_interface.dart
└── utils/

🧪 Testing

The app includes comprehensive tests:

    Model Tests: Verify Pact model functionality
    Service Tests: Verify service implementations
    Provider Tests: Verify state management

🚀 Getting Started

    Clone the repository
    Run flutter pub get to install dependencies
    Add your OpenAI API key in lib/providers/service_providers.dart
    Run flutter run to start the app

📝 License
This project is licensed under the MIT License - see the LICENSE file for details.