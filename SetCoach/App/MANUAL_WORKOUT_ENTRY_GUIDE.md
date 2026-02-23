# 📝 Manual Workout Entry - Integration Guide

## ✅ What's Been Added

### **Domain Layer**
- ✅ `CreateManualWorkoutSessionUseCase.swift` - Creates workout session for manual entry

### **Presentation Layer**
- ✅ `ManualWorkoutEntryViewModel.swift` - Manages manual workout entry state
- ✅ `ProgramSelectorSheet.swift` - Select program and training day
- ✅ `ManualWorkoutEntryScreen.swift` - Main entry screen with exercises

### **Dependencies**
- ✅ `Dependencies.swift` - Updated with new use case factory

---

## 📋 How to Integrate into History Screen

### Step 1: Add Navigation State to Your History Screen

```swift
struct HistoryScreen: View {
    @State private var showProgramSelector = false
    @State private var selectedProgram: Program?
    @State private var selectedTrainingDay: TrainingDay?
    
    var body: some View {
        NavigationStack {
            // Your existing history list
            
            // ... existing code ...
        }
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showProgramSelector = true }) {
                    Label("Add Workout", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showProgramSelector) {
            ProgramSelectorSheet { program, trainingDay in
                selectedProgram = program
                selectedTrainingDay = trainingDay
            }
        }
        .sheet(item: Binding(
            get: {
                if let program = selectedProgram, let day = selectedTrainingDay {
                    return WorkoutSelection(program: program, trainingDay: day)
                }
                return nil
            },
            set: { _ in
                selectedProgram = nil
                selectedTrainingDay = nil
            }
        )) { selection in
            NavigationStack {
                ManualWorkoutEntryScreen(
                    program: selection.program,
                    trainingDay: selection.trainingDay
                )
            }
        }
    }
}

// Helper struct for sheet presentation
private struct WorkoutSelection: Identifiable {
    let id = UUID()
    let program: Program
    let trainingDay: TrainingDay
}
```

### Step 2: Simpler Alternative (Using NavigationStack)

If you prefer navigation over sheets:

```swift
struct HistoryScreen: View {
    @State private var showProgramSelector = false
    
    var body: some View {
        NavigationStack {
            List {
                // Your existing history sessions
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        ProgramSelectorSheet { program, trainingDay in
                            // This will be handled by the sheet's dismiss
                        }
                    } label: {
                        Label("Add Workout", systemImage: "plus")
                    }
                }
            }
        }
    }
}
```

---

## 🎨 User Flow

```
History Screen
    ↓
Tap "+" Button
    ↓
ProgramSelectorSheet Opens
    ├─ Shows all programs
    ├─ Groups by program
    └─ Lists training days under each program
    ↓
User Selects Training Day
    ↓
ManualWorkoutEntryScreen Opens
    ├─ Shows workout details (program, day, date)
    ├─ Lists all exercises
    ├─ Allows duration & body metrics entry
    └─ Navigate to each exercise to enter sets
    ↓
User Fills in Exercise Data
    ├─ Weight for each set
    ├─ Reps for each set
    └─ Check completed sets
    ↓
Tap "Save"
    ↓
Workout saved to history
    ↓
Returns to History Screen
```

---

## 🛠️ Component Details

### ProgramSelectorSheet
**Purpose**: Let user choose which workout to log

**Features**:
- Lists all programs with their training days
- Shows program images
- Displays exercise count per training day
- Cancellable
- Returns selected program + training day via callback

**Usage**:
```swift
ProgramSelectorSheet { program, trainingDay in
    // Handle selection
    print("Selected: \(program.name) - \(trainingDay.name)")
}
```

---

### ManualWorkoutEntryScreen
**Purpose**: Main screen for entering workout data

**Features**:
- Date picker (defaults to today)
- Duration input (in minutes)
- List of all exercises
- Navigate to each exercise for detailed entry
- Body metrics (weight, waist) - optional
- Shows progress (completed sets / total sets)
- Save button (disabled until at least one set completed)

**Sections**:
1. **Workout Details**: Program, training day, date, duration
2. **Exercises**: List with navigation to detail entry
3. **Body Metrics**: Optional weight and waist measurements
4. **Progress**: Shows completion status

---

### ManualExerciseEntryView
**Purpose**: Detailed set entry for one exercise

**Features**:
- Exercise name and notes display
- Grid of all sets
- Each set has:
  - Weight input (decimal pad)
  - Reps input (number pad)
  - Completed checkbox
- Auto-saves as you type

---

## 📝 Validation Rules

### Minimum Requirements to Save:
1. ✅ At least **one set must be completed**
   - Weight and reps must be > 0
   - Checkbox must be checked

### Optional Fields:
- Duration
- Body weight
- Waist circumference

---

## 🎯 Example Integration in Existing History Screen

```swift
import SwiftUI

struct HistoryScreen: View {
    @Environment(\.dependencies) private var dependencies
    @State private var completedSessions: [WorkoutSession] = []
    @State private var showAddWorkout = false
    @State private var selectedProgram: Program?
    @State private var selectedTrainingDay: TrainingDay?
    
    var body: some View {
        NavigationStack {
            List {
                if completedSessions.isEmpty {
                    emptyStateView
                } else {
                    ForEach(completedSessions) { session in
                        SessionCard(session: session)
                    }
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddWorkout = true
                    } label: {
                        Label("Add Workout", systemImage: "plus.circle.fill")
                    }
                }
            }
            .onAppear {
                loadSessions()
            }
            // ✅ Add program selector sheet
            .sheet(isPresented: $showAddWorkout) {
                ProgramSelectorSheet { program, trainingDay in
                    selectedProgram = program
                    selectedTrainingDay = trainingDay
                }
            }
            // ✅ Add manual entry sheet
            .sheet(item: Binding(
                get: {
                    guard let p = selectedProgram, let d = selectedTrainingDay else {
                        return nil
                    }
                    return WorkoutSelection(program: p, trainingDay: d)
                },
                set: { _ in
                    selectedProgram = nil
                    selectedTrainingDay = nil
                }
            )) { selection in
                NavigationStack {
                    ManualWorkoutEntryScreen(
                        program: selection.program,
                        trainingDay: selection.trainingDay
                    )
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Workouts Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Complete a workout or add a previous one")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                showAddWorkout = true
            } label: {
                Label("Add Workout", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func loadSessions() {
        guard let dependencies else { return }
        do {
            let useCase = dependencies.makeLoadWorkoutSessionsUseCase()
            let sessions = try useCase.execute(sortByDateDescending: true)
            completedSessions = sessions.filter(\.completed)
        } catch {
            print("Failed to load sessions: \(error)")
        }
    }
}

// Helper struct
private struct WorkoutSelection: Identifiable {
    let id = UUID()
    let program: Program
    let trainingDay: TrainingDay
}
```

---

## 🔧 Customization Options

### Change Duration Format
In `ManualWorkoutEntryViewModel.swift`, modify `parseDuration`:

```swift
// Support hours:minutes format
private func parseDuration(from string: String) -> Int {
    // Custom parsing logic
    // e.g., "1:30" → 90 minutes
}
```

### Add Auto-Fill from Last Workout
Modify `CreateManualWorkoutSessionUseCase`:

```swift
func execute(
    from program: Program,
    trainingDay: TrainingDay,
    date: Date = Date(),
    lastSession: WorkoutSession? = nil  // ← Pass last session
) -> WorkoutSession {
    // Pre-fill with last session data
}
```

### Add Difficulty Rating
Add to `ManualWorkoutEntryScreen`:

```swift
Section("Workout Rating") {
    Picker("Difficulty", selection: $viewModel.difficulty) {
        ForEach(Difficulty.allCases) { diff in
            Text(diff.localizedString).tag(diff)
        }
    }
}
```

---

## 📚 File Structure

```
Domain/
└── UseCases/
    └── CreateManualWorkoutSessionUseCase.swift (✅ New)

Presentation/
├── ViewModels/
│   └── ManualWorkoutEntryViewModel.swift (✅ New)
└── Views/
    └── History/
        ├── ProgramSelectorSheet.swift (✅ New)
        └── ManualWorkoutEntryScreen.swift (✅ New)

Core/
└── DependencyInjection/
    └── Dependencies.swift (✅ Updated)
```

---

## ✅ Testing Checklist

- [ ] Open history screen
- [ ] Tap "+" button
- [ ] See program selector with all programs
- [ ] Select a training day
- [ ] See workout entry screen
- [ ] Enter date (past date)
- [ ] Enter duration
- [ ] Navigate to exercise
- [ ] Fill in set data (weight, reps)
- [ ] Mark sets as completed
- [ ] Add body metrics
- [ ] Save workout
- [ ] Verify it appears in history
- [ ] Verify correct date sorting

---

## 🎉 Summary

You now have a complete manual workout entry feature:
- ✅ Select from existing programs
- ✅ Choose specific training day
- ✅ Set custom date
- ✅ Enter all exercise data
- ✅ Track body metrics
- ✅ Validation ensures data quality
- ✅ Clean Architecture compliant

Just add the "+" button to your History screen and you're done! 🚀
