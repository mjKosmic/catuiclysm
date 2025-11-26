import TermKit
import Combine

class GameWindow: Window {
    private let viewModel: GameView.Model
    private let dismissAction: () -> Void
    private var cancellables = Set<AnyCancellable>()

    // UI Components
    private var releaseListView: ListView!
    private var refreshButton: Button!
    private var backButton: Button!
    private var statusLabel: Label!

    init(viewModel: GameView.Model, dismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.dismissAction = dismiss
        super.init("Game")
        self.colorScheme = appColorScheme

        fill()

        setupUI()
        bindViewModel()

        // Trigger initial fetch
        Task {
            await viewModel.fetchReleases()
        }
    }

    private func setupUI() {
        // Title
        let titleLabel = Label("Game")
        titleLabel.x = Pos.center()
        titleLabel.y = Pos.at(1)
        addSubview(titleLabel)

        // Status label
        statusLabel = Label("Ready")
        statusLabel.x = Pos.at(2)
        statusLabel.y = Pos.at(3)
        addSubview(statusLabel)

        // Buttons on the left
        refreshButton = Button("Refresh Releases", clicked: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.viewModel.fetchReleases()
            }
        })
        refreshButton.x = Pos.at(2)
        refreshButton.y = Pos.at(5)
        addSubview(refreshButton)

        backButton = Button("Back", clicked: { [weak self] in
            self?.dismissAction()
        })
        backButton.x = Pos.at(2)
        backButton.y = Pos.at(7)
        addSubview(backButton)

        // Release list on the right
        releaseListView = ListView(items: [])
        releaseListView.x = Pos.at(25)
        releaseListView.y = Pos.at(5)
        releaseListView.width = Dim.sized(50)
        releaseListView.height = Dim.fill() - 2
        releaseListView.activate = { [weak self] item in
            guard let self = self else { return false }
            let release = self.viewModel.releases[item]
            self.viewModel.selectedRelease = release
            return true
        }
        addSubview(releaseListView)
    }

    private func bindViewModel() {
        // Update list when releases change
        viewModel.$releases
            .sink { [weak self] releases in
                self?.updateReleasesList(releases)
            }
            .store(in: &cancellables)

        // Update status when refreshing
        viewModel.$refreshing
            .sink { [weak self] isRefreshing in
                guard let self = self else { return }
                self.refreshButton.enabled = !isRefreshing
                self.statusLabel.text = isRefreshing ? "Refreshing..." : "Ready"
                self.setNeedsDisplay()
            }
            .store(in: &cancellables)

        // Show selected release window
        viewModel.$selectedRelease
            .sink { [weak self] release in
                guard let self = self else { return }
                if let release = release {
                    self.showSelectedRelease(release)
                }
            }
            .store(in: &cancellables)
    }

    private func updateReleasesList(_ releases: [CDDAReleaseMetadata]) {
        let releaseNames = releases.map { $0.name }
        releaseListView.items = releaseNames
        releaseListView.setNeedsDisplay()
    }

    private func showSelectedRelease(_ release: CDDAReleaseMetadata) {
        let selectedWindow = SelectedReleaseWindow(
            viewModel: SelectedReleaseView.Model(release: release),
            dismiss: { [weak self] in
                self?.viewModel.selectedRelease = nil
            }
        )

        // Show as a modal dialog
        Application.present(top: selectedWindow)
    }
}
