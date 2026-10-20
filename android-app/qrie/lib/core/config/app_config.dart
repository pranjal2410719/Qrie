/// Qrie Student App — Environment Configuration
class AppConfig {
  final String environment;
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableDebugLogs;

  const AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    this.enableDebugLogs = false,
  });

  /// Development environment:
  /// Uses Android emulator alias 10.0.2.2 or localhost.
  factory AppConfig.development({String? customHost}) {
    final host = customHost ?? '10.0.2.2:4000';
    return AppConfig._(
      environment: 'development',
      apiBaseUrl: 'http://$host/api/v1',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 12),
      enableDebugLogs: true,
    );
  }

  /// Staging environment:
  factory AppConfig.staging() => const AppConfig._(
        environment: 'staging',
        apiBaseUrl: 'https://staging-api.qrie.ai/api/v1',
        connectTimeout: Duration(seconds: 8),
        receiveTimeout: Duration(seconds: 15),
        enableDebugLogs: true,
      );

  /// Production environment:
  factory AppConfig.production() => const AppConfig._(
        environment: 'production',
        apiBaseUrl: 'https://api.qrie.ai/api/v1',
        connectTimeout: Duration(seconds: 6),
        receiveTimeout: Duration(seconds: 12),
        enableDebugLogs: false,
      );

  static AppConfig _current = AppConfig.development();

  static AppConfig get current => _current;

  static void initialize(AppConfig config) {
    _current = config;
  }
}
