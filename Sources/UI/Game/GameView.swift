import Combine

extension GameView {
    class Model: ObservableObject {
        @Published var releases: [CDDAReleaseMetadata]
        @Published var selectedRelease: CDDAReleaseMetadata?
        @Published var refreshing = false

        init() {
            releases = []
        }

        func fetchReleases() async {
            refreshing = true
            self.releases = []
            self.releases = await CDDADownloadManager.shared.fetchReleaseMetaData()
            refreshing = false
        }
    }
}

enum GameView {}
