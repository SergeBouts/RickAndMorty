import Foundation

extension RickAndMortyAPI {

    struct AvatarRemoteAPIRequest {

        struct EndpointSpec: RemoteAPIEndpointSpecProvider {

            var path: String { "/\(RickAndMortyAPI.RootSegment)/character/avatar/\(fileName)" }
            let queryItems: [URLQueryItem]? = nil

            let fileName: String
        }

        struct RequestSpec: RemoteAPIRequestSpecProvider {

            let httpMethod: String? = "GET"
            let headerFields: [(field: String, value: String)]? = nil
            let httpBody: Data? = nil
        }

        let request: URLRequest

        init?(fileName: String) {

            let endpointSpecProvider = EndpointSpec(fileName: fileName)

            let requestSpecProvider = RequestSpec()

            guard let request = RemoteAPIRequest(endpointSpecProvider, requestSpecProvider) else { return nil }

            self.request = request.request
        }
    }
}
