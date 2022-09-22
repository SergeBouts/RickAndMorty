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

        guard let request = CharactersRemoteAPIRequest(args: args, page: page)?.request
        else {

            throw Error.invalidRequest("Invalid URL for characters endpoint for {args:\(args),page:\(page.logable)}")
        }

        os_log(.info, log: OSLog.default, "Fetching characters for {args:\(args),page:\(page.logable)} @\(request)...")

        do {
            let data = try await performRequest(.request(request))

            os_log(.info, log: OSLog.default, "Characters for {args:\(args),page:\(page.logable)} fetched successfully")

            do {

                let charactersResult = try JSONDecoder().decode(Model.CharactersResult.self, from: data)

                return charactersResult
            } catch {

                throw Error.decoding(error)
            }
        } catch {

            os_log(.error, log: OSLog.default, "Fetching characters for {args:\(args),page:\(page.logable)} @\(request) failed: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchCharacterAvatar(at url: URL) async throws -> UIImage {

//        guard let request = AvatarRemoteAPIRequest(fileName: url.lastPathComponent)?.request
//        else {
//
//            throw Error.invalidRequest("Invalid URL for characters endpoint for {url:\(url)}")
//        }

        os_log(.info, log: OSLog.default, "Fetching character avatar @\(url)...")

        do {
            let data = try await performRequest(.url(url))

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

    enum PerformArg {
        case url(URL)
        case request(URLRequest)
    }

    private func performRequest(_ arg: PerformArg) async throws -> Data {

        let data: Data, response: URLResponse
        do {
            switch arg {
            case .url(let url):
                (data, response) = try await urlSession.data(from: url)
            case .request(let request):
                (data, response) = try await urlSession.data(for: request)
            }

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
