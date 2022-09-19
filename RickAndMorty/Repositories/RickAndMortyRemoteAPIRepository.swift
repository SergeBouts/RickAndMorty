import Foundation
import UIKit

// TODO: Implement disk caching

final class RickAndMortyRemoteAPIRepository<T: RickAndMortyRemoteAPI>: RickAndMortyRemoteRepository {

    // MARK: - Properties

    let remoteAPI: T

    let imageCache: ImageCache

    // MARK: - Methods

    init(remoteAPI: T) {

        self.remoteAPI = remoteAPI

        self.imageCache = ImageCache() { url in
            try await remoteAPI.fetchCharacterAvatar(at: url)
        }
    }

    func characters(by filter: CharacterFilter? = nil) async throws -> [CharacterModel] {

        do {
            return try await remoteAPI.fetchCharacters(by: filter)
        } catch {
            throw RepositoryError.rickAndMortyRepoError(error)
        }
    }

    func avatarImage(at url: URL) async throws -> UIImage {

        try await imageCache.get(at: url).image
    }

    func avatarImageThumb(at url: URL) async throws -> UIImage {

        try await imageCache.get(at: url).thumb
    }
}
