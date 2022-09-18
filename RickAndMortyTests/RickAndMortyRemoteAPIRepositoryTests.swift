import XCTest

@testable import RickAndMorty

// Note: The tests here are not meant to be comprehensive; they are a demo of the idea.

class RickAndMortyRemoteAPIRepositoryTests: XCTestCase {

    final class MockRickAndMortyRemoteAPI: RickAndMortyRemoteAPI {

        var fetchCharactersResultProvider: (() async throws -> [CharacterModel])?

        func fetchCharacters(by filter: CharacterFilter?) async throws -> [CharacterModel] {

            try await fetchCharactersResultProvider!()
        }
    }

    let mockRickAndMortyRemoteAPI = MockRickAndMortyRemoteAPI()
    var sut: RickAndMortyRemoteAPIRepository<MockRickAndMortyRemoteAPI>!

    override func setUp() {

        super.setUp()

        sut = RickAndMortyRemoteAPIRepository(remoteAPI: mockRickAndMortyRemoteAPI)
    }

    override func tearDown() {

        super.tearDown()

        sut = nil
    }

    func testFetchesCharacters() async throws {

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

        mockRickAndMortyRemoteAPI.fetchCharactersResultProvider = {
            expectedCharacters
        }

        // When:

        let characters = try await sut.characters()

        // Then:

        XCTAssertEqual(characters, expectedCharacters)
    }

    func testBadDataFailure() async throws {

        // Given:

        mockRickAndMortyRemoteAPI.fetchCharactersResultProvider = {
            throw "Some error"
        }

        // When:

        var testError: Error!
        do {
            _ = try await sut.characters()
        } catch {
            testError = error
        }

        // Then:

        if let error = testError as? RepositoryError, case .rickAndMortyRepoError(let strError) = error, strError as! String == "Some error" {} else {
            XCTFail()
        }
    }
}
