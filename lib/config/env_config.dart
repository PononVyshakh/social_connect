// lib/config/env_config.dart

enum Environment { dev, staging, production }

class EnvConfig {
  static const Environment _environment = Environment.production;

  static Environment get environment => _environment;

  static bool get isDev => _environment == Environment.dev;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;

  // API configurations
  static const String apiBaseUrl = '';
  static const String firebaseProjectId = '';
  static const String firebaseApiKey = '';

  // Feature flags
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
  static const bool enableLogging = !isProduction;
}
