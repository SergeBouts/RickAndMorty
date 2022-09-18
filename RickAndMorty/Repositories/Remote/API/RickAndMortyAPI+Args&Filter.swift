import Foundation

extension RickAndMortyAPI {

    enum Args {
        case all
        case filter(Filter)
    }

    struct Filter {
        
        let name: String?
        let status: Model.Status?
        let species: String?
        let type: String?
        let gender: Model.Gender?

        init(name: String? = nil, status: Model.Status? = nil, species: String? = nil, type: String? = nil, gender: Model.Gender? = nil) {
            self.name = name
            self.status = status
            self.species = species
            self.type = type
            self.gender = gender
        }

        var asQueryItems: [URLQueryItem] {

            var result: [URLQueryItem] = []
            if let name = name {
                result.append(URLQueryItem(name: "name", value: "\(name)"))
            }
            if let status = status {
                result.append(URLQueryItem(name: "status", value: "\(status.rawValue)"))
            }
            if let species = species {
                result.append(URLQueryItem(name: "species", value: "\(species)"))
            }
            if let type = type {
                result.append(URLQueryItem(name: "type", value: "\(type)"))
            }
            if let gender = gender {
                result.append(URLQueryItem(name: "gender", value: "\(gender.rawValue)"))
            }
            return result
        }
    }
}

extension RickAndMortyAPI.Args: CustomStringConvertible {

    var description: String {

        var result: String = "Args("
        switch self {
        case .all: break
        case .filter(let filter):
            "\(filter)".write(to: &result)
        }
        ")".write(to: &result)
        return result
    }
}

extension RickAndMortyAPI.Filter: CustomStringConvertible {

    var description: String {

        var strings: [String] = []
        if let name = name {
            strings.append("name:\(name)")
        }
        if let status = status {
            strings.append("status:\(status.rawValue)")
        }
        if let species = species {
            strings.append("species:\(species)")
        }
        if let type = type {
            strings.append("type:\(type)")
        }
        if let gender = gender {
            strings.append("gender:\(gender.rawValue)")
        }
        return "Filter(\(strings.joined(separator: ",")))"
    }
}
