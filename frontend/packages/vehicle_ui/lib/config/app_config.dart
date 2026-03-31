import '_app_config_loader.dart'
    if (dart.library.js_interop) '_app_config_loader_web.dart';

/// Runtime configuration read from window.appConfig (web) or development defaults (non-web).
///
/// On web, config.js sets window.appConfig before Flutter boots, allowing
/// per-environment API URLs without rebuilding the app.
class AppConfig {
  final String apiBaseUrl;
  final bool debug;
  final String basePath;
  final String version;

  AppConfig({
    required this.apiBaseUrl,
    required this.debug,
    required this.basePath,
    required this.version,
  });

  static AppConfig? _instance;

  static AppConfig instance() {
    if (_instance != null) return _instance!;
    final data = loadConfig();
    _instance = AppConfig(
      apiBaseUrl: data.apiBaseUrl,
      debug: data.debug,
      basePath: data.basePath,
      version: data.version,
    );
    return _instance!;
  }

  /// Reset cached instance (useful in tests).
  static void reset() => _instance = null;
}
