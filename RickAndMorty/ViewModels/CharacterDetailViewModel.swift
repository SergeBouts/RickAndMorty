import Foundation
import UIKit

final class CharacterDetailViewModel: ObservableObject {

    // MARK: - Properties

    let name: String
    let status: String
    let species: String
    let gender: String
    let currentLocation: String

    @Published @MainActor var avatar: UIImage?
    let avatarLoader: () async -> UIImage?

    // MARK: - Initialization

    init(characterModel: CharacterModel, avatarLoader: @escaping () async -> UIImage?) {

        self.name = characterModel.name
        self.status = "\(characterModel.status)".capitalized
        self.species = characterModel.species
        self.gender = "\(characterModel.gender)".capitalized
        self.currentLocation = characterModel.location.name

        self.avatarLoader = avatarLoader
    }

    // MARK: - API
    
    func loadAvatar() async {

        let avatar = await avatarLoader()
        await MainActor.run {
            self.avatar = avatar
        }
    }
}
