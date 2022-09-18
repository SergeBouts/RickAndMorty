import Foundation

extension RickAndMortyAPI {

    struct CharactersEndpoint {

        let args: Args
        let page: Int?

        var url: URL? {

            var components = URLComponents()
            components.scheme = RickAndMortyAPI.Scheme
            components.host = RickAndMortyAPI.Host
            components.path = path
            components.queryItems = queryItems.isEmpty ? nil : queryItems
            return components.url
        }

        var path: String { "/\(RickAndMortyAPI.RootSegment)/character" }

        var queryItems: [URLQueryItem] {

            var queryItems: [URLQueryItem] = []

            if case .filter(let filter) = args {
                queryItems = filter.asQueryItems
            }

            if let page = page {
                queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
            }

            return queryItems
        }

        init(args: Args, page: Int? = nil) {

            self.args = args
            self.page = page
        }
    }
}
