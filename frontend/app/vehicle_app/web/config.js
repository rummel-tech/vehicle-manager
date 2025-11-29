// Configuration for different deployment environments
window.appConfig = {
  // API base URL - can be overridden via environment variables during build
  // For local development: http://localhost:8030
  // For production with context: https://your-domain.com/vehicle-manager/api
  apiBaseUrl: window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
    ? 'http://localhost:8030'
    : (window.API_BASE_URL || '/api'),

  // Application base path - should match the base href
  // For root deployment: /
  // For context deployment: /vehicle-manager/
  basePath: document.querySelector('base')?.getAttribute('href') || '/',

  // Application version
  version: '0.1.0',

  // Enable debug mode in development
  debug: window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
};

console.log('App Config:', window.appConfig);
