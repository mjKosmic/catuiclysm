import Foundation

struct CDDAReleaseMetadata: Decodable {
    let url: URL
    let assetsUrl: URL
    let uploadUrl: URL
    let htmlUrl: URL
    let id: Int64
    let author: GitAuthor
    let nodeId: String
    let tagName: String
    let targetCommitish: String
    let name: String
    let draft: Bool
    let prerelease: Bool
    let createdAt: Date
    let publishedAt: Date
    let assets: [CDDAReleaseAsset]
    let tarballUrl: URL
    let zipballUrl: URL
    let body: String?
}

struct GitAuthor: Decodable {
    let login: String
    let id: Int64
    let nodeId: String
    let avatarUrl: URL
    let gravatarId: String
    let url: URL
    let htmlUrl: URL
    let followersUrl: URL
    let followingUrl: URL
    let gistsUrl: URL
    let starredUrl: URL
    let subscriptionsUrl: URL
    let organizationsUrl: URL
    let reposUrl: URL
    let eventsUrl: URL
    let receivedEventsUrl: URL
    let type: String
    let siteAdmin: Bool
}

struct CDDAReleaseAsset: Decodable {
    let url: URL
    let id: Int64
    let nodeId: String
    let name: String
    let label: String
    let uploader: GitAuthor
    let contentType: String
    let state: String
    let size: Int64
    let downloadCount: Int64
    let createdAt: Date
    let updatedAt: Date
    let browserDownloadUrl: URL
}
