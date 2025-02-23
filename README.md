# Workout Tracker

A Flutter application for tracking workouts and exercises with real-time synchronization.

## Table of Contents
- [Features](#features)
- [Technical Implementation](#technical-implementation)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Development](#development)

## Features

- Create and manage workout routines
- Track exercises with sets, reps, and weights
- Real-time data synchronization across devices
- Offline support with local data persistence
- Performance monitoring and crash reporting
- Material Design 3 UI implementation

## Technical Implementation

This application is built using:

- **Flutter & Dart** - Cross-platform UI framework
- **Bloc Pattern** - State management using flutter_bloc
- **Supabase** - Backend as a Service for real-time data sync
- **Clean Architecture** - Organized in features with presentation, domain, and data layers
- **Sentry** - Error tracking and performance monitoring
- **Material 3** - Modern UI design system

## Getting Started

### Prerequisites

- Flutter SDK (^3.7.0)
- Android Studio / VS Code
- Android SDK for Android development
- Xcode for iOS development (Mac only)
- Git

### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/workout_tracker.git
cd workout_tracker
```

2. Install dependencies:

```bash
flutter pub get
```

3. Create a `.env` file in the root directory with your Supabase credentials:

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### Development

For a clean build and run (recommended for development):

```bash
flutter clean  
flutter pub cache repair
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

This sequence:
1. Cleans the build directory
2. Repairs the pub cache
3. Gets all dependencies
4. Generates necessary code
5. Runs the application

For more information about Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
