import Foundation
import Combine

extension SelectedReleaseView {
    class Model: ObservableObject {
        let release: CDDAReleaseMetadata

        init(release: CDDAReleaseMetadata) {
            self.release = release
        }

        func downloadRelease(_ releaseAsset: CDDAReleaseAsset) async {
            await CDDADownloadManager.shared.downloadRelease(releaseAsset, to: URL(string: "file:///Users/mikemello/Desktop/\(releaseAsset.name)")!)
        }
    }
}

enum SelectedReleaseView {}
