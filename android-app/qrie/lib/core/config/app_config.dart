/// Qrie Student App — Environment Configuration
class AppConfig {
  final String environment;
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableDebugLogs;

  /// Whether demo-mode authentication is allowed in this environment.
  /// Strictly defaults to false in staging and production to protect real authentication.
  final bool enableDemoAuth;

  const AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    this.enableDebugLogs = false,
    this.enableDemoAuth = false,
  });

  /// Development environment:
  /// Uses Android emulator alias 10.0.2.2 or localhost.
  factory AppConfig.development({String? customHost, bool? enableDemoAuth}) {
    final host = customHost ?? '10.0.2.2:4000';
    return AppConfig._(
      environment: 'development',
      apiBaseUrl: 'http://$host/api/v1',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 12),
      enableDebugLogs: true,
      enableDemoAuth: enableDemoAuth ??
          const bool.fromEnvironment('ENABLE_DEMO_AUTH', defaultValue: true),
    );
  }

  /// Staging environment:
  factory AppConfig.staging({bool? enableDemoAuth}) => AppConfig._(
        environment: 'staging',
        apiBaseUrl: 'https://staging-api.qrie.ai/api/v1',
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 15),
        enableDebugLogs: true,
        enableDemoAuth: enableDemoAuth ??
            const bool.fromEnvironment('ENABLE_DEMO_AUTH', defaultValue: false),
      );

  /// Production environment:
  factory AppConfig.production({bool? enableDemoAuth}) => AppConfig._(
        environment: 'production',
        apiBaseUrl: 'https://api.qrie.ai/api/v1',
        connectTimeout: const Duration(seconds: 6),
        receiveTimeout: const Duration(seconds: 12),
        enableDebugLogs: false,
        enableDemoAuth: enableDemoAuth ??
            const bool.fromEnvironment('ENABLE_DEMO_AUTH', defaultValue: false),
      );

  static AppConfig _current = AppConfig.development();

  static AppConfig get current => _current;

  static void initialize(AppConfig config) {
    _current = config;
  }
}
