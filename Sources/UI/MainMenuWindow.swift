import TermKit

class MainMenuWindow: Window {
    private let navigateTo: (PresentedRootView) -> Void

    init(navigateTo: @escaping (PresentedRootView) -> Void) {
        self.navigateTo = navigateTo
        super.init("")
        self.colorScheme = appColorScheme

        fill()

        setupUI()
    }

    private func setupUI() {
        // Title
        let titleLabel = Label("CaTUIclysm")
        titleLabel.x = Pos.center()
        titleLabel.y = Pos.at(2)
        addSubview(titleLabel)

        // Menu frame
        let menuFrame = Frame("Menu")
        menuFrame.x = Pos.center()
        menuFrame.y = Pos.at(5)
        menuFrame.width = Dim.sized(20)
        menuFrame.height = Dim.sized(14)

        // Menu buttons
        let buttons: [(String, PresentedRootView)] = [
            ("Game", .game),
            ("Mods", .mods),
            ("Soundpacks", .soundpacks),
            ("Backups", .backups),
            ("Settings", .settings)
        ]

        var yPos = 1
        for (title, destination) in buttons {
            let button = Button(title, clicked: { [weak self] in
                self?.navigateTo(destination)
            })
            button.x = Pos.at(2)
            button.y = Pos.at(yPos)
            button.width = Dim.sized(16)
            menuFrame.addSubview(button)
            yPos += 2
        }

        // Exit button
        let exitButton = Button("Exit", clicked: {
            Application.shutdown()
        })
        exitButton.x = Pos.at(2)
        exitButton.y = Pos.at(yPos)
        exitButton.width = Dim.sized(16)
        menuFrame.addSubview(exitButton)

        addSubview(menuFrame)
    }
}
