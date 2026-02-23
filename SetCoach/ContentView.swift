import SwiftUI
import SwiftData

enum Tab {
    case programs
    case history
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var dependencies: Dependencies?
    @State private var selectedTab: Tab = .programs
    @State private var showAddProgram = false
    @State private var programsListRefreshTrigger = 0

    var body: some View {
        Group {
            if let dependencies {
                mainContent(dependencies: dependencies)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .environment(\.dependencies, dependencies)
        .onAppear {
            if dependencies == nil {
                dependencies = Dependencies(context: modelContext)
            }
        }
    }

    private func mainContent(dependencies: Dependencies) -> some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case .programs:
                    HomeScreen(refreshTrigger: programsListRefreshTrigger)
                case .history:
                    HistoryScreen()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            tabBar
        }
        .sheet(isPresented: $showAddProgram, onDismiss: {
            programsListRefreshTrigger += 1
        }) {
            AddEditProgramScreen(editProgram: nil)
        }
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            TabButton(
                icon: "dumbbell.fill",
                title: "Programs",
                isSelected: selectedTab == .programs
            ) {
                selectedTab = .programs
            }
            Spacer()
            Button(action: { showAddProgram = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Theme.primaryForeground)
                    .frame(width: 60, height: 60)
                    .background(Theme.primary)
                    .clipShape(Circle())
                    .shadow(color: Theme.primary.opacity(0.4), radius: 8, y: 4)
            }
            .offset(y: -20)
            Spacer()
            TabButton(
                icon: "clock.fill",
                title: "History",
                isSelected: selectedTab == .history
            ) {
                selectedTab = .history
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(Theme.card.shadow(color: .black.opacity(0.1), radius: 10, y: -2))
    }
}


private struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(isSelected ? Theme.primary : Theme.muted)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [ProgramModel.self, TrainingDayModel.self, ExerciseTemplateModel.self, WorkoutSessionModel.self, WorkoutExerciseModel.self, ExerciseSetModel.self], inMemory: true)
}
