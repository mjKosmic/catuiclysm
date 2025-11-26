import TermKit

class BackupsWindow: Window {
    private let dismissAction: () -> Void

    init(dismiss: @escaping () -> Void) {
        self.dismissAction = dismiss
        super.init("Backups")
        self.colorScheme = appColorScheme

        fill()

        setupUI()
    }

    private func setupUI() {
        let modalLabel = Label("Modal")
        modalLabel.x = Pos.center()
        modalLabel.y = Pos.center()
        addSubview(modalLabel)

        let dismissButton = Button("Dismiss", clicked: { [weak self] in
            self?.dismissAction()
        })
        dismissButton.x = Pos.center()
        dismissButton.y = Pos.center() + 2
        addSubview(dismissButton)
    }
}
