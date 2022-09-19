import Foundation
import UIKit

protocol RickAndMortyRemoteAPI {

    func fetchCharacters(by filter: CharacterFilter?) async throws -> [CharacterModel]
    func fetchCharacterAvatar(at url: URL) async throws -> UIImage
}

extension RickAndMortyRemoteAPI {

    func fetchCharacters() async throws -> [CharacterModel] {

        try await fetchCharacters(by: nil)
    }
}
