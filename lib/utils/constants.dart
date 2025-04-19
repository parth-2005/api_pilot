class Constants {
  // App information
  static const String appName = 'API Pilot';
  static const String appVersion = '1.0.0';
  
  // Hive boxes
  static const String requestsBox = 'requests';
  
  // Preferences keys
  static const String darkModeKey = 'isDarkMode';
  
  // Default HTTP methods
  static const List<String> httpMethods = [
    'GET',
    'POST',
    'PUT',
    'DELETE',
    'PATCH',
    'HEAD',
    'OPTIONS'
  ];
  
  // Common content types
  static const Map<String, String> contentTypes = {
    'JSON': 'application/json',
    'XML': 'application/xml',
    'HTML': 'text/html',
    'Text': 'text/plain',
    'Form': 'application/x-www-form-urlencoded',
    'Multipart': 'multipart/form-data',
  };
  
  // Common headers
  static const Map<String, String> commonHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ',
    'User-Agent': 'API-Pilot/1.0',
  };
}