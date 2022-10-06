import Foundation
import UIKit

protocol RickAndMortyRemoteAPI {

    func fetchCharacters(by filter: CharacterFilter?, page: Int?) async throws -> CharactersResult?
    func fetchCharacterAvatar(at url: URL) async throws -> UIImage
}

extension RickAndMortyRemoteAPI {

    func fetchCharacters(by filter: CharacterFilter? = nil, page: Int? = nil) async throws -> CharactersResult? {

        try await fetchCharacters(by: filter, page: page)
    }
}
