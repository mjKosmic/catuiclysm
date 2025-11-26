#if canImport(FoundationNetworking)
import FoundationNetworking
#else
import Foundation
#endif

extension URL {
    static var cddaReleasesURL: URL {
        return URL(string: "https://api.github.com/repos/CleverRaven/Cataclysm-DDA/releases")!
    }
}

protocol DownloadManager {
    associatedtype MetaData
    associatedtype ReleaseAsset
    func fetchReleaseMetaData() async -> [MetaData]
    func downloadRelease(_ release: ReleaseAsset, to: URL) async
}
