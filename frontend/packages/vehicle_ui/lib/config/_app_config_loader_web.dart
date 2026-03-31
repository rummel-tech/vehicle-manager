import 'dart:js_interop';

extension type _JsConfig._(JSObject _) implements JSObject {
  external JSString? get apiBaseUrl;
  external JSBoolean? get debug;
  external JSString? get basePath;
  external JSString? get version;
}

@JS('appConfig')
external _JsConfig? get _jsAppConfig;

/// Web config loader — reads runtime values from window.appConfig (set in config.js).
({String apiBaseUrl, bool debug, String basePath, String version}) loadConfig() {
  try {
    final js = _jsAppConfig;
    if (js != null) {
      return (
        apiBaseUrl: js.apiBaseUrl?.toDart ?? 'http://localhost:8030',
        debug: js.debug?.toDart ?? false,
        basePath: js.basePath?.toDart ?? '/',
        version: js.version?.toDart ?? '0.1.0',
      );
    }
  } catch (_) {}
  return (
    apiBaseUrl: 'http://localhost:8030',
    debug: false,
    basePath: '/',
    version: '0.1.0',
  );
}
