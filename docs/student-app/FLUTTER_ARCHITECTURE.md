# Qrie Student App — Flutter Implementation Architecture & Blueprint

**Document Reference:** `docs/student-app/FLUTTER_ARCHITECTURE.md`  
**Status:** Approved Specification  
**Author:** Senior Flutter Architect  

---

## 1. Directory Structure (Feature-First Architecture)

```text
android-app/qrie/
├── lib/
│   ├── app/
│   │   ├── app.dart                   # MaterialApp root & theme wiring
│   │   ├── router.dart                # GoRouter route declarations & guards
│   │   └── theme/
│   │       ├── app_colors.dart        # Duolingo color palette tokens
│   │       ├── app_typography.dart    # Nunito display & body text styles
│   │       └── app_theme.dart         # Global ThemeData
│   │
│   ├── core/
│   │   ├── config/
│   │   │   └── app_config.dart        # Environment variables & API Base URLs
│   │   ├── network/
│   │   │   ├── api_client.dart        # Dio client with timeout & retry
│   │   │   ├── auth_interceptor.dart  # JWT injection & 401 refresh handler
│   │   │   └── rfc7807_error.dart     # Problem Details error parser
│   │   ├── storage/
│   │   │   ├── secure_storage.dart    # flutter_secure_storage wrapper
│   │   │   └── local_database.dart    # Drift / SQLite offline database
│   │   ├── sync/
│   │   │   └── outbox_sync_worker.dart# Background retry synchronization
│   │   └── accessibility/
│   │       └── semantics_helpers.dart # Accessible screen reader wrappers
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── duolingo_button.dart    # 3D sticker button with press depth
│   │   │   ├── mascot_avatar.dart      # Custom vector Qrie mascot
│   │   │   ├── duolingo_progress_bar.dart # Rounded shine progress bar
│   │   │   └── top_navigation_bar.dart # Grade pill, streak & gems
│   │   └── models/
│   │       ├── student_profile.dart
│   │       ├── curriculum_models.dart
│   │       └── practice_models.dart
│   │
│   └── features/
│       ├── auth/
│       │   ├── presentation/          # Login & School Code screens
│       │   └── application/           # AuthStateNotifier
│       ├── home/
│       │   ├── presentation/          # Dashboard & resume cards
│       │   └── application/           # HomeFeedCubit
│       ├── curriculum/
│       │   ├── presentation/          # Subject grid & chapter roadmap
│       │   └── application/           # CurriculumNotifier
│       ├── lessons/
│       │   ├── presentation/          # Interactive lesson reader
│       │   └── application/           # LessonProgressManager
│       ├── practice/
│       │   ├── presentation/          # Quiz solver & 9-rung scaffolding
│       │   └── application/           # PracticeSessionController
│       ├── review/
│       │   ├── presentation/          # Spaced retrieval due queue
│       │   └── application/           # ReviewSchedulerNotifier
│       └── profile/
│           ├── presentation/          # Mastery summary & settings
│           └── application/           # ProfileCubit
│
├── test/                              # Unit & Widget tests
│   ├── features/
│   ├── core/
│   └── widgets/
│
├── pubspec.yaml
└── README.md
```

---

## 2. Package Selections & Technical Rationale

| Functionality | Chosen Library | Version | Technical Rationale |
| :--- | :--- | :--- | :--- |
| **State Management** | `flutter_bloc` / `riverpod` | `^8.1.3` / `^2.5.1` | Predictable state machines, testability, zero widget coupling |
| **Routing** | `go_router` | `^14.0.0` | Declarative routing, nested shell routes, deep-link handling |
| **Networking** | `dio` | `^5.4.0` | Custom interceptors, timeout handling, request cancellation |
| **Secure Key Store** | `flutter_secure_storage` | `^9.0.0` | Android Keystore backed encryption for JWT credentials |
| **Offline Database** | `drift` / `sqlite3` | `^2.16.0` | Type-safe SQL, streaming queries, outbox queue persistence |
| **Typography** | `google_fonts` | `^6.2.1` | High-quality Nunito display & geometric sans typography |
| **Math Rendering** | `flutter_math_fork` | `^0.7.2` | Native fast rendering of mathematical expressions and LaTeX |

---

## 3. Environment & Configuration Architecture

```dart
class AppConfig {
  final String environment;
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  const AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  factory AppConfig.development() => const AppConfig._(
    environment: 'development',
    apiBaseUrl: 'http://10.0.2.2:4000/api/v1', // Android emulator host alias
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 8),
  );

  factory AppConfig.staging() => const AppConfig._(
    environment: 'staging',
    apiBaseUrl: 'https://staging-api.qrie.ai/api/v1',
    connectTimeout: Duration(seconds: 6),
    receiveTimeout: Duration(seconds: 10),
  );

  factory AppConfig.production() => const AppConfig._(
    environment: 'production',
    apiBaseUrl: 'https://api.qrie.ai/api/v1',
    connectTimeout: Duration(seconds: 6),
    receiveTimeout: Duration(seconds: 10),
  );
}
```
> [!IMPORTANT]
> Zero service secrets are baked into Flutter compilation binaries. The app only holds the authenticated student's short-lived JWT.
