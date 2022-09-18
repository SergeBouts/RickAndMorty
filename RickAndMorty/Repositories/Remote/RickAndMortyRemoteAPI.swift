import Foundation

protocol RickAndMortyRemoteAPI {

    func fetchCharacters(by filter: CharacterFilter?) async throws -> [CharacterModel]
}

extension RickAndMortyRemoteAPI {

    func fetchCharacters() async throws -> [CharacterModel] {

        try await fetchCharacters(by: nil)
    }
}
