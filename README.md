# API Pilot

A minimal cross-platform API Testing Platform` built with Flutter.

## Features

- Create and save API requests
- Support for GET, POST, PUT, DELETE, PATCH methods
- Add custom headers and query parameters
- Send JSON request bodies
- View formatted JSON responses
- Dark mode support
- Save request history

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio / VS Code / IntelliJ IDEA

### Installation

1. Clone the repository
```bash
git clone https://github.com/parth-2005/api_pilot.git
```

2. Navigate to the project directory
```bash
cd api_pilot
```

3. Get dependencies
```bash
flutter pub get
```

4. Generate Hive adapters
```bash
flutter packages pub run build_runner build
```

5. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
│
├── main.dart
├── models/
│   └── request_model.dart
├── screens/
│   ├── home_screen.dart
│   ├── request_screen.dart
│   ├── response_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── key_value_editor.dart
│   └── json_pretty_viewer.dart
├── services/
│   ├── api_service.dart
│   ├── local_storage_service.dart
│   └── theme_service.dart
└── utils/
    └── constants.dart
```

## Future Enhancements

- Environment variables support
- Collections to organize requests
- WebSocket support
- Authentication helpers
- Request history with filters
- Response time graphs
- Import/Export functionality

## License

This project is licensed under the MIT License