import Foundation
import Combine

class LauncherSettings: ObservableObject, Codable {
    static let shared = load()
    private static var settingsSaveDirectoryURL = URL.homeDirectory.appending(components: ".catuiclysm")
    private static var settingsSaveFileURL = settingsSaveDirectoryURL.appending(components: "settings.json")
    
    @Published var gameDirectory: URL
    
    init(gameDirectory: URL) {
        self.gameDirectory = gameDirectory
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.gameDirectory = try container.decodeIfPresent(URL.self, forKey: .gameDirectory) ?? Constants.defaultGameDirectory
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(gameDirectory, forKey: .gameDirectory)
    }
    
    
    func save() {
        let fileManager: FileManager = .default
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let settingsJsonData = try encoder.encode(self)
            if !fileManager.directoryExistsAtPath(LauncherSettings.settingsSaveDirectoryURL.path()) {
                try fileManager.createDirectory(atPath: LauncherSettings.settingsSaveDirectoryURL.path(), withIntermediateDirectories: true)
            }
            try settingsJsonData.write(to: LauncherSettings.settingsSaveFileURL)
        } catch {
            print("failed to save settings: \(error.localizedDescription)")
        }
    }
    
    static func load() -> LauncherSettings {
        let fileManager: FileManager = .default
        if fileManager.fileExists(atPath: settingsSaveFileURL.path()) {
            if let fileContents = try? String(contentsOfFile: settingsSaveFileURL.path()),
               let settings = try? JSONDecoder().decode(LauncherSettings.self, from: Data(fileContents.utf8)) {
                return settings
            }
        }
        return .defaultSettings
    }
    
}

extension LauncherSettings {
    enum CodingKeys: CodingKey {
        case gameDirectory
    }
}

extension LauncherSettings {
    static var defaultSettings: LauncherSettings {
        return .init(gameDirectory: Constants.defaultGameDirectory)
    }
}
