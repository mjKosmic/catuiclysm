#if canImport(FoundationNetworking)
import FoundationNetworking
#else
import Foundation
#endif

class CDDADownloadManager: NSObject, DownloadManager {
    typealias MetaData = CDDAReleaseMetadata
    typealias ReleaseAsset = CDDAReleaseAsset
    
    static let shared = CDDADownloadManager()
    
    func fetchReleaseMetaData() async -> [CDDAReleaseMetadata] {
        let request = URLRequest(url: .cddaReleasesURL)
        if let (data, response) = try? await URLSession.shared.data(for: request) {
            let decoder = Utils.jsonDecoder
            if let releases = try? decoder.decode([CDDAReleaseMetadata].self, from: data) {
                return releases
            }
            return []
        }
        return []
    }
    
    func downloadRelease(_ release: CDDAReleaseAsset, to destination: URL) async {
        if let (url, response) = try? await URLSession.shared.download(from: release.browserDownloadUrl) {
            let fileManager = FileManager()
            guard fileManager.fileExists(atPath: url.path) else {
                print("file doesn't exist")
                return
            }
            guard !fileManager.fileExists(atPath: destination.path) else {
                print("destination doesn't exist")
                return
            }
            do {
                try fileManager.moveItem(at: url, to: destination)
            } catch {
                print("Error moving download: \(error.localizedDescription)")
            }
        }
    }
}
