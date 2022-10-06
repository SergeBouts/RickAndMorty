import Foundation
import UIKit

protocol RickAndMortyRemoteRepository {

    func characters(by filter: CharacterFilter?, page: Int?) async throws -> CharactersResult?
    func avatarImage(at url: URL) async throws -> UIImage
    func avatarImageThumb(at url: URL) async throws -> UIImage
}

extension RickAndMortyRemoteRepository {

    func characters(by filter: CharacterFilter? = nil, page: Int? = nil) async throws -> CharactersResult? {

        try await characters(by: filter, page: page)
    }
}
