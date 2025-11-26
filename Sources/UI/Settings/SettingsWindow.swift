import TermKit
import Combine
import Foundation

class SettingsWindow: Window {
    private let viewModel: SettingsView.Model
    private let dismissAction: () -> Void
    private var cancellables = Set<AnyCancellable>()

    private var pathDisplayLabel: Label!
    private var pathTextField: TextField!
    private var editButton: Button!
    private var isEditingPath = false

    init(viewModel: SettingsView.Model, dismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.dismissAction = dismiss
        super.init("Settings")
        self.colorScheme = appColorScheme

        fill()

        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        // Title
        let titleLabel = Label("Settings")
        titleLabel.x = Pos.center()
        titleLabel.y = Pos.at(1)
        addSubview(titleLabel)

        // Game directory setting
        let settingYPos = 5

        let settingLabel = Label("Game Install Directory:")
        settingLabel.x = Pos.at(2)
        settingLabel.y = Pos.at(settingYPos)
        addSubview(settingLabel)

        // Display label (shown when not editing)
        pathDisplayLabel = Label(viewModel.settings.gameDirectory.path())
        pathDisplayLabel.x = Pos.at(28)
        pathDisplayLabel.y = Pos.at(settingYPos)
        addSubview(pathDisplayLabel)

        // Edit button (shown when not editing)
        editButton = Button("Edit", clicked: { [weak self] in
            self?.startEditing()
        })
        editButton.x = Pos.at(70)
        editButton.y = Pos.at(settingYPos)
        addSubview(editButton)

        // Text field (created but not added yet - will be added when editing starts)
        pathTextField = TextField(viewModel.settings.gameDirectory.path())
        pathTextField.x = Pos.at(28)
        pathTextField.y = Pos.at(settingYPos)
        pathTextField.width = Dim.sized(50)

        // Back button
        let backButton = Button("Back", clicked: { [weak self] in
            self?.dismissAction()
        })
        backButton.x = Pos.at(2)
        backButton.y = Pos.at(settingYPos + 3)
        addSubview(backButton)
    }

    private func bindViewModel() {
        viewModel.$settings
            .sink { [weak self] settings in
                guard let self = self, !self.isEditingPath else { return }
                self.pathDisplayLabel.text = settings.gameDirectory.path()
                self.setNeedsDisplay()
            }
            .store(in: &cancellables)
    }

    private func startEditing() {
        isEditingPath = true
        removeSubview(pathDisplayLabel)
        removeSubview(editButton)
        pathTextField.text = viewModel.settings.gameDirectory.path()
        addSubview(pathTextField)
        pathTextField.setFocus(self)
        setNeedsDisplay()
    }

    private func stopEditing() {
        isEditingPath = false

        // Save the new path
        if let url = URL(string: pathTextField.text) {
            viewModel.settings.gameDirectory = url
            viewModel.settings.save()
        }

        pathDisplayLabel.text = viewModel.settings.gameDirectory.path()
        removeSubview(pathTextField)
        addSubview(pathDisplayLabel)
        addSubview(editButton)
        setNeedsDisplay()
    }

    override func processKey(event: KeyEvent) -> Bool {
        // Handle Enter key in text field (Control-J is the return key)
        if isEditingPath && event.key == .controlJ {
            stopEditing()
            return true
        }
        // Handle Escape to cancel editing
        if isEditingPath && event.key == .esc {
            isEditingPath = false
            removeSubview(pathTextField)
            addSubview(pathDisplayLabel)
            addSubview(editButton)
            setNeedsDisplay()
            return true
        }
        return super.processKey(event: event)
    }
}
