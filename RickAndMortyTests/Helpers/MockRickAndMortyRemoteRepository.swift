import Foundation
@testable import RickAndMorty
import UIKit

final class MockRickAndMortyRemoteRepository: RickAndMortyRemoteRepository {

    var charactersProvider: ((CharacterFilter?) async throws -> [CharacterModel])?
    var avatarImageProvider: ((URL) async throws -> UIImage)?
    var avatarImageThumbProvider: ((URL) async throws -> UIImage)?


    func characters(by filter: CharacterFilter?) async throws -> [CharacterModel] {

        try await charactersProvider!(filter)
    }

    func avatarImage(at url: URL) async throws -> UIImage {

        try await avatarImageProvider!(url)
    }

    func avatarImageThumb(at url: URL) async throws -> UIImage {

        try await avatarImageThumbProvider!(url)
    }
}
