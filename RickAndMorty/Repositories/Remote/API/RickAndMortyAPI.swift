import Foundation
import os.log
import UIKit

final class RickAndMortyAPI {

    // MARK: - Properties

    let urlSession: URLSession

    // MARK: - Initialization

    init(urlSession: URLSession = .shared) {

        self.urlSession = urlSession
    }

    // MARK: - API

    func fetchCharacters(_ args: Args, page: Int? = nil) async throws -> Model.CharactersResult {

        guard let endpointURL = CharactersEndpoint(args: args, page: page).url
        else {

            throw Error.invalidRequest("Invalid URL for characters endpoint for {args:\(args),page:\(page.logable)}")
        }

        os_log(.info, log: OSLog.default, "Fetching characters for {args:\(args),page:\(page.logable)} @\(endpointURL)...")

        do {
            let data = try await performRequest(at: endpointURL)

            os_log(.info, log: OSLog.default, "Characters for {args:\(args),page:\(page.logable)} fetched successfully")

            do {

                let charactersResult = try JSONDecoder().decode(Model.CharactersResult.self, from: data)

                return charactersResult
            } catch {

                throw Error.decoding(error)
            }
        } catch {

            os_log(.error, log: OSLog.default, "Fetching characters for {args:\(args),page:\(page.logable)} @\(endpointURL) failed: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchCharacterAvatar(at url: URL) async throws -> UIImage {

        os_log(.info, log: OSLog.default, "Fetching character avatar @\(url)...")

        do {
            let data = try await performRequest(at: url)

            os_log(.info, log: OSLog.default, "Character avatar @\(url) fetched successfully")

            if let image = UIImage(data: data) {
                return image
            } else {
                os_log(.error, log: OSLog.default, "Character avatar @\(url) is corrupted")
                throw Error.corruptedImage
            }

        } catch {

            os_log(.error, log: OSLog.default, "Fetching character avatar @\(url) failed: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Helpers

    private func performRequest(at url: URL) async throws -> Data {

        let data: Data, response: URLResponse
        do {

            (data, response) = try await urlSession.data(from: url)

        } catch {

            throw Error.transport(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {

            throw Error.invalidResponse(response)
        }

        guard let statusCode = HTTPStatusCode(httpResponse.statusCode) else {

            throw Error.invalidStatusCode(httpResponse.statusCode)
        }

        guard statusCode.responseClass == .successful else {

            switch statusCode.responseClass {
            case .serverError:

                throw Error.server(statusCode: statusCode)

            case .clientError:

                throw Error.client(statusCode: statusCode)
            default:

                throw Error.other(statusCode: statusCode, data: data)
            }
        }

        return data
    }
}
