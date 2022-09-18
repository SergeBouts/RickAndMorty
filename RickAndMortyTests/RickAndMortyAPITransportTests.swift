import XCTest

@testable import RickAndMorty

/// Test different scenarios related to transport/server-failure:
/// Note: The tests here are not meant to be comprehensive; they are a demo of the idea.

class RickAndMortyAPITransportTests: XCTestCase {

    var sut: RickAndMortyAPI!

    let apiURL = URL(string: "https://rickandmortyapi.com/api")!

    override func setUp() {

        super.setUp()

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        sut = RickAndMortyAPI(urlSession: urlSession)
    }

    override func tearDown() {

        super.tearDown()

        sut = nil
    }

    func testNetworkRequest() async throws {

        // Given:

        let expectedCharactersResult = RickAndMortyAPI.Model.CharactersResult(
            info: RickAndMortyAPI.Model.Info.init(
                count: 2,
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
                ),
                RickAndMortyAPI.Model.Character(
                    id: 361,
                    name: "Toxic Rick",
                    status: .dead,
                    species: "Humanoid",
                    type: "Rick's Toxic Side",
                    gender: .male,
                    origin: RickAndMortyAPI.Model.CharacterOrigin(
                        name: "Alien Spa",
                        url: URL(string: "https://rickandmortyapi.com/api/location/64")!
                    ),
                    location: RickAndMortyAPI.Model.CurrentLocation(
                        name: "Earth",
                        url: URL(string: "https://rickandmortyapi.com/api/location/20")!
                    ),
                    image: URL(string: "https://rickandmortyapi.com/api/character/avatar/361.jpeg")!,
                    episode: [
                        URL(string: "https://rickandmortyapi.com/api/episode/27")!
                    ],
                    url: URL(string: "https://rickandmortyapi.com/api/character/361")!,
                    created: "2018-01-10T18:20:41.703Z"
                )
            ]
        )

        let expectedCharactersResultData = try JSONEncoder().encode(expectedCharactersResult)

        MockURLProtocol.requestHandler = { request in

            guard let url = request.url, url == self.apiURL.appendingPathComponent("character")
            else {
                throw "Unexpected request: \(request.url.logable)"
            }

            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedCharactersResultData)
        }

        // When:

        let charactersResult = try await sut.fetchCharacters(.all)

        // Then:

        XCTAssertEqual(charactersResult, expectedCharactersResult)
    }

    func testBadDataFailure() async throws {

        // Given:

        let badCharactersResultData = Data()

        MockURLProtocol.requestHandler = { request in

            guard let url = request.url, url == self.apiURL.appendingPathComponent("character")
            else {
                throw "Unexpected request: \(request.url.logable)"
            }

            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, badCharactersResultData)
        }

        // When:

        var testError: Error!
        do {
            _ = try await sut.fetchCharacters(.all)
        } catch {
            testError = error
        }

        // Then:

        if let error = testError as? RickAndMortyAPI.Error, case .decoding = error {} else {
            XCTFail()
        }
    }
}

