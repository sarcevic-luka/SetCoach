import SwiftUI
import SwiftData
import os

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "ActiveWorkout")

struct ActiveWorkoutScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var sessions: [WorkoutSession]
    let program: Program
    let trainingDay: TrainingDay

    @State private var workoutExercises: [WorkoutExercise] = []
    @State private var startTime = Date()
    @State private var elapsedSeconds = 0
    @State private var timer: Timer?
    @State private var bodyWeight: Double = 82.0
    @State private var waistCircumference: Double = 84.0
    @State private var showMetrics = false
    @State private var restTimerEnabled = false
    @State private var restDuration = 90
    @State private var expandedExerciseId: String?

    private var lastSession: WorkoutSession? {
        sessions
            .filter { $0.trainingDayId == trainingDay.id && $0.completed }
            .sorted { $0.date > $1.date }
            .first
    }

    private var completedSets: Int {
        workoutExercises.flatMap(\.sets).filter(\.completed).count
    }

    private var totalSets: Int {
        workoutExercises.flatMap(\.sets).count
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                headerView
                progressBar
                bodyMetricsSection
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(workoutExercises.indices, id: \.self) { index in
                            ActiveExerciseCard(
                                exercise: $workoutExercises[index],
                                isExpanded: expandedExerciseId == workoutExercises[index].id,
                                onToggleExpand: {
                                    expandedExerciseId = expandedExerciseId == workoutExercises[index].id ? nil : workoutExercises[index].id
                                }
                            )
                        }
                    }
                    .padding()
                    .padding(.bottom, 80)
                }
                finishButton
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Theme.foreground)
                }
            }
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(trainingDay.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.foreground)
                    Text(formatElapsedTime())
                        .font(.system(size: 12))
                        .foregroundColor(Theme.muted)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { restTimerEnabled.toggle() }) {
                    Image(systemName: restTimerEnabled ? "timer.circle.fill" : "timer.circle")
                        .foregroundColor(restTimerEnabled ? Theme.primary : Theme.muted)
                }
            }
        }
        .onAppear {
            initializeWorkout()
            startTimer()
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            timer?.invalidate()
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    private var headerView: some View {
        HStack {
            Text("\(completedSets)/\(totalSets) sets")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.muted)
        }
        .padding()
        .background(Theme.card)
    }

    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Theme.secondary)
                    .frame(height: 4)
                Rectangle()
                    .fill(Theme.primary)
                    .frame(width: geometry.size.width * progressPercentage, height: 4)
            }
        }
        .frame(height: 4)
    }

    private var progressPercentage: Double {
        guard totalSets > 0 else { return 0 }
        return Double(completedSets) / Double(totalSets)
    }

    private var bodyMetricsSection: some View {
        VStack(spacing: 0) {
            Button(action: { showMetrics.toggle() }) {
                HStack {
                    Text("Body Metrics")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.foreground)
                    Spacer()
                    Image(systemName: showMetrics ? "chevron.up" : "chevron.down")
                        .foregroundColor(Theme.muted)
                }
                .padding()
            }
            if showMetrics {
                VStack(spacing: 16) {
                    HStack {
                        Text("Body Weight (kg)")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.foreground)
                        Spacer()
                        StepperView(value: $bodyWeight, step: 0.1, minimum: 0)
                    }
                    HStack {
                        Text("Waist (cm)")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.foreground)
                        Spacer()
                        StepperView(value: $waistCircumference, step: 0.5, minimum: 0)
                    }
                }
                .padding()
                .background(Theme.card)
            }
        }
    }

    private var finishButton: some View {
        VStack {
            PrimaryButton("Finish Workout", icon: "checkmark") {
                finishWorkout()
            }
            .padding()
        }
        .background(Theme.background.opacity(0.95))
    }

    private func initializeWorkout() {
        workoutExercises = trainingDay.exercises.map { template in
            let lastExercise = lastSession?.exercises.first { $0.exerciseTemplateId == template.id }
            let sets = (1...template.targetSets).map { setNum in
                let lastSet = lastExercise?.sets.first { $0.setNumber == setNum }
                return ExerciseSet(
                    setNumber: setNum,
                    weight: lastSet?.weight ?? 0,
                    reps: lastSet?.reps ?? template.targetRepsMin,
                    completed: false
                )
            }
            return WorkoutExercise(
                exerciseTemplateId: template.id,
                name: template.name,
                sets: sets,
                notes: template.notes
            )
        }
        if let firstId = workoutExercises.first?.id {
            expandedExerciseId = firstId
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedSeconds += 1
        }
    }

    private func formatElapsedTime() -> String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func finishWorkout() {
        for i in workoutExercises.indices {
            let currentVolume = workoutExercises[i].sets.reduce(0.0) { $0 + ($1.weight * Double($1.reps)) }
            if let lastExercise = lastSession?.exercises.first(where: { $0.exerciseTemplateId == workoutExercises[i].exerciseTemplateId }) {
                let lastVolume = lastExercise.sets.reduce(0.0) { $0 + ($1.weight * Double($1.reps)) }
                if currentVolume > lastVolume {
                    workoutExercises[i].progressDirection = .up
                } else if currentVolume < lastVolume {
                    workoutExercises[i].progressDirection = .down
                } else {
                    workoutExercises[i].progressDirection = .same
                }
            }
        }
        let session = WorkoutSession(
            programId: program.id,
            programName: program.name,
            trainingDayId: trainingDay.id,
            trainingDayName: trainingDay.name,
            date: Date(),
            duration: elapsedSeconds / 60,
            exercises: workoutExercises,
            bodyWeight: bodyWeight,
            waistCircumference: waistCircumference,
            completed: true
        )
        modelContext.insert(session)
        do {
            try modelContext.save()
        } catch {
            logger.error("Failed to save workout session: \(error.localizedDescription)")
        }
        dismiss()
    }
}
