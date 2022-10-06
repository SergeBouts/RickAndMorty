import Foundation

extension RickAndMortyAPI {

    // Model Scope:
    enum Model {

        struct CharactersResult: Equatable {
            let info: Info
            let results: [Character]
        }

        // https://rickandmortyapi.com/documentation/#info-and-pagination
        struct Info: Equatable {
            let count: Int
            let pages: Int
            let next: URL?
            let prev: URL?
        }

        // https://rickandmortyapi.com/documentation/#character
        struct Character: Equatable {
            let id: Int
            let name: String
            let status: Status
            let species: String
            let type: String
            let gender: Gender
            let origin: CharacterOrigin
            let location: CurrentLocation
            let image: URL
            let episode: [URL]
            let url: URL
            let created: String
        }

        struct CharacterOrigin: Equatable {
            let name: String
            let url: URL?
        }

        struct CurrentLocation: Equatable {
            let name: String
            let url: URL?
        }

        enum Status: String, Equatable {
            case alive = "Alive"
            case dead = "Dead"
            case unknown
        }

        enum Gender: String, Equatable {
            case female = "Female"
            case male = "Male"
            case genderless = "Genderless"
            case unknown
        }
    }
}

extension RickAndMortyAPI.Model.CharactersResult: Codable {}

extension RickAndMortyAPI.Model.Info: Codable {}

extension RickAndMortyAPI.Model.Character: Codable {}

extension RickAndMortyAPI.Model.CharacterOrigin: Codable {
    enum CodingKeys: String, CodingKey {
        case name, url
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try? container.decode(URL.self, forKey: .url)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(url?.absoluteString ?? "", forKey: .url)
    }
}

extension RickAndMortyAPI.Model.CurrentLocation: Codable {
    enum CodingKeys: String, CodingKey {
        case name, url
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try? container.decode(URL.self, forKey: .url)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(url?.absoluteString ?? "", forKey: .url)
    }
}

extension RickAndMortyAPI.Model.Status: Codable {}

extension RickAndMortyAPI.Model.Gender: Codable {}

