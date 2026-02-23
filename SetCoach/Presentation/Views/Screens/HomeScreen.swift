import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Environment(\.dependencies) private var dependencies
    var refreshTrigger: Int = 0

    @State private var viewModel: HomeViewModel?

    var body: some View {
        Group {
            if let viewModel, let dependencies {
                HomeScreenContent(router: dependencies.router, viewModel: viewModel, refreshTrigger: refreshTrigger)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            guard let dependencies else { return }
            if viewModel == nil {
                let vm = HomeViewModel(loadProgramsUseCase: dependencies.makeLoadProgramsUseCase())
                vm.loadPrograms()
                viewModel = vm
            } else {
                viewModel?.loadPrograms()
            }
        }
        .onChange(of: refreshTrigger) { _, _ in
            viewModel?.loadPrograms()
        }
    }
}

private struct HomeScreenContent: View {
    @Bindable var router: Router
    let viewModel: HomeViewModel
    let refreshTrigger: Int

    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    if let error = viewModel.loadError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(Theme.destructive)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(Theme.destructive.opacity(0.15))
                    }
                    headerSection
                    if viewModel.isEmpty {
                        emptyState
                    } else {
                        programsList(viewModel: viewModel)
                    }
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                routeDestination(for: route, viewModel: viewModel)
            }
        }
    }

    private var headerSection: some View {
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
    }

    private func programsList(viewModel: HomeViewModel) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.programs) { program in
                    ProgramCard(program: program)
                        .onTapGesture {
                            router.push(.programDetail(program))
                        }
                }
            }
            .padding()
            .padding(.bottom, 96)
        }
    }

    private var emptyState: some View {
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
    }

    @ViewBuilder
    private func routeDestination(for route: AppRoute, viewModel: HomeViewModel) -> some View {
        switch route {
        case .programDetail(let program):
            ProgramDetailScreen(program: program, onProgramUpdated: { viewModel.loadPrograms() })
        case .trainingDetail(let program, let trainingDay):
            TrainingDetailScreen(program: program, trainingDay: trainingDay)
        case .exerciseHistory(let exerciseName):
            ExerciseHistoryScreen(exerciseName: exerciseName)
        case .activeWorkout(let program, let trainingDay):
            ActiveWorkoutScreen(program: program, trainingDay: trainingDay)
        default:
            Text("Coming soon")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let schema = Schema([
        ProgramModel.self, TrainingDayModel.self, ExerciseTemplateModel.self,
        WorkoutSessionModel.self, WorkoutExerciseModel.self, ExerciseSetModel.self
    ])
    let container = try! ModelContainer(for: schema, configurations: [config])
    let ctx = ModelContext(container)
    let deps = Dependencies(context: ctx)
    return HomeScreen()
        .environment(\.dependencies, deps)
        .modelContainer(container)
}
