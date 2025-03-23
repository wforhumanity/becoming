
# 📱 Becoming App – Founding Developer Guide (MVP to iOS Release)

This document outlines the next steps for building and shipping the iOS MVP of **Becoming**, an experimental app designed to help users live more intentionally through tiny, trackable experiments inspired by the PACT framework.

---

## ✅ Current Status

- Flutter scaffold created ✅
- AI service file in place ✅
- "Create Pact" screen implemented ✅
- Prototype site for forHumanity.art is live ✅

---

## 🧭 Next Logical Development Steps

### 1. 📊 Build the Pact Tracker Screen

- Display list of active pacts
- Show start date, duration, and progress indicator (e.g., 3/7 days completed)
- Option to mark today’s pact as completed
- Scaffold file: `tracker_screen.dart`

---

### 2. ✍️ Add Reflection Logging

- New screen where users can write thoughts or notes on their experiments
- Optional AI feedback: summarize user's reflections or suggest insight
- Scaffold file: `reflect_screen.dart`

---

### 3. 🤖 AI Suggestions View

- Create a screen where users can receive a GPT-based suggestion for a new pact
- Fetch response from `ai_service.dart`
- Add loading indicator and success state
- Scaffold file: `ai_screen.dart`

---

### 4. 🔐 Add Firebase Authentication

- Sign in with Apple and email/password
- Store user ID for linking pacts
- Scaffold file: `auth_service.dart`

---

### 5. 📂 Store Pacts in Firebase

- Use Firestore to save:
  - Pact data
  - Reflection entries
  - Completion logs (daily)
- Firebase collections: `pacts`, `reflections`, `users`

---

### 6. 🎨 Build Onboarding Experience

- Add welcome screen explaining Becoming
- Walkthrough of PACT concept
- Ask for name or alias (optional)
- File: `onboarding_screen.dart`

---

### 7. 🍎 Prepare for iOS Submission

- Register Becoming with Apple Developer account
- Setup App Store Connect
- Configure Flutter iOS build via Xcode
- Add icon, splash screen, and short privacy policy

---

## 🚀 Milestone Plan

1. Tracker Screen ✅
2. Reflection Screen ✅
3. AI Suggestion Integration ✅
4. Firebase Auth + Firestore Setup ✅
5. Onboarding ✅
6. TestFlight Build
7. App Store Submission 🎉

---

## 🌍 Reference

- Project: [forhumanity.art](https://forhumanity.art)
- GitHub: [github.com/forhumanity-org](https://github.com/forhumanity-org)
- Primary Repo: [Pierre](https://pierre.co/forhumanity/forhumanity)

---

Built by Human #1.  
Join us in Becoming.
