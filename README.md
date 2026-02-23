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

The app uses **Clean Architecture** with **MVVM** in the presentation layer. Folder structure follows Domain → Data → Presentation.

```
┌─────────────────────────────────────────────────────┐
│              Presentation (Views, ViewModels)         │
│  SwiftUI, @Observable, Router/AppRoute               │
├─────────────────────────────────────────────────────┤
│              Domain (Entities, UseCases)             │
│  Framework-agnostic business logic                   │
├─────────────────────────────────────────────────────┤
│              Data (Repositories, Models, Mappers)     │
│  SwiftData persistence, SeedData, ExerciseLibrary    │
├─────────────────────────────────────────────────────┤
│                Apple Frameworks                     │
│  SwiftData, SwiftUI, Charts                          │
└─────────────────────────────────────────────────────┘
```

### Key Technical Highlights

* **Clean Architecture + MVVM** — Domain/Data/Presentation layers; `@Observable` ViewModels in UI layer
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
├── SetCoachApp.swift            # App entry, SwiftData model container
├── ContentView.swift            # Tab bar (Programs / History), Add Program sheet
│
├── App/
│   └── Dependencies.swift      # DI: repositories, use cases, router
│
├── Core/
│   ├── Theme/
│   │   └── Theme.swift         # Colors, semantic styling
│   └── Services/
│       └── IdleTimerService.swift
│
├── Data/                        # Data layer (SwiftData, persistence)
│   ├── DataSources/
│   │   ├── SeedData.swift      # Default programs (seed when empty or add missing)
│   │   └── ExerciseLibrary.swift
│   ├── Mappers/                # Domain ↔ SwiftData model mapping
│   │   ├── ProgramMapper.swift
│   │   ├── TrainingDayMapper.swift
│   │   ├── ExerciseTemplateMapper.swift
│   │   ├── WorkoutSessionMapper.swift
│   │   ├── WorkoutExerciseMapper.swift
│   │   └── ExerciseSetMapper.swift
│   ├── Models/                 # SwiftData @Model types
│   │   ├── ProgramModel.swift
│   │   ├── TrainingDayModel.swift
│   │   ├── ExerciseTemplateModel.swift
│   │   ├── WorkoutSessionModel.swift
│   │   ├── WorkoutExerciseModel.swift
│   │   └── ExerciseSetModel.swift
│   └── Repositories/
│       ├── ProgramRepository.swift
│       └── WorkoutSessionRepository.swift
│
├── Domain/                      # Business logic, framework-agnostic
│   ├── Entities/
│   │   ├── Program.swift
│   │   ├── TrainingDay.swift
│   │   ├── ExerciseTemplate.swift
│   │   ├── ProgramImage.swift
│   │   ├── WorkoutSession.swift
│   │   ├── WorkoutExercise.swift
│   │   └── ExerciseSet.swift
│   ├── RepositoryProtocols/
│   │   ├── ProgramRepositoryProtocol.swift
│   │   └── WorkoutSessionRepositoryProtocol.swift
│   └── UseCases/
│       ├── LoadProgramsUseCase.swift
│       ├── SaveProgramUseCase.swift
│       ├── DeleteProgramUseCase.swift
│       ├── LoadWorkoutSessionsUseCase.swift
│       ├── SaveWorkoutSessionUseCase.swift
│       ├── CreateManualWorkoutSessionUseCase.swift
│       ├── GetLastWorkoutSessionUseCase.swift
│       ├── InitializeWorkoutExercisesUseCase.swift
│       ├── CalculateWorkoutStatsUseCase.swift
│       └── ...
│
├── Navigation/
│   ├── AppRoute.swift          # Navigation destination enum
│   └── Router.swift            # NavigationPath, push/pop
│
└── Presentation/               # UI layer (SwiftUI + @Observable ViewModels)
    ├── ViewModels/
    │   ├── HomeViewModel.swift
    │   ├── HistoryViewModel.swift
    │   ├── AddEditProgramViewModel.swift
    │   ├── TrainingDetailViewModel.swift
    │   ├── ActiveWorkoutViewModel.swift
    │   ├── SessionExerciseCardViewModel.swift
    │   ├── ExerciseHistoryViewModel.swift
    │   ├── BodyMetricsChartViewModel.swift
    │   └── ManualWorkoutEntryViewModel.swift
    └── Views/
        ├── Screens/
        │   ├── HomeScreen.swift
        │   ├── HistoryScreen.swift
        │   ├── ProgramDetailScreen.swift
        │   ├── AddEditProgramScreen.swift
        │   ├── TrainingDetailScreen.swift
        │   ├── ActiveWorkoutScreen.swift
        │   ├── SessionDetailScreen.swift
        │   ├── SessionExerciseCard.swift
        │   ├── ExerciseHistoryScreen.swift
        │   ├── BodyMetricsChartScreen.swift
        │   └── ManualWorkoutEntryScreen.swift
        └── Components/
            ├── ProgramCard.swift
            ├── ProgramImagePicker.swift
            ├── ProgramSelectorSheet.swift
            ├── TrainingDayCard.swift
            ├── TrainingDayEditor.swift
            ├── ExerciseCard.swift
            ├── ExerciseEditor.swift
            ├── ExercisePickerSheet.swift
            ├── ExerciseHistoryCard.swift
            ├── ActiveExerciseCard.swift
            ├── SetRow.swift
            ├── StepperView.swift
            ├── RestTimerOverlay.swift
            ├── SessionCard.swift
            └── ...
```

---

## Getting Started 🚀

### Requirements

* iOS 17.0+
* Xcode 16.0+

### Setup

1. Clone the repository
2. Open `SetCoach.xcodeproj` in Xcode
3. Build and run on a simulator or device

### First Launch

The app seeds default programs (e.g. Push Pull Legs, Upper Lower 4-Day, Beginner Full Body, Strength 5x5, Glute Focus, Fat Loss Conditioning, Powerbuilding) when the database is empty, and adds any missing defaults if you already have data. You can edit or delete them and create your own.

---

## License 📄

This project is for educational purposes. Feel free to explore, learn from, and build upon it.

---

_Built with ☕ and Swift_
