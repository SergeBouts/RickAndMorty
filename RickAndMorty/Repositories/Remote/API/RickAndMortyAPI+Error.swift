import Foundation

extension RickAndMortyAPI {

    enum Error: Swift.Error {

        /// Invalid request, e.g. invalid URL.
        case invalidRequest(String)

        /// Indicates an error on the transport layer, e.g. not being able to connect to the server.
        case transport(Swift.Error)

        /// Received an invalid response, e.g. non-HTTP result.
        case invalidResponse(URLResponse)

        /// Received an invalid status code.
        case invalidStatusCode(Int)

        /// The server sent data in an unexpected format.
        case decoding(Swift.Error)

        /// General server-side error.
        case server(statusCode: HTTPStatusCode)

        /// Client error.
        case client(statusCode: HTTPStatusCode)

        /// Corrupted image.
        case corruptedImage

        case other(statusCode: HTTPStatusCode, data: Data)
    }


}

extension RickAndMortyAPI.Error: LocalizedError {

    var errorDescription: String? {

        switch self {
        case .invalidRequest(let description): return "Invalid request: \(description)"
        case .transport(let error): return "Transport error: \(error)"
        case .invalidResponse(let data): return "Invalid response: \(data)"
        case .invalidStatusCode(let number): return "Invalid status code: \(number)"
        case .decoding(let error): return "The server returned data in an unexpected format: \(error). Try updating the app."
        case .server(let statusCode): return "Server error, status code: \(statusCode.code)"
        case .client(let statusCode): return "Client error, status code: \(statusCode.code)"
        case .corruptedImage: return "Corrupted image data"
        case .other(let statusCode, _): return "Other error, status code: \(statusCode.code)"
        }
    }
}
