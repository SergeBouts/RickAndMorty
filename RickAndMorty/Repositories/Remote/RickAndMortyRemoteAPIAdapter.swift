import Foundation
import UIKit

struct RickAndMortyRemoteAPIAdapter: RickAndMortyRemoteAPI {

    let api: RickAndMortyAPI

    init(api: RickAndMortyAPI = RickAndMortyAPI()) {
        self.api = api
    }

    func fetchCharacters(by filter: CharacterFilter?) async throws -> [CharacterModel] {

        let apiArgs: RickAndMortyAPI.Args
        if let filter = filter {
            let apiFilter = RickAndMortyAPI.Filter(name: filter.name)
            apiArgs = .filter(apiFilter)
        } else {
            apiArgs = .all
        }
        do {
            let charactersResult = try await api.fetchCharacters(apiArgs)
            return charactersResult.results.map(CharacterModel.init(from:))
        } catch {
            if case RickAndMortyAPI.Error.client(let statusCode) = error,
               statusCode.code == 404 {
                return []
            } else {
                throw error
            }
        }
    }

    func fetchCharacterAvatar(at url: URL) async throws -> UIImage {

        try await api.fetchCharacterAvatar(at: url)
    }
}

extension CharacterModel {

    init(from source: RickAndMortyAPI.Model.Character) {

        self.id = source.id
        self.name = source.name
        self.status = .init(from: source.status)
        self.species = source.species
        self.gender = .init(from: source.gender)
        self.location = .init(from: source.location)
        self.image = source.image
        self.episodes = source.episode
    }
}

extension CharacterModel.Status {

    init(from source: RickAndMortyAPI.Model.Status) {

        switch source {
        case .alive:
            self = .alive
        case .dead:
            self = .dead
        case .unknown:
            self = .unknown
        }
    }
}

extension CharacterModel.Gender {

    init(from source: RickAndMortyAPI.Model.Gender) {

        switch source {
        case .female:
            self = .female
        case .male:
            self = .male
        case .genderless:
            self = .genderless
        case .unknown:
            self = .unknown
        }
    }
}

extension CharacterModel.CurrentLocation {

    init(from source: RickAndMortyAPI.Model.CurrentLocation) {

        self.name = source.name
        self.url = source.url
    }
}
