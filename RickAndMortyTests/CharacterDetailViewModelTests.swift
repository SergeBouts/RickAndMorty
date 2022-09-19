import XCTest

@testable import RickAndMorty

/// Disclaimer: The tests here are not meant to be comprehensive; they are a demo of the idea.

class CharacterDetailViewModelTests: XCTestCase {

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

        let sut = CharacterDetailViewModel(
            characterModel: sourceCharacter,
            avatarLoader: { nil }
        )

        // Then:

        XCTAssertEqual(sut.name, sourceCharacter.name)
        XCTAssertEqual(sut.status, "\(sourceCharacter.status)".capitalized)
        XCTAssertEqual(sut.species, sourceCharacter.species)
        XCTAssertEqual(sut.gender, "\(sourceCharacter.gender)".capitalized)
        XCTAssertEqual(sut.currentLocation, sourceCharacter.location.name)
    }

    func testAvatar() async throws {

        // Given:

        let expectedImage = UIImage(systemName: "minus")!

        // When:

        let sut = CharacterDetailViewModel(
            characterModel: sourceCharacter,
            avatarLoader: { expectedImage }
        )

        let avatarThumb0 = await sut.avatar

        // Then:

        XCTAssertNil(avatarThumb0)

        // When:

        await sut.loadAvatar()
        let avatar = await sut.avatar

        // Then:

        XCTAssertEqual(avatar, expectedImage)
    }
}
