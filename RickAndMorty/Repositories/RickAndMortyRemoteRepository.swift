import Foundation

protocol RickAndMortyRemoteRepository {

    func characters(by filter: CharacterFilter?) async throws -> [CharacterModel]
}

extension RickAndMortyRemoteRepository {

    func characters() async throws -> [CharacterModel] {

        try await characters(by: nil)
    }
}
