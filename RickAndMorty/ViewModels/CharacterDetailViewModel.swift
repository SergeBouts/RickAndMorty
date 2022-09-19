import Foundation

final class CharacterDetailViewModel: ObservableObject {

    let name: String

    init(characterModel: CharacterModel) {

        self.name = characterModel.name
    }
}
