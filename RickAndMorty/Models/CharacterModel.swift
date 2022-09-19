import Foundation

struct CharacterModel: Equatable, Identifiable {

    enum Status: Equatable {
        case alive
        case dead
        case unknown
    }

    enum Gender: Equatable {
        case female
        case male
        case genderless
        case unknown
    }

    struct CurrentLocation: Equatable {
        let name: String
        let url: URL?
    }

    let id: Int
    let name: String
    let status: Status
    let species: String
    let gender: Gender
    let location: CurrentLocation
    let image: URL
    let episodes: [URL]
}
