import XCTest

@testable import RickAndMorty

// Disclaimer: The tests here are not meant to be comprehensive; they are a demo of the idea.

class RickAndMortyRemoteAPIAdapterTests: XCTestCase {

    var sut: RickAndMortyRemoteAPIAdapter!

    override func setUp() {

        super.setUp()

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        let api = RickAndMortyAPI(urlSession: urlSession)
        sut = RickAndMortyRemoteAPIAdapter(api: api)
    }

    override func tearDown() {

        super.tearDown()

        sut = nil
    }

    func testAdaptsFetchedCharacters() async throws {

        // Given:

        let sourceCharactersResult = RickAndMortyAPI.Model.CharactersResult(
            info: RickAndMortyAPI.Model.Info.init(
                count: 1,
                pages: 1,
                next: nil,
                prev: nil
            ),
            results: [
                RickAndMortyAPI.Model.Character(
                    id: 1,
                    name: "Rick Sanchez",
                    status: .alive,
                    species: "Human",
                    type: "",
                    gender: .male,
                    origin: RickAndMortyAPI.Model.CharacterOrigin(
                        name: "Earth",
                        url: URL(string: "https://rickandmortyapi.com/api/location/1")!
                    ),
                    location: RickAndMortyAPI.Model.CurrentLocation(
                        name: "Earth",
                        url: URL(string: "https://rickandmortyapi.com/api/location/20")!
                    ),
                    image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!,
                    episode: [
                        URL(string: "https://rickandmortyapi.com/api/episode/1")!,
                        URL(string: "https://rickandmortyapi.com/api/episode/2")!
                    ],
                    url: URL(string: "https://rickandmortyapi.com/api/character/1")!,
                    created: "2017-11-04T18:48:46.250Z"
                )
            ]
        )

        let sourceCharactersResultData = try JSONEncoder().encode(sourceCharactersResult)

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

        MockURLProtocol.requestHandler = { request in

            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, sourceCharactersResultData)
        }

        // When:

        let characters = try await sut.fetchCharacters()

        // Then:

        XCTAssertEqual(characters, expectedCharacters)
    }

    func testBadDataFailure() async throws {

        // Given:

        let badCharactersResultData = Data()

        MockURLProtocol.requestHandler = { request in

            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, badCharactersResultData)
        }

        // When:

        var testError: Error!
        do {
            _ = try await sut.fetchCharacters()
        } catch {
            testError = error
        }

        // Then:

        if let error = testError as? RickAndMortyAPI.Error, case .decoding = error {} else {
            XCTFail()
        }
    }
}
