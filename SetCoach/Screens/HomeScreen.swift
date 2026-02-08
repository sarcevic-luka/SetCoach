import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var programs: [Program]
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("My Programs")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Theme.foreground)
                        Text("Choose a program to start training")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.muted)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Theme.background.opacity(0.95))

                    if programs.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "dumbbell.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Theme.primary)
                            Text("No programs yet")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Theme.foreground)
                            Text("Tap the + button to create your first program")
                                .font(.system(size: 14))
                                .foregroundColor(Theme.muted)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(programs) { program in
                                    ProgramCard(program: program)
                                        .onTapGesture {
                                            navigationPath.append(AppRoute.programDetail(program))
                                        }
                                }
                            }
                            .padding()
                            .padding(.bottom, 96)
                        }
                    }
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                routeDestination(for: route)
            }
        }
        .onAppear {
            SeedData.createSeedPrograms(context: modelContext)
        }
    }

    @ViewBuilder
    private func routeDestination(for route: AppRoute) -> some View {
        switch route {
        case .programDetail(let program):
            ProgramDetailScreen(program: program)
        case .trainingDetail(let program, let trainingDay):
            TrainingDetailScreen(program: program, trainingDay: trainingDay)
        case .exerciseHistory(let exerciseName):
            ExerciseHistoryPlaceholderScreen(exerciseName: exerciseName)
        case .activeWorkout(let program, let trainingDay):
            ActiveWorkoutScreen(program: program, trainingDay: trainingDay)
        default:
            Text("Coming soon")
        }
    }
}

#Preview {
    HomeScreen()
        .modelContainer(for: [Program.self, TrainingDay.self, ExerciseTemplate.self, WorkoutSession.self, WorkoutExercise.self, ExerciseSet.self], inMemory: true)
}
