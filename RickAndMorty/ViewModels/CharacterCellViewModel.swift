import Foundation
import UIKit

final class CharacterCellViewModel: ObservableObject {

    // MARK: - Properties

    let name: String
    let episodesCount: Int

    @Published @MainActor var avatarThumb: UIImage?
    let avatarThumbLoader: () async -> UIImage?

    // MARK: - Initialization

    init(characterModel: CharacterModel, avatarThumbLoader: @escaping () async -> UIImage?) {

        self.name = characterModel.name
        self.episodesCount = characterModel.episodes.count
        self.avatarThumbLoader = avatarThumbLoader
    }

    // MARK: - API
    
    func loadAvatarThumb() async {

        let thumb = await avatarThumbLoader()
        await MainActor.run {
            self.avatarThumb = thumb
        }
    }
}
