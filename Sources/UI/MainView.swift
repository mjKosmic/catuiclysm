import Combine

enum PresentedRootView {
    case main
    case game
    case backups
    case settings
    case mods
    case soundpacks
}

extension MainView {
    class Model: ObservableObject {
        @Published var presentedRootView: PresentedRootView
        var gameViewModel: GameView.Model
        var settingsViewModel: SettingsView.Model

        init() {
            self.presentedRootView = .main
            self.gameViewModel = GameView.Model()
            self.settingsViewModel = SettingsView.Model()
        }
    }
}

enum MainView {}
