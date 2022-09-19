import XCTest

@testable import RickAndMorty

/// Disclaimer: The tests here are not meant to be comprehensive; they are a demo of the idea.

class CharacterCellViewModelTests: XCTestCase {

    let sourceCharacter = CharacterModel(
        id: 1,
        name: "Rick Sanchez",
        status: .alive,
        species: "Human",
        gender: .male,
        location: CharacterModel.CurrentLocation(
            name: "Earth",
            url: URL(string: "https://rickandmortyapi.com/api/location/20")!
        ),
        image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!,
        episodes: [
            URL(string: "https://rickandmortyapi.com/api/episode/1")!,
            URL(string: "https://rickandmortyapi.com/api/episode/2")!
        ])

    func testTextFields() async throws {

        // When:

        let sut = CharacterCellViewModel(
            characterModel: sourceCharacter,
            avatarThumbLoader: { nil }
        )

        // Then:

        XCTAssertEqual(sut.name, sourceCharacter.name)
        XCTAssertEqual(sut.episodesCount, sourceCharacter.episodes.count)
    }

    func testAvatarThumb() async throws {

        // Given:

        let expectedImage = UIImage(systemName: "plus")!

        // When:

        let sut = CharacterCellViewModel(
            characterModel: sourceCharacter,
            avatarThumbLoader: { expectedImage }
        )

        let avatarThumb0 = await sut.avatarThumb

        // Then:

        XCTAssertNil(avatarThumb0)

        // When:

        await sut.loadAvatarThumb()
        let avatarThumb = await sut.avatarThumb

        // Then:

        XCTAssertEqual(avatarThumb, expectedImage)
    }
}
