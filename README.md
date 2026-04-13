<div align="center">

# Smart Finance Tracker

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

> **Final University Project** — A production-ready personal finance management application

Modern Flutter application for tracking income, expenses, budgets, and analyzing financial goals with a clean architecture and persistent local storage.

</div>

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Database](#database)
- [Analytics](#analytics)
- [Budget Management](#budget-management)
- [Settings](#settings)
- [Dependencies](#dependencies)
- [Getting Started](#getting-started)
- [Testing & Verification](#testing--verification)
- [Project Goals](#project-goals)
- [Future Enhancements](#future-enhancements)

---

## Features

### Core Functionality
- **Income Transactions** — Add and track income sources
- **Expense Transactions** — Add and categorize expenses
- **Dashboard** — Real-time balance, income, and expense totals
- **Transaction History** — View all recent transactions at a glance
- **Local Persistence** — Data survives app restarts with Hive database

### Advanced Features
- **Analytics Dashboard** — Visualize spending patterns
- **Budget Goals** — Set and track spending targets by category
- **Dark Mode** — Built-in theme switching
- **Multi-Currency Support** — Switch between currencies
- **Local Notifications** — Get alerts about transactions and budgets
- **Responsive UI** — Beautiful interface for all device sizes

### Architecture & Code Quality
- **Clean MVVM Architecture** — Separation of concerns
- **Provider State Management** — Efficient state handling
- **Repository Pattern** — Data abstraction layer
- **Dependency Injection (GetIt)** — Loose coupling
- **Modern UI/UX** — Professional design with animations

---

## Architecture

The project follows **production-style clean layered architecture**:

```
lib/
├── config/              # App configuration & routes
├── core/                # Core utilities & constants
├── data/                # Data layer (models, repositories)
├── presentation/        # UI layer (screens, widgets, view models)
├── utils/               # Helper functions & extensions
└── main.dart            # Entry point
```

### Architecture Pattern Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Presentation** | MVVM + Provider | UI & state management |
| **Domain** | Repository Pattern | Business logic |
| **Data** | Hive / Shared Preferences | Persistent storage |
| **DI** | GetIt | Service locator |

### Benefits
- **Scalability** — Easy to extend with new features
- **Testability** — Clear separation enables unit testing
- **Maintainability** — Well-organized, self-documenting code
- **Flexibility** — Simple to swap implementations

---

## Database

**Hive NoSQL** provides fast local persistence:

### Stored Data
- Transactions (income & expenses)
- Categories
- Budget goals
- Cached analytics data
- User preferences & settings

### Advantages
- **Offline Support** — Works without internet
- **Fast Local Reads** — No server latency
- **Automatic Persistence** — Data survives app restarts
- **Smooth UX** — Instant dashboard updates

---

## Analytics Module

Visualize your financial habits with interactive charts:

### Charts Included
- **Pie Chart** — Spending breakdown by category
- **Line Chart** — Monthly income vs. expenses trend
- **Bar Chart** — Daily spending activity (weekly view)

### Metrics Calculated
- Net balance overview
- Category spending percentages
- Income vs. expense ratios
- Spending trends over time

---

## Budget Management

Create and manage spending goals for better financial control:

### Features
- **Create Goals** — Set budget targets by category
- **Update Goals** — Adjust goals as needed
- **Delete Goals** — Remove completed goals
- **Progress Tracking** — Visual progress bar (%)
- **Budget Alerts** — Warning when exceeding budget
- **Remaining Balance** — Always know how much you can spend

---

## Settings

Customize the app to your preferences:

| Setting | Options |
|---------|----------|
| **Theme** | Light / Dark mode (persistent) |
| **Currency** | Multiple currency choices |
| **Notifications** | Enable / Disable alerts |
| **Budget Alerts** | Custom threshold settings |
| **Reports** | Weekly summary reports |

---

## Dependencies

```yaml
# State Management & DI
provider: ^6.0.0          # Provider pattern
get_it: ^7.0.0            # Service locator

# Local Database
hive: ^2.0.0              # NoSQL local database
hive_flutter: ^1.0.0      # Flutter integration
shared_preferences: ^2.0.0 # Key-value storage

# UI & Charts
fl_chart: ^0.0.0          # Beautiful charts
flutter_local_notifications: ^0.0.0  # Push notifications

# API & Utilities
dio: ^5.0.0               # HTTP client
intl: ^0.0.0              # Internationalization
```

---

## Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Dart 3.0+
- Android SDK or Xcode (for iOS)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/username/smart-finance-tracker.git
   cd smart-finance-tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup environment (optional)**
   ```bash
   cp .env.example .env
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Build Release
```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

---

## Testing & Verification

### Test Results

| Test | Status | Details |
|------|--------|----------|
| **Static Analysis** | Pass | `flutter analyze` → 0 errors |
| **Unit Tests** | Pass | All tests passed |
| **Widget Tests** | Pass | UI tests verified |
| **Emulator** | Pass | Tested on multiple devices |
| **Startup** | Pass | No initialization issues |
| **Persistence** | Pass | Hive transactions verified |
| **Calculations** | Pass | Transaction totals verified |

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/transaction_persistence_test.dart

# Generate coverage report
flutter test --coverage
```

---

## Project Goals

This application demonstrates mastery of:

- Clean Architecture principles
- Local persistent storage (Hive)
- Production-level UI/UX design
- Data visualization (charts)
- MVVM pattern with Provider
- Real-world mobile development workflows
- State management at scale
- Dependency injection patterns

---

## Future Enhancements

Planned features for version 2.0+:

### Cloud & Sync
- Firebase cloud backup
- Multi-device sync
- Shared account features

### Security
- Biometric authentication
- End-to-end encryption
- Secure PIN lock

### Advanced Analytics
- AI spending insights
- Spending predictions
- Smart recommendations

### Data Export
- PDF report generation
- CSV export functionality
- Email reports

### Social Features
- Family budgets
- Social spending challenges
- Peer recommendations

---

## License

This project is licensed under the **MIT License** — see [LICENSE](LICENSE) file for details.

---

## Author

**Student Project** — Final University Project  
Flutter & Dart Development  

---

<div align="center">

### Show Your Support

If you found this project helpful, consider giving it a **star**!

Made with love using Flutter

</div>
