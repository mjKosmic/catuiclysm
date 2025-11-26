import Combine
import Foundation

extension SettingsView {
    class Model: ObservableObject {

        @Published var settings: LauncherSettings

        var settingsSink: AnyCancellable?

        init(settings: LauncherSettings = .shared) {
            self.settings = settings

            self.settingsSink = settings.objectWillChange.sink { newValue in
                self.objectWillChange.send()
            }
        }
    }
}

enum SettingsView {}
