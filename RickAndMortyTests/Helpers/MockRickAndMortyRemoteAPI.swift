import Foundation
@testable import RickAndMorty
import UIKit

final class MockRickAndMortyRemoteAPI: RickAndMortyRemoteAPI {

    var fetchCharactersResultProvider: (() async throws -> [CharacterModel])?
    var fetchCharacterAvatarProvider: (() async throws -> UIImage)?

    func fetchCharacters(by filter: CharacterFilter?) async throws -> [CharacterModel] {

        try await fetchCharactersResultProvider!()
    }

    func fetchCharacterAvatar(at url: URL) async throws -> UIImage {

        try await fetchCharacterAvatarProvider!()
    }
}
