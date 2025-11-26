import TermKit
import Combine

class SelectedReleaseWindow: Window {
    private let viewModel: SelectedReleaseView.Model
    private let dismissAction: () -> Void
    private var cancellables = Set<AnyCancellable>()

    private var assetListView: ListView!

    init(viewModel: SelectedReleaseView.Model, dismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.dismissAction = dismiss
        super.init(viewModel.release.name)
        self.colorScheme = appColorScheme

        self.x = Pos.center()
        self.y = Pos.center()
        self.width = Dim.sized(60)
        self.height = Dim.sized(20)

        setupUI()
    }

    private func setupUI() {
        // Title
        let titleLabel = Label(viewModel.release.name)
        titleLabel.x = Pos.center()
        titleLabel.y = Pos.at(1)
        addSubview(titleLabel)

        // Asset list
        let assetNames = viewModel.release.assets.map { $0.name }
        assetListView = ListView(items: assetNames)
        assetListView.x = Pos.at(2)
        assetListView.y = Pos.at(3)
        assetListView.width = Dim.fill() - 2
        assetListView.height = Dim.fill() - 5

        assetListView.activate = { [weak self] item in
            guard let self = self else { return false }
            let asset = self.viewModel.release.assets[item]
            Task {
                await self.viewModel.downloadRelease(asset)
            }
            return true
        }
        addSubview(assetListView)

        // Back button
        let backButton = Button("Back", clicked: { [weak self] in
            self?.dismissAction()
            Application.requestStop()
        })
        backButton.x = Pos.center()
        backButton.y = Pos.bottom(of: self) - 2
        addSubview(backButton)
    }
}
