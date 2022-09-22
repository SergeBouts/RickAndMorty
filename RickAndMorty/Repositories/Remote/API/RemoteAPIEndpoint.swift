import Foundation

protocol RemoteAPIEndpointSpecProvider {

    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

struct RemoteAPIEndpoint<T: RemoteAPIEndpointSpecProvider> {

    let url: URL

    init?(_ specProvider: T) {

        var components = URLComponents()
        components.scheme = RickAndMortyAPI.Scheme
        components.host = RickAndMortyAPI.Host
        components.path = specProvider.path
        components.queryItems = (specProvider.queryItems ?? []).isEmpty
            ? nil
            : specProvider.queryItems

        guard let url = components.url else { return nil }

        self.url = url
    }
}
