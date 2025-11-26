import TermKit
import Combine

class CatuiclysmApp: Toplevel {
    private let mainViewModel: MainView.Model
    private var cancellables = Set<AnyCancellable>()
    private var currentWindow: Window?

    override init() {
        self.mainViewModel = MainView.Model()
        super.init()
        self.colorScheme = appColorScheme

        fill()

        observeViewModelChanges()
        showMainMenu()
    }

    private func observeViewModelChanges() {
        mainViewModel.$presentedRootView
            .sink { [weak self] newView in
                self?.handleViewChange(to: newView)
            }
            .store(in: &cancellables)
    }

    private func handleViewChange(to view: PresentedRootView) {
        if let window = currentWindow {
            removeSubview(window)
        }

        let newWindow: Window
        switch view {
        case .main:
            newWindow = MainMenuWindow(navigateTo: { [weak self] destination in
                self?.mainViewModel.presentedRootView = destination
            })
        case .game:
            newWindow = GameWindow(
                viewModel: mainViewModel.gameViewModel,
                dismiss: { [weak self] in
                    self?.mainViewModel.presentedRootView = .main
                }
            )
        case .backups:
            newWindow = BackupsWindow(dismiss: { [weak self] in
                self?.mainViewModel.presentedRootView = .main
            })
        case .settings:
            newWindow = SettingsWindow(
                viewModel: mainViewModel.settingsViewModel,
                dismiss: { [weak self] in
                    self?.mainViewModel.presentedRootView = .main
                }
            )
        case .mods:
            newWindow = createStubWindow(title: "Mods")
        case .soundpacks:
            newWindow = createStubWindow(title: "Soundpacks")
        }

        currentWindow = newWindow
        addSubview(newWindow)
    }

    private func createStubWindow(title: String) -> Window {
        let window = Window(title)
        window.colorScheme = appColorScheme
        window.fill()

        let label = Label(title)
        label.x = Pos.center()
        label.y = Pos.at(2)
        window.addSubview(label)

        let backButton = Button("Back", clicked: { [weak self] in
            self?.mainViewModel.presentedRootView = .main
        })
        backButton.x = Pos.center()
        backButton.y = Pos.at(4)
        window.addSubview(backButton)

        return window
    }

    private func showMainMenu() {
        mainViewModel.presentedRootView = .main
    }
}
