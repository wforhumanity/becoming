
# Becoming: Project Scaffold & AI Service Setup

> *Guide by your cheerful neuro-companion: neuroscientist, AI developer, and Becoming enthusiast*

---

## 🛠 Step 1: Set Up Your Flutter App (Scaffold)

### 💡 What We'll Do:
- Install Flutter
- Create a clean, scalable folder structure
- Prepare for Firebase + AI integration
- Test it runs

---

## 🧠 1. Install Flutter (Your Brainstem)

Flutter is a framework built by Google. It lets you build apps for iOS, Android, web, and desktop — all from one codebase.

### ✅ Install Steps:
- Go to: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
- Follow the instructions for **macOS** (you’ll need this for iOS app development).
- Open **Terminal** and type:

```bash
flutter doctor
```

This checks if everything is set up correctly (Xcode, Android Studio, etc.). Fix any issues it suggests.

---

## 🧠 2. Create the Project (Your Neural Net)

```bash
flutter create becoming
cd becoming
```

This creates the base project. Now we *reshape the cortex* to fit our mental model.

---

## 🧠 3. Set Up a Clean Folder Structure

Delete everything inside `/lib` and recreate it like this:

```plaintext
/lib
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── create_pact_screen.dart
│   ├── tracker_screen.dart
│   ├── reflect_screen.dart
│   └── ai_screen.dart
├── components/
│   └── pact_card.dart
├── models/
│   └── pact_model.dart
├── services/
│   └── ai_service.dart
├── providers/
│   └── pact_provider.dart
├── utils/
│   └── prompt_templates.dart
```

Create these using your code editor (like **VS Code**), or in the terminal:

```bash
mkdir lib/screens lib/components lib/models lib/services lib/providers lib/utils
touch lib/main.dart
```

---

## 🧠 4. Add Required Packages

In your `pubspec.yaml`, under `dependencies`, add:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_hooks: ^0.20.0
  hooks_riverpod: ^2.3.6
  http: ^1.1.0
```

Then run:

```bash
flutter pub get
```

---

## 🧠 5. Build Your Neural Bootstrap: `main.dart`

Here’s a simple version:

```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BecomingApp());
}

class BecomingApp extends StatelessWidget {
  const BecomingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Becoming',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
```

Add placeholder `home_screen.dart`:

```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Becoming")),
      body: const Center(child: Text("Welcome to Becoming")),
    );
  }
}
```

Run it:

```bash
flutter run
```

---

# 🤖 Step 2: Add the AI Service File

Create `ai_service.dart` in `/services`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const _apiKey = 'YOUR_OPENAI_API_KEY';
  static const _url = 'https://api.openai.com/v1/chat/completions';

  Future<String> generateSuggestion(String pastExperimentsSummary) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a helpful assistant that creates self-reflection-based experiments for intentional living.'
          },
          {
            'role': 'user',
            'content': 'Here are my past experiments: $pastExperimentsSummary. What new experiment would you suggest next?'
          },
        ],
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Failed to fetch AI suggestion: ${response.body}');
    }
  }
}
```

---

## ✅ You’ve Now:
- Installed Flutter and set up a cross-platform project
- Created a modular, scalable folder structure
- Designed a basic home screen
- Set up your AI service layer, clean and swappable

---

### 🔁 Next Steps:
1. Create your first **Pact model**
2. Build the **create pact screen**
3. Hook it into AI suggestions
4. Add Firebase or Supabase for tracking & auth
