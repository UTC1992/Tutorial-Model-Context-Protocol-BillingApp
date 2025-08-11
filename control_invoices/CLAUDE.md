# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter invoice control application (`control_invoices`) currently in its initial development stage with the standard Flutter counter app template.

## Development Commands

### Basic Flutter Commands
- `flutter run` - Run the app in development mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (requires macOS)
- `flutter build web` - Build web version
- `flutter test` - Run all tests
- `flutter analyze` - Run static analysis and linting
- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Upgrade dependencies
- `flutter clean` - Clean build artifacts

### Platform-Specific Development
- `flutter run -d chrome` - Run on Chrome browser
- `flutter run -d macos` - Run on macOS desktop
- `flutter run -d windows` - Run on Windows desktop
- `flutter run -d linux` - Run on Linux desktop

## Architecture

### Current Structure
- **`lib/main.dart`** - Entry point with basic Material App setup
- **Standard Flutter project structure** with platform folders (android/, ios/, web/, etc.)
- **Uses Material Design 3** with purple theme as default

### Key Dependencies
- `flutter` - Core Flutter framework
- `cupertino_icons` - iOS-style icons
- `flutter_lints` - Dart/Flutter linting rules
- `http` - HTTP client for API calls
- `image_picker` - Camera and gallery access for invoice photos

### Development Environment
- **Dart SDK**: ^3.6.1
- **Flutter lints**: Enabled via `analysis_options.yaml`
- **Platform support**: Android, iOS, Web, macOS, Windows, Linux

## Testing
- Test files should be placed in the `test/` directory
- Widget tests are configured via `flutter_test` package
- Run `flutter test` to execute all tests

## Build and Deployment
- The app is configured as private (`publish_to: 'none'`)
- Version: 1.0.0+1
- Use `flutter build <platform>` for production builds