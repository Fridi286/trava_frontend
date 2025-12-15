// Shared configuration for API base URL
// Use --dart-define API_BASE_URL=https://your-backend when building for k8s/web
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

Uri apiUrl(String path) {
  if (path.startsWith('/')) return Uri.parse('$apiBaseUrl$path');
  return Uri.parse('$apiBaseUrl/$path');
}
