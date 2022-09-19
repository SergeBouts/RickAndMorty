import XCTest

@testable import RickAndMorty

/// Disclaimer: The tests here are not meant to be comprehensive; they are a demo of the idea.

class RickAndMortyAPITests: XCTestCase {

    var sut: RickAndMortyAPI!

    override func setUp() {

        super.setUp()

        sut = RickAndMortyAPI()
    }

    override func tearDown() {

        super.tearDown()

        sut = nil
    }

    func testFetchCharactersByAll() async throws {

        _ = try await TimeoutTask(seconds: 3) {
            try await self.sut.fetchCharacters(.all)
        }
        .result
    }

    func testFetchCharactersByAllWithPage() async throws {

        _ = try await TimeoutTask(seconds: 3) {
            try await self.sut.fetchCharacters(.all, page: 4)
        }
        .result
    }

    func testFetchCharactersByFilterName() async throws {

        _ = try await TimeoutTask(seconds: 3) {
            try await self.sut.fetchCharacters(.filter(.init(name: "Rick")))
        }
        .result
    }

    func testFetchCharactersByFilterNameError() async throws {

        var testError: Error?
        do {
            _ = try await TimeoutTask(seconds: 3) {
                try await self.sut.fetchCharacters(.filter(.init(name: "Bla-bla-bla")))
            }
            .result
        } catch {
            testError = error
        }

        if let testError = testError, case RickAndMortyAPI.Error.client(let httpStatusCode) = testError, httpStatusCode.code == 404 {} else {
            XCTFail()
        }
    }
}
