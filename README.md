# SetCoach

### Your Personal Workout Tracking Companion 💪📊

**SetCoach** is an iOS app that helps you plan programs, track workouts, and monitor your progress over time. Create training splits, log sets and reps, and watch your strength and body metrics evolve — all in a clean, focused interface.

---

## What Does It Do? 🤔

SetCoach turns your iPhone into a workout companion:

1. **Plan Your Programs** — Create programs with training days and exercises. Use the built-in library of 200+ exercises or add custom ones.
2. **Track Your Workouts** — Start a session, log sets with weight and reps, and optionally record body weight and waist circumference.
3. **Rest Timer** — Built-in rest timer with configurable durations (30s–4min) to keep you on track between sets.
4. **Review History** — Browse past sessions, see exercise-specific trends, and track volume and max weight over time.
5. **Body Metrics** — Track body weight and waist circumference trends with charts.

Think of it as a minimal, no-fuss workout log that stays out of your way and keeps your data organized.

---

## Features ✨

| Feature | Description |
|--------|-------------|
| 📋 **Program Management** | Create and edit programs with training days and exercises |
| 📚 **Exercise Library** | 200+ exercises across 6 muscle groups (Chest, Back, Legs, Shoulders, Arms, Core) |
| 🔍 **Searchable Picker** | Browse by category or search by name when adding exercises |
| 🏋️ **Active Workout** | Log sets, weight, and reps with optional difficulty rating |
| ⏱️ **Rest Timer** | Configurable rest periods between sets |
| 📈 **Exercise History** | Volume and max-weight charts per exercise |
| 📊 **Body Metrics** | Track weight and waist trends with line charts |
| 📅 **Session History** | Full history of completed workouts |
| 🌐 **Localization** | English and Croatian (en, hr) |
| 🎨 **Dark Theme** | Consistent dark UI with semantic colors |

---

## Tech Talk 🛠️

SetCoach is built with modern Swift and SwiftUI, following best practices for iOS 17+ development.

### Architecture

```
┌─────────────────────────────────────────────────────┐
│                      Views                           │
│  (SwiftUI, declarative UI, minimal state)            │
├─────────────────────────────────────────────────────┤
│                   ViewModels                         │
│  (@Observable, @MainActor, business logic)           │
├─────────────────────────────────────────────────────┤
│              Services & Utilities                    │
│  (IdleTimerService, SeedData, Theme)                 │
├─────────────────────────────────────────────────────┤
│                Apple Frameworks                     │
│  (SwiftData, SwiftUI, Charts)                       │
└─────────────────────────────────────────────────────┘
```

### Key Technical Highlights

* **MVVM Architecture** — Clean separation with `@Observable` ViewModels
* **Swift Concurrency** — Async/await, `@MainActor` for ViewModels
* **Protocol-Oriented Services** — `IdleTimerManaging` for framework isolation
* **Dependency Injection** — Dependencies passed explicitly, no singletons in Views
* **SwiftData** — Modern persistence for programs, sessions, and exercises
* **Charts** — Volume, max-weight, and body metrics visualizations
* **String Catalogs** — Localization via `Localizable.xcstrings`
* **Zero Force Unwraps** — Safe optional handling throughout

### Frameworks & Technologies Used

| Technology | Purpose |
|------------|---------|
| **SwiftUI** | Declarative UI |
| **SwiftData** | Persistence (Programs, TrainingDays, Sessions, Exercises) |
| **Charts** | Volume, max-weight, and body metrics charts |
| **os.log** | Structured logging |

### Project Structure

```
SetCoach/
├── SetCoachApp.swift           # App entry, model container
├── ContentView.swift           # Tab navigation, Programs / History
├── Navigation/
│   └── AppRoute.swift         # Route enum for navigation
├── Models/
│   ├── Program.swift          # Training program
│   ├── TrainingDay.swift     # Day within a program
│   ├── ExerciseTemplate.swift # Exercise definition
│   ├── WorkoutSession.swift   # Completed workout
│   ├── WorkoutExercise.swift  # Exercise instance in session
│   └── ExerciseSet.swift      # Set (weight, reps)
├── Data/
│   └── ExerciseLibrary.swift  # 200 exercises by muscle group
├── Screens/
│   ├── HomeScreen.swift
│   ├── HomeViewModel.swift
│   ├── ProgramDetailScreen.swift
│   ├── TrainingDetailScreen.swift
│   ├── TrainingDetailViewModel.swift
│   ├── ActiveWorkoutScreen.swift
│   ├── ActiveWorkoutViewModel.swift
│   ├── AddEditProgramScreen.swift
│   ├── AddEditProgramViewModel.swift
│   ├── HistoryScreen.swift
│   ├── HistoryViewModel.swift
│   ├── SessionDetailScreen.swift
│   ├── ExerciseHistoryScreen.swift
│   ├── ExerciseHistoryViewModel.swift
│   ├── BodyMetricsChartScreen.swift
│   └── BodyMetricsChartViewModel.swift
├── Components/
│   ├── ProgramCard.swift
│   ├── TrainingDayCard.swift
│   ├── ExerciseCard.swift
│   ├── ActiveExerciseCard.swift
│   ├── ExerciseEditor.swift
│   ├── ExercisePickerSheet.swift
│   ├── SessionCard.swift
│   ├── ExerciseHistoryCard.swift
│   ├── SetRow.swift
│   ├── RestTimerOverlay.swift
│   └── ...
├── Services/
│   └── IdleTimerService.swift # Screen wake lock (framework isolation)
├── Utilities/
│   ├── Theme.swift            # Colors, corner radius
│   └── SeedData.swift         # Sample programs on first launch
└── Localizable.xcstrings       # en, hr
```

---

## Getting Started 🚀

### Requirements

* iOS 17.0+
* Xcode 15.0+

### Setup

1. Clone the repository
2. Open `SetCoach.xcodeproj` in Xcode
3. Build and run on a simulator or device

### First Launch

The app seeds sample programs (Push Pull Legs, Full Body) on first launch if the database is empty. You can edit or delete them and create your own.

---

## License 📄

This project is for educational purposes. Feel free to explore, learn from, and build upon it.

---

_Built with ☕ and Swift_
