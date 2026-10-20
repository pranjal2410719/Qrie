# Qrie AI — Student Mobile Application

> **Platform:** Android-first (Flutter / Dart)  
> **Target Audience:** Students in NCERT Classes 6–12  
> **Location:** `android-app/qrie/`

---

## Overview

The **Qrie Student Mobile Application** is built with Flutter to deliver a smooth, responsive, 60fps learning experience on low-cost Android hardware and low-bandwidth networks across Indian schools.

---

## Architecture & Integration

1. **Authentication:** Authenticates against the Qrie Backend (`POST /api/v1/auth/session`) and operates strictly within the student's assigned school tenant (`school_id`).
2. **Learning Lifecycle:**
   - Onboarding & baseline assessment.
   - Interactive bite-sized lesson sessions with instant verification.
   - Server-side event synchronization with local SQLite queuing for offline resilience.
3. **Decoupled Intelligence:**
   - The mobile application **never** talks directly to the LAM service or holds privileged LAM JWT keys.
   - All next-activity recommendations flow securely through the Qrie Application Backend and the trusted `lam-relay`.

---

## Development Setup

```bash
cd qrie

# Check Flutter environment
flutter doctor

# Install dependencies
flutter pub get

# Run on connected Android device / emulator
flutter run

# Run tests
flutter test
```
