# Key Tracker

A modern Flutter application for digitally managing office key handovers — replacing paper logs with a clean, fast, and reliable mobile solution.

---

## Overview

Key Tracker solves a common office problem: tracking who has which key, when they took it, and when it's due back. Instead of messy notebooks or spreadsheets, the app provides a real-time dashboard with status tracking, history logs, and overdue alerts.

---

## Features

- **Key Dashboard** — View all office keys with their current status (Available / Taken / Overdue)
- **Live Search** — Filter keys instantly by name, room, or person
- **Key Details** — Full card view with Room, Key ID, Status, and Handover info
- **Take Key** — Record who took a key and set an expected return time
- **Return Key** — Mark a key as returned with one tap
- **Overdue Detection** — Automatically flags keys past their return time
- **History Log** — Complete timeline of all key handovers with taken and returned timestamps
- **Modern Toast Notifications** — Contextual success/error/warning/info feedback

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Riverpod |
| Local Database | SQLite via `sqflite` |
| Fonts | Google Fonts |
| Animations | flutter_animate |
| Date Formatting | intl |

---

## Architecture

Feature-first clean architecture with clear separation of concerns:

```
lib/
├── core/
│   ├── database_helper.dart     # SQLite setup & migrations
│   ├── providers/               # Riverpod providers
│   ├── utils/                   # AppColors, AppToast
│   ├── models/                  # Data models
│   └── theme/                   # App theme
│
└── feature/
    ├── key/
    │   ├── presentation/
    │   │   ├── screen/          # KeysScreen, KeyDetailsScreen
    │   │   └── widget/          # KeyInfoCard, StatusCountCard, InfoRow
    │
    ├── handover/
    │   ├── presentation/
    │   │   ├── screen/          # TakeKeyScreen
    │   │   └── provider/        # TakeKeyProvider
    │
    └── history/
        ├── presentation/
        │   ├── screen/          # HistoryScreen
        │   └── widget/          # HistoryCard
```

---

## Database Schema

**keys** table — stores all registered office keys

| Column | Type | Description |
|---|---|---|
| id | INTEGER PK | Auto-increment |
| key_name | TEXT | Name of the key |
| room_id | TEXT | Associated room |
| status | TEXT | Available / Taken |

**handovers** table — tracks every key borrowing event

| Column | Type | Description |
|---|---|---|
| id | INTEGER PK | Auto-increment |
| key_id | INTEGER FK | References keys.id |
| person_name | TEXT | Who took the key |
| taken_time | TEXT | ISO datetime |
| expected_return_time | TEXT | ISO datetime |
| returned_time | TEXT | ISO datetime (nullable) |

---

## Getting Started

**Prerequisites:** Flutter SDK 3.x, Dart 3.x

```bash
# Clone the repository
git clone https://github.com/abidvai/key_tracker.git
cd key_tracker

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## Key Widgets

| Widget | Location | Purpose |
|---|---|---|
| `KeyInfoCard` | `feature/key/widget/` | Key list item card |
| `StatusCountCard` | `feature/key/widget/` | Available/Taken/Overdue summary |
| `InfoRow` | `feature/key/widget/` | Labeled info row with icon |
| `HistoryCard` | `feature/history/widget/` | Handover history item |
| `AppToast` | `core/utils/` | Modern floating notification |

---

## Author

**Abdullah Al Abid**  
GitHub: [@abidvai](https://github.com/abidvai)
