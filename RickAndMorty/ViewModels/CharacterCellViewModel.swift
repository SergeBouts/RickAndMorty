import Foundation

final class CharacterCellViewModel: ObservableObject {

    let name: String

    init(characterModel: CharacterModel) {

        self.name = characterModel.name
    }
}
