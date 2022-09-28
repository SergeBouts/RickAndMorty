import Foundation

extension RickAndMortyAPI {

    struct CharactersRemoteAPIRequest {

        struct EndpointSpec: RemoteAPIEndpointSpecProvider {

            let args: Args
            let page: Int?

            let path: String = "/\(RickAndMortyAPI.RootSegment)/character"
            var queryItems: [URLQueryItem]? {

                var queryItems: [URLQueryItem] = []

                if case .filter(let filter) = args {
                    queryItems = filter.asQueryItems
                }

                if let page = page {
                    queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
                }

                return queryItems
            }
        }

        struct RequestSpec: RemoteAPIRequestSpecProvider {

            let httpMethod: String? = "GET"
            let headerFields: [(field: String, value: String)]? = nil
            let httpBody: Data? = nil
        }

        let request: URLRequest

        init?(args: Args, page: Int? = nil) {

            let endpointSpecProvider = EndpointSpec(args: args, page: page)

            let requestSpecProvider = RequestSpec()

            guard let request = RemoteAPIRequest(endpointSpecProvider, requestSpecProvider) else { return nil }

            self.request = request.request
        }
    }
}
