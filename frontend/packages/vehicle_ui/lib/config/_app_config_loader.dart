/// Default (non-web) config loader — returns development defaults.
({String apiBaseUrl, bool debug, String basePath, String version}) loadConfig() {
  return (
    apiBaseUrl: 'http://localhost:8030',
    debug: true,
    basePath: '/',
    version: '0.1.0',
  );
}
