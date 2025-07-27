# Blast Caller App - Setup Instructions

## Fix for the Issues Encountered

This document outlines how to properly set up the project to avoid the NDK version and fl_chart compatibility issues.

## Steps to Set Up the Project Locally

1. Create a new Flutter project:
   ```bash
   flutter create --platform=android,ios blast_caller_app
   ```

2. Replace the contents of `pubspec.yaml` with our updated version that uses compatible package versions:
   ```yaml
   name: blast_caller_app
   description: A Flutter application for Blast Caller System
   version: 1.0.0+1

   environment:
     sdk: '>=3.0.0 <4.0.0'

   dependencies:
     flutter:
       sdk: flutter
     cupertino_icons: ^1.0.6
     fl_chart: ^0.63.0
     lottie: ^2.7.0
     shared_preferences: ^2.2.2

   dev_dependencies:
     flutter_test:
       sdk: flutter
     flutter_lints: ^3.0.0

   flutter:
     uses-material-design: true
     assets:
       - assets/images/
       - assets/animations/
   ```

3. Fix the NDK version issue by adding this to `android/app/build.gradle`:
   ```gradle
   android {
       // Other existing config...
       ndkVersion = "27.0.12077973"
   }
   ```

4. Copy all the Dart files from our project to your newly created project:
   - `lib/main.dart`
   - `lib/screens/home_screen.dart`
   - `lib/screens/quick_launch_screen.dart`
   - `lib/screens/call_statistics_screen.dart`
   - `lib/widgets/department_card.dart`
   - `lib/widgets/loading_animation.dart`
   - `lib/models/department.dart`

5. Create the directory structure for assets:
   ```bash
   mkdir -p assets/images
   mkdir -p assets/animations
   ```

6. Run the app:
   ```bash
   flutter pub get
   flutter run
   ```

## Changes Made to Fix the Issues

1. **fl_chart Issue**: Updated the chart implementation to avoid using `MediaQuery.boldTextOverride` by creating a custom pie chart painter.

2. **NDK Version Issue**: Added instructions to set the NDK version in the build.gradle file.

3. **Dependency Updates**: Updated all package versions to their latest compatible versions.

## Project Structure

```
lib/
├── models/
│   └── department.dart
├── screens/
│   ├── home_screen.dart
│   ├── quick_launch_screen.dart
│   └── call_statistics_screen.dart
├── widgets/
│   ├── department_card.dart
│   └── loading_animation.dart
└── main.dart
```

## Troubleshooting

If you encounter any further issues:

1. Make sure Flutter is updated to the latest version:
   ```bash
   flutter upgrade
   ```

2. Clean the project before rebuilding:
   ```bash
   flutter clean
   flutter pub get
   ```

3. Check for platform-specific configuration issues:
   ```bash
   flutter doctor -v
   ```