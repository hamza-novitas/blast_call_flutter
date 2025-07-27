# Blast Caller App

A Flutter application for the Blast Caller System, designed to facilitate quick call launching and viewing call statistics.

## Features

- **Quick Launch Screen**: Grid view of department tiles for quick call launching
- **Rocket Launch Animation**: Engaging loading animation when initiating a call
- **Call Statistics Screen**: Detailed view of call statistics with pie charts
- **Status Dashboard**: Overview of calls with different statuses

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

## Implementation Details

1. **Home Screen**: Navigation hub with bottom navigation bar to switch between screens
2. **Quick Launch**: Department cards with color coding and status indicators
3. **Loading Animation**: Custom rocket animation when launching a call
4. **Statistics Screen**: Detailed call metrics with pie charts and status summaries

## Dependencies

- flutter: Core Flutter framework
- fl_chart: For pie chart visualization
- lottie: For animations (placeholder for future enhancements)
- shared_preferences: For local data persistence

## How to Use

1. Launch the app
2. Navigate to the Quick Launch screen
3. Select a department to initiate a call
4. View the rocket animation during loading
5. Access detailed call statistics on completion