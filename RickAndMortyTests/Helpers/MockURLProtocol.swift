import Foundation

final class MockURLProtocol: URLProtocol {

    // MARK: - Properties

    // Handler to test the request and return mock response.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    // MARK: - Lifecycle

    // Class methods:

    override class func canInit(with request: URLRequest) -> Bool {
        true // this URL protocol handles all requests
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request // no changes
    }

    // Instance methods:

    override func startLoading() {

        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }

        do {
            guard let client = client else { fatalError("Client is missing") }

            // Call handler with received request and capture the tuple of response and data.
            let (response, data) = try handler(request)

            // Send received response to the client.
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if let data = data {
                // Send received data to the client.
                client.urlProtocol(self, didLoad: data)
            }
            
            // Notify request has been finished.
            client.urlProtocolDidFinishLoading(self)

        } catch {

            // Notify received error.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
