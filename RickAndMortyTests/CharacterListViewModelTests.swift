import XCTest

@testable import RickAndMorty

/// Disclaimer: The tests here are not meant to be comprehensive; they are a demo of the idea.

class CharacterListViewModelTests: XCTestCase {

    var mockRepo: MockRickAndMortyRemoteRepository!
    var sut: CharacterListViewModel!

    override func setUp() {

        super.setUp()

        mockRepo = MockRickAndMortyRemoteRepository()

        sut = CharacterListViewModel(
            rickAndMortyRemoteRepository: mockRepo,
            cellViewForCharacter: { character in

                let viewModel = CharacterCellViewModel(characterModel: character, avatarThumbLoader: {

                    try? await self.mockRepo.avatarImageThumb(at: character.image)
                })
                return CharacterCellView(viewModel: viewModel)
            },
            detailViewForCharacter: { character in

                let viewModel = CharacterDetailViewModel(characterModel: character, avatarLoader: {

                    try? await self.mockRepo.avatarImage(at: character.image)
                })

                return CharacterDetailView(viewModel: viewModel)
            }
        )
    }

    override func tearDown() {

        super.tearDown()

        sut = nil
        mockRepo = nil
    }

    func testLoads() async throws {

        // Given:

        let expectedCharacters: [CharacterModel] = [
            CharacterModel(
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
        ]

        mockRepo.charactersProvider = { _ in
            expectedCharacters
        }

        // When:

        await sut.load()
        let characters = await sut.characters

        // Then:

        XCTAssertEqual(characters, expectedCharacters)
    }

    func testLoadsFails() async throws {

        // Given:

        let expectedErrorStr = "Something went wrong (not really)"

        mockRepo.charactersProvider = { _ in
            throw expectedErrorStr
        }

        // When:

        await sut.load()
        let error = await sut.error

        // Then:

        let errStr = try XCTUnwrap(error as? String)
        XCTAssertEqual(errStr, expectedErrorStr)
    }
}
