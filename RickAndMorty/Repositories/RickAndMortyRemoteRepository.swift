import Foundation
import UIKit

protocol RickAndMortyRemoteRepository {

    func characters(by filter: CharacterFilter?) async throws -> [CharacterModel]
    func avatarImage(at url: URL) async throws -> UIImage
    func avatarImageThumb(at url: URL) async throws -> UIImage
}

extension RickAndMortyRemoteRepository {

    func characters() async throws -> [CharacterModel] {

        try await characters(by: nil)
    }
}
