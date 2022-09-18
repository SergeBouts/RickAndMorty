import Foundation

// TODO: Implement caching

final class RickAndMortyRemoteAPIRepository<T: RickAndMortyRemoteAPI>: RickAndMortyRemoteRepository {

    // MARK: - Properties

    let remoteAPI: T

    // MARK: - Methods

    init(remoteAPI: T) {

        self.remoteAPI = remoteAPI
    }

    func characters(by filter: CharacterFilter? = nil) async throws -> [CharacterModel] {

        do {
            return try await remoteAPI.fetchCharacters(by: filter)
        } catch {
            throw RepositoryError.rickAndMortyRepoError(error)
        }
    }
}
